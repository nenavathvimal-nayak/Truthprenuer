import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(safeSupabaseClient);
});

class AuthRepository {
  final SupabaseClient? _client;

  AuthRepository(this._client);

  User? get currentUser => _client?.auth.currentUser;
  Session? get currentSession => _client?.auth.currentSession;
  bool get isAuthenticated => currentSession != null;

  Stream<AuthState> get authStateChanges =>
      _client?.auth.onAuthStateChange ?? const Stream.empty();

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? fullName,
    String? username,
  }) async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        if (fullName != null) 'full_name': fullName.trim(),
        if (username != null) 'username': username.trim(),
      },
    );
  }

  Future<AuthResponse> verifyOTP({
    required String email,
    required String token,
  }) async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.verifyOTP(
      email: email.trim(),
      token: token.trim(),
      type: OtpType.signup,
    );
  }

  Future<void> resetPasswordForEmail(String email) async {
    if (_client == null) return;
    await _client.auth.resetPasswordForEmail(email.trim());
  }

  Future<UserResponse> updatePassword(String newPassword) async {
    if (_client == null) throw Exception('Supabase not configured');
    return await _client.auth.updateUser(
      UserAttributes(password: newPassword),
    );
  }

  Future<void> signOut() async {
    await _client?.auth.signOut();
  }

  Future<void> deleteAccount() async {
    final user = currentUser;
    if (user != null && _client != null) {
      await _client.from('profiles').delete().eq('id', user.id);
      await signOut();
    }
  }
}
