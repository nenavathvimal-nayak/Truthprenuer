import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taeed_flutter/repositories/validation_repository.dart';
import 'package:taeed_flutter/repositories/profile_repository.dart';
import 'package:taeed_flutter/repositories/app_providers.dart';
import 'package:taeed_flutter/models/auth_provider.dart';
import 'package:taeed_flutter/models/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Performance & In-Memory Caching Architecture Tests', () {
    late ValidationRepository validationRepo;
    late ProfileRepository profileRepo;

    setUp(() {
      validationRepo = ValidationRepository(null);
      profileRepo = ProfileRepository(null);
      validationRepo.clearCache();
      profileRepo.clearCache();
    });

    test('ValidationRepository: creates and serves from cache with 0ms network latency', () async {
      final sample = ValidationRequest(
        id: 'val_perf_test_1',
        title: 'High Performance Cache Test',
        problem: 'Slow network roundtrips degrade UX',
        solution: 'In-memory client caching with TTL',
        targetAudience: 'Early Stage Founders',
        authorId: 'test_author',
      );

      // Create validation updates cache
      await validationRepo.createValidation(sample, []);

      // Instant retrieval by ID from cache
      final retrieved = await validationRepo.getValidationById('val_perf_test_1');
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals('val_perf_test_1'));
      expect(retrieved.title, equals('High Performance Cache Test'));

      // Optimistic upvote immediately updates in-memory cached instance
      final upvoteSuccess = await validationRepo.toggleUpvote('val_perf_test_1', upvote: true);
      expect(upvoteSuccess, isTrue);

      final upvoted = await validationRepo.getValidationById('val_perf_test_1');
      expect(upvoted?.upvotes, equals(1));

      // Clear cache wipes memory state
      validationRepo.clearCache();
      final afterClear = await validationRepo.getValidationById('val_perf_test_1');
      expect(afterClear, isNull);
    });

    test('ProfileRepository: updateProfile caches user for instant synchronous retrieval', () async {
      final testUser = User(
        id: 'user_perf_99',
        name: 'Speed Tester',
        username: 'speedster',
        bio: 'Optimizing render passes and memory stores',
        role: 'CTO',
        userRole: UserRole.founder,
      );

      await profileRepo.updateProfile(testUser);

      // Retrieval from cache without network
      final cachedProfile = await profileRepo.getProfile('user_perf_99');
      expect(cachedProfile, isNotNull);
      expect(cachedProfile!.name, equals('Speed Tester'));
      expect(cachedProfile.role, equals('CTO'));

      // Role update mutates cached record immediately
      await profileRepo.updateUserRole('user_perf_99', UserRole.investor);
      final updatedProfile = await profileRepo.getProfile('user_perf_99');
      expect(updatedProfile?.userRole, equals(UserRole.investor));

      // Clear cache flushes the entry
      profileRepo.clearCache('user_perf_99');
      final clearedProfile = await profileRepo.getProfile('user_perf_99');
      expect(clearedProfile, isNull);
    });

    test('authProvider logout flushes validation and profile caches on session logout', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Seed dummy cache entries
      final valRepo = container.read(validationRepositoryProvider);

      final dummy = ValidationRequest(
        id: 'val_dummy_logout',
        title: 'Dummy',
        problem: 'Prob',
        solution: 'Sol',
        targetAudience: 'Aud',
        authorId: 'auth_dummy',
      );
      await valRepo.createValidation(dummy, []);

      // Verify cached
      final cachedBefore = await valRepo.getValidationById('val_dummy_logout');
      expect(cachedBefore, isNotNull);

      // Calling logout flushes session and caches
      await container.read(authProvider.notifier).logout();

      // Verify caches were purged
      final cachedAfter = await valRepo.getValidationById('val_dummy_logout');
      expect(cachedAfter, isNull);
    });
  });
}
