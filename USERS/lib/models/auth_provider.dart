import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/supabase_client.dart';
import '../router/app_router.dart';
import '../repositories/app_providers.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  onboarding,
  authenticated,
  offline,
}

class AuthState {
  final AuthStatus status;
  final bool isFirstLaunch;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.isFirstLaunch = true,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, bool? isFirstLaunch, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref? _ref;
  StreamSubscription? _authSubscription;

  AuthNotifier([this._ref]) : super(const AuthState()) {
    _init();
  }

  static const _keyHasOnboarded = 'auth_has_onboarded';

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool(_keyHasOnboarded) ?? false;

    final client = safeSupabaseClient;
    if (client == null) {
      // Offline / standalone preview mode: user is treated as unauthenticated
      state = AuthState(
        status: AuthStatus.unauthenticated,
        isFirstLaunch: !hasOnboarded,
        errorMessage: 'Supabase client is not initialized',
      );
      return;
    }

    // Check existing session immediately on startup
    final initialSession = client.auth.currentSession;
    if (initialSession != null) {
      state = AuthState(
        status: AuthStatus.authenticated,
        isFirstLaunch: !hasOnboarded,
      );
    } else {
      state = AuthState(
        status: AuthStatus.unauthenticated,
        isFirstLaunch: !hasOnboarded,
      );
    }

    // Supabase Auth as the single source of truth when initialized
    _authSubscription = client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        appRouter.go('/change-password?recovery=true');
      }

      if (event == AuthChangeEvent.signedOut || session == null) {
        resetUserSession();
        state = AuthState(
            status: AuthStatus.unauthenticated, isFirstLaunch: !hasOnboarded);
      } else {
        refreshUserSession();
        state = AuthState(
            status: AuthStatus.authenticated, isFirstLaunch: !hasOnboarded);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  /// Refreshes all user-scoped data providers when user signs in or session is established
  void refreshUserSession() {
    final ref = _ref;
    if (ref != null) {
      ref.invalidate(currentUserProvider);
      ref.invalidate(validationsProvider);
      ref.invalidate(evidenceListProvider);
      ref.invalidate(notificationsProvider);
      ref.invalidate(conversationsProvider);
      ref.invalidate(connectionsProvider);
    }
  }

  /// Explicitly flushes all user-scoped riverpod providers to prevent state contamination
  void resetUserSession() {
    final ref = _ref;
    if (ref != null) {
      resetAllUserScopedProviders(ref);
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasOnboarded, true);
    state = state.copyWith(isFirstLaunch: false);
  }

  Future<void> login(String email, String password) async {
    final client = safeSupabaseClient;
    if (client == null) {
      state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
      refreshUserSession();
      return;
    }
    try {
      final res = await client.auth.signInWithPassword(
        email: email.trim(), 
        password: password,
      );
      if (res.session != null) {
        state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
        refreshUserSession();
      }
    } on AuthException catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString());
      rethrow;
    }
  }

  /// Signs up with Supabase. Returns true if session was created immediately,
  /// or false if an email confirmation link was sent.
  Future<bool> signup(String email, String password, String fullName) async {
    final client = safeSupabaseClient;
    if (client == null) {
      state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
      refreshUserSession();
      return true;
    }
    try {
      final res = await client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': fullName.trim()},
      );
      if (res.session != null) {
        state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
        refreshUserSession();
        return true;
      }
      return false;
    } on AuthException catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString());
      rethrow;
    }
  }

  /// Sends a 6-digit OTP code to the user's email for passwordless sign-in / login.
  Future<void> signInWithOtp(String email, {bool shouldCreateUser = false}) async {
    final client = safeSupabaseClient;
    if (client == null) {
      return;
    }
    try {
      await client.auth.signInWithOtp(
        email: email.trim(),
        shouldCreateUser: shouldCreateUser,
        emailRedirectTo: 'https://truthprenuer.pages.dev/auth/callback',
      );
    } on AuthException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  /// Sends a 6-digit OTP code to sign up a new user with full name metadata.
  Future<void> signUpWithOtp(String email, String fullName) async {
    final client = safeSupabaseClient;
    if (client == null) {
      return;
    }
    try {
      await client.auth.signInWithOtp(
        email: email.trim(),
        shouldCreateUser: true,
        data: {'full_name': fullName.trim()},
        emailRedirectTo: 'https://truthprenuer.pages.dev/auth/callback',
      );
    } on AuthException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  /// Verifies a 6-digit OTP token for login (OtpType.email) or signup (OtpType.signup).
  Future<bool> verifyOTP(String email, String token, {OtpType? type}) async {
    final client = safeSupabaseClient;
    if (client == null) {
      state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
      refreshUserSession();
      return true;
    }
    final primaryType = type ?? OtpType.email;
    try {
      final res = await client.auth.verifyOTP(
        email: email.trim(),
        token: token.trim(),
        type: primaryType,
      );
      if (res.session != null) {
        state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
        refreshUserSession();
        return true;
      }
      return false;
    } on AuthException catch (e) {
      // If primary type verification fails, attempt fallback (e.g. signup vs email OTP)
      if (type == null || type == OtpType.email) {
        try {
          final fallbackRes = await client.auth.verifyOTP(
            email: email.trim(),
            token: token.trim(),
            type: OtpType.signup,
          );
          if (fallbackRes.session != null) {
            state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
            refreshUserSession();
            return true;
          }
        } catch (_) {}
      } else if (type == OtpType.signup) {
        try {
          final fallbackRes = await client.auth.verifyOTP(
            email: email.trim(),
            token: token.trim(),
            type: OtpType.email,
          );
          if (fallbackRes.session != null) {
            state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
            refreshUserSession();
            return true;
          }
        } catch (_) {}
      }
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.toString());
      rethrow;
    }
  }

  /// Resends a 6-digit confirmation or login OTP code to the email address.
  Future<void> resendConfirmationEmail(String email, {OtpType type = OtpType.signup}) async {
    final client = safeSupabaseClient;
    if (client == null) return;
    try {
      if (type == OtpType.email) {
        await client.auth.signInWithOtp(
          email: email.trim(),
          emailRedirectTo: 'https://truthprenuer.pages.dev/auth/callback',
        );
      } else {
        await client.auth.resend(type: type, email: email.trim());
      }
    } on AuthException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      rethrow;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    final client = safeSupabaseClient;
    await client?.auth.signOut();
    resetUserSession();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
