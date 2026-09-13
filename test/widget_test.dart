import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taeed_flutter/main.dart';
import 'package:taeed_flutter/models/mock_data_store.dart';
import 'package:taeed_flutter/views/main/search_overlay_view.dart';
import 'package:taeed_flutter/views/profile/builder_profile_view.dart';
import 'package:taeed_flutter/views/validation/startup_health_dashboard_view.dart';
import 'package:taeed_flutter/views/messaging/chats_list_view.dart';
import 'package:taeed_flutter/views/messaging/chat_room_view.dart';
import 'package:taeed_flutter/views/profile/settings_view.dart';
import 'package:taeed_flutter/views/profile/change_password_view.dart';
import 'package:taeed_flutter/views/profile/notification_preferences_view.dart';
import 'package:taeed_flutter/views/validation/evidence_locker_view.dart';
import 'package:taeed_flutter/models/mock_data_store_provider.dart';
import 'package:taeed_flutter/views/main/main_tab_view.dart';

import 'package:taeed_flutter/views/network/top_validators_leaderboard_view.dart';
import 'package:taeed_flutter/views/main/founder_home_view.dart';
import 'package:taeed_flutter/views/main/explore_view.dart';
import 'package:taeed_flutter/design_system/theme_mode_provider.dart';

void main() {

  group('TAEED End-to-End & Component Tests', () {
    testWidgets('1. App Launch & Splash Smoke Test', (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: TAEEDApp()));
      expect(find.text('TRUTHPRENUER'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });

    test('2. MockDataStore Seed & Operations Verification', () {
      final store = MockDataStore();
      expect(store.users.isNotEmpty, isTrue);
      expect(store.validations.isNotEmpty, isTrue);
      expect(store.posts.isNotEmpty, isTrue);
      expect(store.conversations.isNotEmpty, isTrue);

      // Test upvoting
      final firstValidation = store.validations.first;
      final initialUpvotes = firstValidation.upvotes;
      store.toggleUpvote(firstValidation.id);
      expect(firstValidation.isUpvoted, isTrue);
      expect(firstValidation.upvotes, equals(initialUpvotes + 1));

      // Test bookmarking
      expect(firstValidation.isBookmarked, isFalse);
      store.toggleBookmark(firstValidation.id);
      expect(firstValidation.isBookmarked, isTrue);

      // Test post likes
      final firstPost = store.posts.first;
      expect(firstPost.isLiked, isFalse);
      store.togglePostLike(firstPost.id);
      expect(firstPost.isLiked, isTrue);
    });

    testWidgets('3. BuilderProfileView renders user information and tabs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: BuilderProfileView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('My Profile'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Validations'), findsWidgets);
    });

    testWidgets('4. SearchOverlayView performs live search filtering',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SearchOverlayView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('POPULAR SEARCHES'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter search term
      await tester.enterText(find.byType(TextField), 'Alex');
      await tester.pumpAndSettle();

      expect(find.textContaining('Alex'), findsWidgets);
    });

    testWidgets('5. StartupHealthDashboardView renders dimensions correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: StartupHealthDashboardView()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Validation Health Index'), findsOneWidget);
      expect(find.text('Problem Strength'), findsOneWidget);
    });

    testWidgets('6. AI Mentor appears as a conversation candidate in Chats list',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChatsListView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Messages'), findsOneWidget);
      expect(find.text('TAEED AI Mentor'), findsOneWidget);
      expect(find.textContaining('GTM strategy'), findsWidgets);
    });

    testWidgets('7. MainTabView renders 5 professional tabs: HOME, EXPLORE, VALIDATE, NETWORK, PROFILE',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: MainTabView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('HOME'), findsOneWidget);
      expect(find.text('EXPLORE'), findsOneWidget);
      expect(find.text('VALIDATE'), findsOneWidget);
      expect(find.text('NETWORK'), findsOneWidget);
      expect(find.text('PROFILE'), findsOneWidget);

      // Tap on VALIDATE tab
      await tester.tap(find.text('VALIDATE'));
      await tester.pumpAndSettle();

      // Ensure no modal bottom sheet blocked it and the tab is active
      expect(find.text('Startup Health'), findsWidgets);
    });

    testWidgets('8. Search bar is removed from Home and present on Explore screen',
        (WidgetTester tester) async {
      // 1. Verify Home screen has NO search field
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: FounderHomeView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Search ideas, validations, people...'), findsNothing);
      expect(find.text('Turn your idea into evidence.'), findsOneWidget);

      // 2. Verify Explore screen HAS the search field
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ExploreView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Discovery Engine'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search ideas, validations, people...'), findsOneWidget);

      // 3. Test typing into Explore search field
      await tester.enterText(find.byType(TextField), 'SaaS');
      await tester.pumpAndSettle();

      // Clear button should now appear
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    test('9. ThemeModeNotifier toggles between dark and light modes', () {
      final container = ProviderContainer();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));

      container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.light));

      container.read(themeModeProvider.notifier).toggleTheme();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
    });

    test('10. MockDataStore updateUserAvatar modifies user avatar and notifies listeners', () {
      final store = MockDataStore();
      final initialAvatar = store.currentUser?.avatarURL;
      const testAvatar = "https://images.unsplash.com/photo-test-avatar.jpg";

      var notified = false;
      store.addListener(() {
        notified = true;
      });

      store.updateUserAvatar(testAvatar);
      expect(store.currentUser?.avatarURL, equals(testAvatar));
      expect(notified, isTrue);
      expect(store.currentUser?.avatarURL, isNot(equals(initialAvatar)));
    });

    test('11. MockDataStore messaging operations (send, react, pin, unread)', () {
      final store = MockDataStore();
      final conv = store.conversations.first;
      
      // Test sending message with attachment
      store.sendMessage(
        conv.id,
        "Here is our deck",
        attachmentType: "pitch_deck",
        attachmentTitle: "Seed_Deck.pdf",
        attachmentSubtitle: "10 slides",
      );

      final lastMsg = store.messages.last;
      expect(lastMsg.text, equals("Here is our deck"));
      expect(lastMsg.attachmentType, equals("pitch_deck"));
      expect(lastMsg.attachmentTitle, equals("Seed_Deck.pdf"));

      // Test message reaction
      store.reactToMessage(lastMsg.id, "🚀");
      expect(lastMsg.reaction, equals("🚀"));
      store.reactToMessage(lastMsg.id, "🚀"); // toggle off
      expect(lastMsg.reaction, isNull);

      // Test pin and unread
      final initialPin = conv.isPinned;
      store.togglePin(conv.id);
      expect(conv.isPinned, equals(!initialPin));

      store.markConversationAsUnread(conv.id);
      expect(conv.unreadCount, equals(1));
      store.markConversationAsRead(conv.id);
      expect(conv.unreadCount, equals(0));
    });

    testWidgets('12. ChatsListView renders conversations, search, and composer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChatsListView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Messages'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Tap compose button
      await tester.tap(find.byIcon(Icons.edit_square));
      await tester.pumpAndSettle();

      expect(find.text('New Message'), findsOneWidget);
    });

    testWidgets('13. ChatRoomView renders messages, sends a text message, and displays bubbles',
        (WidgetTester tester) async {
      final store = MockDataStore();
      final conv = store.conversations.first;
      final other = store.otherUser(conv)!;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            mockDataStoreProvider.overrideWith((ref) => store),
          ],
          child: MaterialApp(
            home: ChatRoomView(
              conversation: conv,
              otherUser: other,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text(other.name), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Send a message
      await tester.enterText(find.byType(TextField), 'Testing message send');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pump();

      expect(find.text('Testing message send'), findsOneWidget);

      // Settle simulated auto-reply timers
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();
    });

    testWidgets('14. ChangePasswordView renders and validates password strength',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChangePasswordView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Update Password'), findsOneWidget);

      // Enter new password to trigger strength indicator
      final textFields = find.byType(TextFormField);
      expect(textFields, findsNWidgets(3));

      await tester.enterText(textFields.at(1), 'Secret123!');
      await tester.pumpAndSettle();

      expect(find.text('Security Level'), findsOneWidget);
    });

    testWidgets('15. NotificationPreferencesView renders granular toggles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: NotificationPreferencesView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Notification Preferences'), findsOneWidget);
      expect(find.text('Structured Feedback Alerts'), findsOneWidget);
      expect(find.text('Save Preferences'), findsOneWidget);

      // Scroll and tap Save Preferences
      await tester.ensureVisible(find.text('Save Preferences'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save Preferences'));
      await tester.pump();
    });

    testWidgets('16. SettingsView renders security, data export, and legal dialogs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SettingsView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('Change Password'), findsOneWidget);
      expect(find.text('Export My Data'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);

      // Tap Export My Data
      await tester.ensureVisible(find.text('Export My Data'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Export My Data'));
      await tester.pumpAndSettle();
      expect(find.text('Export Your Startup Data'), findsOneWidget);
      expect(find.text('Generate Archive (.json)'), findsOneWidget);
      await tester.ensureVisible(find.text('Generate Archive (.json)'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Generate Archive (.json)'));
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.pumpAndSettle();
      expect(find.textContaining('truthprenuer_export.json'), findsOneWidget);
    });

    testWidgets('17. StartupHealthDashboardView renders radial gauge, 4-week progression, and category filters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: StartupHealthDashboardView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Validation Health Index'), findsOneWidget);
      expect(find.text('HEALTH'), findsOneWidget);
      expect(find.text('4-Week Health Progression'), findsOneWidget);
      expect(find.text('Export Audit PDF'), findsOneWidget);
      expect(find.text('Share with Angels'), findsOneWidget);

      // Filter by Product & Tech
      await tester.tap(find.text('Product & Tech'));
      await tester.pumpAndSettle();
      expect(find.text('Solution Readiness'), findsOneWidget);
      expect(find.text('Product Readiness'), findsOneWidget);

      // Tap dimension card to expand recommendation
      await tester.tap(find.text('Solution Readiness'));
      await tester.pumpAndSettle();
      expect(find.text('AI RECOMMENDATION'), findsOneWidget);

      // Tap action button inside expanded card
      await tester.ensureVisible(find.text('Launch Prototype Test Sprint'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Launch Prototype Test Sprint'));
      await tester.pumpAndSettle();
      expect(find.text('Execute Strategic Recommendation'), findsOneWidget);
    });

    testWidgets('18. EvidenceLockerView displays evidence items and opens Add Evidence sheet',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: EvidenceLockerView()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Evidence Locker'), findsOneWidget);
      expect(find.text('Log Evidence'), findsOneWidget);
      expect(find.text('All Evidence'), findsOneWidget);
      expect(find.text('Raw Feedback'), findsOneWidget);

      // Tap Log Evidence
      await tester.tap(find.text('Log Evidence'));
      await tester.pumpAndSettle();
      expect(find.text('Log Empirical Evidence'), findsOneWidget);
      expect(find.text('Save to Evidence Locker'), findsOneWidget);
    });

    testWidgets('19. ExploreView renders search, filter modal, and top validators rail',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: ExploreView()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Discovery Engine'), findsOneWidget);
      expect(find.text('Top Validators'), findsOneWidget);
      expect(find.text('Rankings →'), findsOneWidget);
      expect(find.byIcon(Icons.tune), findsOneWidget);

      // Open Filter Modal
      await tester.tap(find.byIcon(Icons.tune));
      await tester.pumpAndSettle();
      expect(find.text('Discovery Filters'), findsOneWidget);
      expect(find.text('STARTUP STAGE'), findsOneWidget);
      expect(find.text('SORT ORDER'), findsOneWidget);
      expect(find.text('Apply Filters'), findsOneWidget);

      // Select Prototype stage and apply
      await tester.tap(find.text('Prototype'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Apply Filters'));
      await tester.pumpAndSettle();
    });

    testWidgets('20. TopValidatorsLeaderboardView displays rankings, disciplines, and review request',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TopValidatorsLeaderboardView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Validator Leaderboard'), findsOneWidget);
      expect(find.text('Truth Score™ Rankings'), findsOneWidget);
      expect(find.text('GTM & Growth'), findsOneWidget);
      expect(find.text('#1'), findsOneWidget);

      // Tap Request Review on the top validator
      expect(find.text('Request Review'), findsWidgets);
      await tester.tap(find.text('Request Review').first);
      await tester.pumpAndSettle();

      expect(find.text('SPECIFIC FEEDBACK QUESTIONS'), findsOneWidget);
      expect(find.text('Send Review Request'), findsOneWidget);
    });
  });
}


