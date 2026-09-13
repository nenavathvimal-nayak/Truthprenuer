import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    final hasOnboarded = prefs.getBool(_keyHasOnboarded) ?? false;

    if (isLoggedIn) {
      state = AuthState(status: AuthStatus.authenticated, isFirstLaunch: !hasOnboarded);
    } else if (hasOnboarded) {
      state = AuthState(status: AuthStatus.unauthenticated, isFirstLaunch: false);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated, isFirstLaunch: true);
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasOnboarded, true);
    state = state.copyWith(isFirstLaunch: false);
  }

  Future<void> login() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setBool(_keyHasOnboarded, true);
    state = AuthState(status: AuthStatus.authenticated, isFirstLaunch: false);
  }

  Future<void> signup() async {
    await login(); // Same persistence for MVP
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    state = AuthState(status: AuthStatus.unauthenticated, isFirstLaunch: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
