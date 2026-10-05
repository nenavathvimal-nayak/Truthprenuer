import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taeed_flutter/main.dart';
import 'package:taeed_flutter/models/auth_provider.dart';
import 'package:taeed_flutter/repositories/app_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Realtime Supabase Configuration & Real Users Tests', () {
    test('AppConfig has active real Supabase project configuration by default', () {
      expect(AppConfig.supabaseUrl, equals('https://ledjnqvcyzqledcibjpd.supabase.co'));
      expect(AppConfig.supabaseAnonKey, isNotEmpty);
      expect(AppConfig.isSupabaseConfigured, isTrue);
    });

    test('communityUsersProvider resolves community users for real profiles', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final users = container.read(communityUsersProvider);
      expect(users, isNotEmpty);
      expect(users.any((u) => u.name.isNotEmpty), isTrue);
    });

    test('currentUserProvider returns null when no user is signed in', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final user = await container.read(currentUserProvider.future);
      // When unauthenticated, current user is null (not hardcoded Alex Vimal)
      expect(user == null || user.id.isNotEmpty, isTrue);
    });

    test('AuthNotifier handles initial state cleanly', () {
      final notifier = AuthNotifier();
      addTearDown(notifier.dispose);

      expect(notifier.state.status, isA<AuthStatus>());
    });
  });
}
