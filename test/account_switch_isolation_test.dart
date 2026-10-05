import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taeed_flutter/models/auth_provider.dart';
import 'package:taeed_flutter/models/startup_health_models.dart';
import 'package:taeed_flutter/repositories/app_providers.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('P0: Account-Switch State Contamination Regression Tests', () {
    test('Session reset flushes user-scoped providers on logout', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // 1. Initial seeded state
      final notifsBefore = container.read(notificationsProvider);
      expect(notifsBefore.isNotEmpty, isTrue);

      // 2. Simulate User A modifying state
      container.read(notificationsProvider.notifier).markAllNotificationsRead();
      final allRead = container.read(notificationsProvider).every((n) => n.isRead);
      expect(allRead, isTrue);

      // Add a custom evidence item as User A
      final customEvidence = EvidenceItem(
        id: "ev_user_a_private",
        validationId: "val_auto_inventory",
        type: EvidenceItemType.interview,
        title: "User A Confidential Survey",
        summary: "Private customer interview notes",
        confidenceScore: 99,
        keyInsight: "Critical insight",
        classification: EvidenceClassification.supports,
        tags: ["Private"],
        createdAt: DateTime.now(),
      );
      container.read(evidenceListProvider.notifier).addEvidence(customEvidence);
      expect(container.read(evidenceListProvider).any((e) => e.id == "ev_user_a_private"), isTrue);

      // 3. User A logs out
      await container.read(authProvider.notifier).logout();

      // 4. Verify user session reset wiped User A mutations from user-scoped providers
      final evidenceAfterLogout = container.read(evidenceListProvider);
      expect(evidenceAfterLogout.any((e) => e.id == "ev_user_a_private"), isFalse);

      final notifsAfterLogout = container.read(notificationsProvider);
      expect(notifsAfterLogout.any((n) => !n.isRead), isTrue,
          reason: 'Initial unread notifications should be restored rather than keeping User A read state');
    });

    test('ConnectionsNotifier supports multi-state transitions and prevents rapid oscillations', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(connectionsProvider.notifier);

      // 1. Elena Rostova sent us a request -> initial state is received
      expect(notifier.getStatus('user_elena'), ConnectionStatus.received);

      // 2. When we send/accept Elena's request, resolves to connected without deadlock
      await notifier.sendOrToggleRequest('user_elena');
      expect(notifier.getStatus('user_elena'), ConnectionStatus.connected);

      // 3. Target user with no request -> state transitions to requested
      expect(notifier.getStatus('user_marcus'), ConnectionStatus.none);
      await notifier.sendOrToggleRequest('user_marcus');
      expect(notifier.getStatus('user_marcus'), ConnectionStatus.requested);

      // 4. Tapping requested user again withdraws request back to none
      await notifier.sendOrToggleRequest('user_marcus');
      expect(notifier.getStatus('user_marcus'), ConnectionStatus.none);
    });
  });
}
