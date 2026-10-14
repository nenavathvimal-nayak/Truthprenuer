import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taeed_flutter/models/models.dart';
import 'package:taeed_flutter/models/role_provider.dart';
import 'package:taeed_flutter/models/admin_models.dart';
import 'package:taeed_flutter/repositories/admin_repository.dart';
import 'package:taeed_flutter/repositories/app_providers.dart';
import 'package:taeed_flutter/repositories/realtime_sync_service.dart';
import 'package:taeed_flutter/views/admin/admin_dashboard_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Admin & Realtime Synchronization Unit Tests', () {
    test('UserRole.admin enum and User.isAdmin helper behave correctly', () {
      expect(UserRole.admin.label, 'Admin');
      expect(UserRole.admin.description, contains('Platform governance'));

      final adminUser = User(
        id: 'usr_admin_1',
        name: 'Super Admin',
        username: 'superadmin',
        bio: 'Platform governor',
        role: 'admin',
        userRole: UserRole.admin,
        isVerified: true,
      );
      expect(adminUser.isAdmin, isTrue);

      final founderUser = User(
        id: 'usr_founder_1',
        name: 'Alice Founder',
        username: 'alice',
        bio: 'Building startups',
        role: 'founder',
        userRole: UserRole.founder,
      );
      expect(founderUser.isAdmin, isFalse);
    });

    test('RoleNotifier handles UserRole.admin state transitions', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(roleProvider.notifier);
      expect(container.read(roleProvider), UserRole.founder);

      await notifier.switchRole(UserRole.admin);
      expect(container.read(roleProvider), UserRole.admin);
      expect(notifier.isAdmin, isTrue);
    });

    test('RealtimeSyncState copyWith and default telemetry are safe', () {
      final now = DateTime.now();
      final state = RealtimeSyncState(lastHeartbeat: now);

      expect(state.isConnected, isTrue);
      expect(state.latencyMs, 14);
      expect(state.activeChannels, 3);
      expect(state.recentEvents, isEmpty);

      final updated = state.copyWith(
        latencyMs: 8,
        activeChannels: 4,
        recentEvents: [
          AdminAuditLogItem.now(
            action: 'VALIDATION_MUTATED',
            actorName: 'Supabase Realtime',
            target: 'public:validations',
            details: 'Live mutation event received',
            severity: AuditLogSeverity.info,
          ),
        ],
      );

      expect(updated.latencyMs, 8);
      expect(updated.activeChannels, 4);
      expect(updated.recentEvents.length, 1);
      expect(updated.recentEvents.first.action, 'VALIDATION_MUTATED');
    });

    test('AdminRepository aggregates platform metrics correctly', () async {
      final testValidation = ValidationRequest(
        id: 'val_test',
        authorId: 'usr_test',
        title: 'Test Sprint',
        problem: 'Test Problem',
        solution: 'Test Solution',
        targetAudience: 'Founders',
        status: 'active',
        healthScore: 80,
        upvotes: 5,
        feedbackCount: 3,
        createdAt: DateTime.now(),
      );
      final testUser = User(
        id: 'usr_test',
        name: 'Test Founder',
        username: 'test_founder',
        bio: 'Building tests',
        role: 'Founder',
        userRole: UserRole.founder,
        skills: ['Dart'],
        location: 'Remote',
        isVerified: true,
      );

      final container = ProviderContainer(
        overrides: [
          validationsProvider.overrideWith((ref) => Future.value([testValidation])),
          communityUsersProvider.overrideWithValue([testUser]),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(adminRepositoryProvider);
      final metrics = await repo.getPlatformMetrics();

      expect(metrics.totalValidations, 1);
      expect(metrics.activeValidations, 1);
      expect(metrics.totalUsers, 1);
      expect(metrics.verifiedValidators, 1);
      expect(metrics.totalResponses, 3);
      expect(metrics.averageConvictionScore, 80.0);
    });

    test('AdminRepository updates validation status and user verification without crash', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(adminRepositoryProvider);

      await expectLater(
        repo.updateValidationStatus('val_auto_inventory', 'approved'),
        completes,
      );

      await expectLater(
        repo.toggleUserVerification('usr_1', true),
        completes,
      );

      await expectLater(
        repo.updateUserRole('usr_1', UserRole.admin),
        completes,
      );

      // Verify cache flush does not crash
      expect(() => repo.flushPlatformCache(), returnsNormally);
    });
  });

  group('Admin Dashboard View Widget Tests', () {
    testWidgets('AdminDashboardView renders header, live status, and tab bar', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminDashboardView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('ADMIN CONSOLE'), findsOneWidget);
      expect(find.text('REALTIME LIVE'), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Sprint Moderation'), findsOneWidget);
      expect(find.text('Users & Validators'), findsOneWidget);
      expect(find.text('Realtime Audit Feed'), findsOneWidget);
    });

    testWidgets('Switching tabs in AdminDashboardView shows corresponding panels', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminDashboardView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap 'Sprint Moderation' tab
      await tester.tap(find.text('Sprint Moderation'));
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Featured'), findsOneWidget);
      expect(find.text('Flagged'), findsOneWidget);

      // Tap 'Users & Validators' tab
      await tester.tap(find.text('Users & Validators'));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);

      // Tap 'Realtime Audit Feed' tab
      await tester.tap(find.text('Realtime Audit Feed'));
      await tester.pumpAndSettle();

      expect(find.text('SYSTEM_INITIALIZED'), findsOneWidget);
    });
  });
}
