import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AuthStatus {
  unknown,
  unauthenticated,
  onboarding,
  authenticated,
}

class AuthState {
  final AuthStatus status;
  final bool isFirstLaunch;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.isFirstLaunch = true,
  });

  AuthState copyWith({AuthStatus? status, bool? isFirstLaunch}) {
    return AuthState(
      status: status ?? this.status,
      isFirstLaunch: isFirstLaunch ?? this.isFirstLaunch,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  static const _keyIsLoggedIn = 'auth_is_logged_in';
  static const _keyHasOnboarded = 'auth_has_onboarded';

  bool get _isSupabaseActive {
    final url = dotenv.env['SUPABASE_URL'];
    return url != null && url.isNotEmpty && url != 'your_project_url_here';
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final hasOnboarded = prefs.getBool(_keyHasOnboarded) ?? false;

    if (_isSupabaseActive) {
      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          state = AuthState(status: AuthStatus.authenticated, isFirstLaunch: !hasOnboarded);
        } else {
          state = AuthState(status: AuthStatus.unauthenticated, isFirstLaunch: !hasOnboarded);
        }
      });
    } else {
      final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
      if (isLoggedIn) {
        state = AuthState(status: AuthStatus.authenticated, isFirstLaunch: !hasOnboarded);
      } else if (hasOnboarded) {
        state = const AuthState(status: AuthStatus.unauthenticated, isFirstLaunch: false);
      } else {
        state = const AuthState(status: AuthStatus.unauthenticated, isFirstLaunch: true);
      }
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasOnboarded, true);
    state = state.copyWith(isFirstLaunch: false);
  }

  Future<void> login(String email, String password) async {
    if (_isSupabaseActive) {
      await Supabase.instance.client.auth.signInWithPassword(email: email, password: password);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setBool(_keyHasOnboarded, true);
      state = const AuthState(status: AuthStatus.authenticated, isFirstLaunch: false);
    }
  }

  Future<void> signup(String email, String password, String fullName) async {
    if (_isSupabaseActive) {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
    } else {
      await login(email, password);
    }
  }

  Future<void> logout() async {
    if (_isSupabaseActive) {
      await Supabase.instance.client.auth.signOut();
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, false);
      state = const AuthState(status: AuthStatus.unauthenticated, isFirstLaunch: false);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
