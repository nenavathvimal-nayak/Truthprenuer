import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/supabase_client.dart';
import '../router/app_router.dart';

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
  StreamSubscription? _authSubscription;

  AuthNotifier() : super(const AuthState()) {
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

      if (session != null) {
        state = AuthState(
            status: AuthStatus.authenticated, isFirstLaunch: !hasOnboarded);
      } else {
        state = AuthState(
            status: AuthStatus.unauthenticated, isFirstLaunch: !hasOnboarded);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
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
      return;
    }
    try {
      final res = await client.auth.signInWithPassword(
        email: email, 
        password: password,
      );
      if (res.session != null) {
        state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
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
      return true;
    }
    try {
      final res = await client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      if (res.session != null) {
        state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
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

  Future<void> verifyOTP(String email, String token) async {
    final client = safeSupabaseClient;
    if (client == null) return;
    try {
      final res = await client.auth.verifyOTP(
        email: email.trim(),
        token: token.trim(),
        type: OtpType.signup,
      );
      if (res.session != null) {
        state = state.copyWith(status: AuthStatus.authenticated, errorMessage: null);
      }
    } on AuthException catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: e.message);
      rethrow;
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    final client = safeSupabaseClient;
    if (client == null) return;
    await client.auth.resend(type: OtpType.signup, email: email);
  }

  Future<void> logout() async {
    final client = safeSupabaseClient;
    await client?.auth.signOut();
    state = state.copyWith(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
