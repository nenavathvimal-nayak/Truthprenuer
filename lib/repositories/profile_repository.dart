import 'dart:typed_data';
import '../utils/app_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import '../models/models.dart';
import 'supabase_client.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(safeSupabaseClient);
});

class ProfileRepository {
  final SupabaseClient? _client;

  ProfileRepository([this._client]);

  Future<User?> getProfile(String userId) async {
    final client = _client;
    if (client == null) return null;

    try {
      final data = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle()
          .timeout(const Duration(seconds: 2));

      if (data == null) return null;

      final roleStr = data['role'] ?? 'Founder';
      final roleEnum = UserRole.values.firstWhere(
        (r) => r.label.toLowerCase() == roleStr.toString().toLowerCase(),
        orElse: () => UserRole.founder,
      );

      final skillsRaw = data['skills'];
      final List<String> skills = skillsRaw is List
          ? skillsRaw.map((s) => s.toString()).toList()
          : [];

      return User(
        id: data['id'],
        name: data['full_name'] ?? 'Founder',
        username: data['username'] ?? 'founder',
        bio: data['bio'] ?? '',
        role: roleStr,
        userRole: roleEnum,
        avatarURL: data['avatar_url'],
        location: data['location'] ?? '',
        website: data['website'] ?? '',
        skills: skills,
        isVerified: data['is_verified'] ?? false,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> updateProfile(User user) async {
    final client = _client;
    if (client == null) return;

    await client.from('profiles').upsert({
      'id': user.id,
      'full_name': user.name,
      'username': user.username,
      'bio': user.bio,
      'role': user.userRole.label,
      'skills': user.skills,
      'location': user.location,
      'website': user.website,
      'updated_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateUserRole(String userId, UserRole role) async {
    final client = _client;
    if (client == null) return;
    try {
      await client.from('profiles').update({
        'role': role.label,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (_) {}
  }

  Future<void> saveProfile(User user) async {
    await updateProfile(user);
  }

  Future<String?> uploadAvatar({
    required String userId,
    required Uint8List bytes,
    required String fileExtension,
  }) async {
    final client = _client;
    if (client == null) return null;

    final fileName = '$userId/avatar_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
    await client.storage.from('avatars').uploadBinary(
      fileName,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);
    await client.from('profiles').update({'avatar_url': publicUrl}).eq('id', userId);
    return publicUrl;
  }

  Future<List<User>> searchProfiles({
    required String query,
    UserRole? roleFilter,
  }) async {
    final client = _client;
    if (client == null) return [];

    try {
      var builder = client.from('profiles').select();
      if (query.trim().isNotEmpty) {
        final safeQuery = _sanitizeForPostgREST(query);
        builder = builder.or('full_name.ilike.%$safeQuery%,username.ilike.%$safeQuery%,bio.ilike.%$safeQuery%');
      }
      if (roleFilter != null) {
        builder = builder.eq('role', roleFilter.label);
      }

      final response = await builder
          .limit(30)
          .timeout(const Duration(seconds: 2));
      return (response as List).map((data) {
        final roleStr = data['role'] ?? 'Founder';
        final roleEnum = UserRole.values.firstWhere(
          (r) => r.label.toLowerCase() == roleStr.toString().toLowerCase(),
          orElse: () => UserRole.founder,
        );
        final skillsRaw = data['skills'];
        final List<String> skills = skillsRaw is List
            ? skillsRaw.map((s) => s.toString()).toList()
            : [];

        return User(
          id: data['id'],
          name: data['full_name'] ?? 'User',
          username: data['username'] ?? 'user',
          bio: data['bio'] ?? '',
          role: roleStr,
          userRole: roleEnum,
          avatarURL: data['avatar_url'],
          location: data['location'] ?? '',
          website: data['website'] ?? '',
          skills: skills,
          isVerified: data['is_verified'] ?? false,
        );
      }).toList();
    } catch (e) {
      AppLogger.error('Failed to fetch data', e, null, 'ProfileRepository');
      return [];
    }
  }

  /// Sanitizes user input for safe use in PostgREST filter strings.
  /// Strips characters that could manipulate query logic.
  String _sanitizeForPostgREST(String input) {
    // Remove PostgREST control characters: parentheses, commas, dots, and filter operators
    return input.replaceAll(RegExp(r'[(),.\\]'), '').trim();
  }
}
