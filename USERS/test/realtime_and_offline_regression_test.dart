import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taeed_flutter/components/adaptive_app_shell.dart';
import 'package:taeed_flutter/models/models.dart';
import 'package:taeed_flutter/repositories/app_providers.dart';
import 'package:taeed_flutter/repositories/network_connectivity_provider.dart';
import 'package:taeed_flutter/views/validation/validation_detail_view.dart';

class FailingMockValidationRepository extends ValidationRepository {
  @override
  Future<bool> toggleUpvote(String validationId, {required bool upvote}) async {
    // Simulates remote network / database constraint failure
    return false;
  }
}

class SuccessfulMockValidationRepository extends ValidationRepository {
  int callCount = 0;
  @override
  Future<bool> toggleUpvote(String validationId, {required bool upvote}) async {
    callCount++;
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('P1: Distributed Counter & Optimistic Rollback for Upvotes', () {
    test('Optimistic update increments count and sets isUpvoted = true', () async {
      final repo = SuccessfulMockValidationRepository();
      final container = ProviderContainer(
        overrides: [
          validationRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(upvotesProvider.notifier);

      // Initial state
      final initial = notifier.getStatus('val_test_1', defaultCount: 10, defaultIsUpvoted: false);
      expect(initial.count, 10);
      expect(initial.isUpvoted, isFalse);

      // Trigger optimistic toggle
      final future = notifier.toggleUpvote('val_test_1', defaultCount: 10, defaultIsUpvoted: false);
      
      // Immediately after triggering, state is optimistically updated
      final optimistic = notifier.getStatus('val_test_1');
      expect(optimistic.count, 11);
      expect(optimistic.isUpvoted, isTrue);

      final success = await future;
      expect(success, isTrue);
      expect(repo.callCount, 1);

      // Toggle back to remove upvote
      final removeSuccess = await notifier.toggleUpvote('val_test_1', defaultCount: 11, defaultIsUpvoted: true);
      expect(removeSuccess, isTrue);
      final finalState = notifier.getStatus('val_test_1');
      expect(finalState.count, 10);
      expect(finalState.isUpvoted, isFalse);
    });

    test('In-flight lock prevents duplicate rapid oscillation', () async {
      final repo = SuccessfulMockValidationRepository();
      final container = ProviderContainer(
        overrides: [
          validationRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(upvotesProvider.notifier);

      // Launch first toggle
      final firstToggle = notifier.toggleUpvote('val_rapid', defaultCount: 5, defaultIsUpvoted: false);
      // Immediately launch second toggle while in-flight lock is active
      final secondToggle = await notifier.toggleUpvote('val_rapid', defaultCount: 5, defaultIsUpvoted: false);

      expect(secondToggle, isFalse, reason: 'Second rapid toggle should be rejected by in-flight lock');
      await firstToggle;
      expect(repo.callCount, 1);
    });

    test('Automatic rollback restores previous count when repository fails', () async {
      final repo = FailingMockValidationRepository();
      final container = ProviderContainer(
        overrides: [
          validationRepositoryProvider.overrideWithValue(repo),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(upvotesProvider.notifier);

      // Trigger toggle which will fail on backend
      final success = await notifier.toggleUpvote('val_fail', defaultCount: 42, defaultIsUpvoted: false);

      expect(success, isFalse);

      // Verifies state was rolled back to initial values
      final rolledBack = notifier.getStatus('val_fail');
      expect(rolledBack.count, 42);
      expect(rolledBack.isUpvoted, isFalse);
    });
  });

  group('P2: Network Connectivity & Offline / Syncing Detection', () {
    test('Transitions from online to offline, syncing, and auto-reconvergence', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(networkConnectivityProvider.notifier);
      expect(container.read(networkConnectivityProvider).isOnline, isTrue);

      // Simulate network disconnection
      notifier.simulateOffline(reason: 'Simulated connection loss');
      expect(container.read(networkConnectivityProvider).isOffline, isTrue);
      expect(container.read(networkConnectivityProvider).failureReason, contains('Simulated connection loss'));

      // Simulate reconnection
      notifier.simulateOnline();
      expect(container.read(networkConnectivityProvider).isOnline, isTrue);
      expect(container.read(networkConnectivityProvider).failureReason, isNull);
    });

    testWidgets('AdaptiveAppShell renders offline banner and retry CTA when offline', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Put into offline mode
      container.read(networkConnectivityProvider.notifier).simulateOffline();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: AdaptiveAppShell(
              selectedIndex: 0,
              onTabSelected: (_) {},
              children: const [
                Text("Dashboard Content"),
              ],
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const ValueKey('offline_banner')), findsOneWidget);
      expect(find.text("Offline. Showing cached empirical data."), findsOneWidget);
      expect(find.byKey(const ValueKey('offline_retry_btn')), findsOneWidget);

      // Tap Retry
      await tester.tap(find.byKey(const ValueKey('offline_retry_btn')));
      await tester.pump();

      // Simulate coming back online
      container.read(networkConnectivityProvider.notifier).simulateOnline();
      await tester.pump();

      // Banner should disappear
      expect(find.byKey(const ValueKey('offline_banner')), findsNothing);
    });
  });

  group('P3: Assistive Live-Region Semantics & Live Feedback', () {
    testWidgets('ValidationDetailView renders endorsement button with live semantics', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final val = ValidationRequest(
        id: 'val_endorse_test',
        authorId: 'author_1',
        title: 'Empirical AI Validator',
        problem: 'Validation takes too long',
        solution: 'Automated synthesis',
        targetAudience: 'Early-stage founders',
        tags: ['AI'],
        upvotes: 15,
        isUpvoted: false,
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: ValidationDetailView(
              validation: val,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final endorseBtn = find.byKey(const ValueKey('validation_endorse_btn'));
      expect(endorseBtn, findsOneWidget);
      expect(find.text('15'), findsOneWidget);

      // Verify semantics
      final semantics = tester.getSemantics(endorseBtn);
      expect(semantics.label, contains('Endorse validation sprint, 15 endorsements'));

      // Tap endorse button
      await tester.tap(endorseBtn);
      await tester.pump();

      // Live count updates to 16
      expect(find.text('16'), findsOneWidget);
      final updatedSemantics = tester.getSemantics(endorseBtn);
      expect(updatedSemantics.label, contains('Remove endorsement from validation sprint, 16 endorsements'));

      // Settle the in-flight lock debounce timer
      await tester.pump(const Duration(milliseconds: 300));
    });
  });
}
