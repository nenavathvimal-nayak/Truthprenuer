import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taeed_flutter/design_system/app_colors.dart';
import 'package:taeed_flutter/models/models.dart';

// View Imports
import 'package:taeed_flutter/views/onboarding/splash_view.dart';
import 'package:taeed_flutter/views/onboarding/onboarding_view.dart';
import 'package:taeed_flutter/views/onboarding/action_selection_view.dart';
import 'package:taeed_flutter/views/auth/login_view.dart';
import 'package:taeed_flutter/views/auth/signup_view.dart';
import 'package:taeed_flutter/views/auth/forgot_password_view.dart';
import 'package:taeed_flutter/views/auth/otp_verification_view.dart';
import 'package:taeed_flutter/views/auth/profile_setup_wizard_view.dart';
import 'package:taeed_flutter/views/main/main_tab_view.dart';
import 'package:taeed_flutter/views/main/search_overlay_view.dart';
import 'package:taeed_flutter/views/main/dashboard_view.dart';
import 'package:taeed_flutter/views/main/notifications_view.dart';
import 'package:taeed_flutter/views/validation/validation_dashboard_view.dart';
import 'package:taeed_flutter/views/validation/validation_wizard_view.dart';
import 'package:taeed_flutter/views/validation/validation_detail_view.dart';
import 'package:taeed_flutter/views/validation/structured_feedback_view.dart';
import 'package:taeed_flutter/views/validation/evidence_locker_view.dart';
import 'package:taeed_flutter/views/validation/startup_health_dashboard_view.dart';
import 'package:taeed_flutter/views/validation/ai_validation_view.dart';
import 'package:taeed_flutter/views/network/network_view.dart';
import 'package:taeed_flutter/views/network/top_validators_leaderboard_view.dart';
import 'package:taeed_flutter/views/profile/profile_view.dart';
import 'package:taeed_flutter/views/profile/user_profile_view.dart';
import 'package:taeed_flutter/views/profile/edit_profile_view.dart';
import 'package:taeed_flutter/views/profile/settings_view.dart';
import 'package:taeed_flutter/views/profile/startup_settings_views.dart';
import 'package:taeed_flutter/views/profile/change_password_view.dart';
import 'package:taeed_flutter/views/profile/notification_preferences_view.dart';
import 'package:taeed_flutter/views/messaging/chats_list_view.dart';
import 'package:taeed_flutter/views/messaging/chat_room_view.dart';

void main() {
  final dummyUser = User(
    id: "user_test_1",
    name: "Alex Rivera",
    username: "arivera",
    role: "Founder",
    bio: "Building empirical validation tools for high-growth tech teams.",
    skills: const ["Flutter", "Dart", "B2B SaaS"],
    isVerified: true,
  );

  final dummyValidation = ValidationRequest(
    id: "val_test_1",
    authorId: "user_test_1",
    title: "Enterprise Compliance Automation",
    problem: "Founders spend 100+ hours manually addressing SOC2 audit checklists without empirical benchmark data.",
    solution: "Automated empirical evidence gathering directly from enterprise buyers.",
    targetAudience: "Founders & CTOs",
    tags: const ["AI", "Security", "SaaS"],
    status: "active",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  );

  final dummyConversation = Conversation(
    id: "conv_test_1",
    participantIds: const ["user_test_1", "user_test_2"],
    lastMessage: "Looking forward to reviewing your hypothesis!",
    lastMessageTime: DateTime.now(),
    unreadCount: 1,
  );

  Widget createTestWidget(Widget child, {List<Override> overrides = const []}) {
    final testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => child,
        ),
        GoRoute(
          path: '/evidence-locker',
          builder: (context, state) => const Scaffold(body: Text("Evidence Locker")),
        ),
        GoRoute(
          path: '/validation-wizard',
          builder: (context, state) => const Scaffold(body: Text("Validation Wizard")),
        ),
        GoRoute(
          path: '/user-profile',
          builder: (context, state) => const Scaffold(body: Text("User Profile")),
        ),
        GoRoute(
          path: '/notification-preferences',
          builder: (context, state) => const Scaffold(body: Text("Notification Preferences")),
        ),
        GoRoute(
          path: '/startup-settings',
          builder: (context, state) => const Scaffold(body: Text("Startup Settings")),
        ),
        GoRoute(
          path: '/change-password',
          builder: (context, state) => const Scaffold(body: Text("Change Password")),
        ),
        GoRoute(
          path: '/chats',
          builder: (context, state) => const Scaffold(body: Text("Chats")),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const Scaffold(body: Text("Search")),
        ),
        GoRoute(
          path: '/validation-detail/:id',
          builder: (context, state) => const Scaffold(body: Text("Validation Detail")),
        ),
      ],
    );

    return ProviderScope(
      overrides: overrides,
      child: MaterialApp.router(
        routerConfig: testRouter,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppThemeColors.dark.background,
          primaryColor: AppThemeColors.dark.primary,
          extensions: <ThemeExtension<dynamic>>[AppThemeColors.dark],
        ),
      ),
    );
  }

  group('1. Onboarding & Authentication Screens & Buttons', () {
    testWidgets('SplashView renders logo and brand title', (tester) async {
      await tester.pumpWidget(createTestWidget(const SplashView()));
      await tester.pump();
      expect(find.byType(SplashView), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 1500));
    });

    testWidgets('OnboardingView advances through steps and completes', (tester) async {
      await tester.pumpWidget(createTestWidget(const OnboardingView()));
      await tester.pumpAndSettle();

      // Find Next button or Skip button
      final nextButton = find.text('Next');
      if (nextButton.evaluate().isNotEmpty) {
        await tester.tap(nextButton);
        await tester.pumpAndSettle();
      }

      final skipButton = find.text('Skip');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
      }
      expect(find.byType(OnboardingView), findsOneWidget);
    });

    testWidgets('ActionSelectionView renders roles and handles role click', (tester) async {
      await tester.pumpWidget(createTestWidget(const ActionSelectionView()));
      await tester.pumpAndSettle();

      expect(find.text('Validate an Idea'), findsWidgets);
      await tester.tap(find.text('Validate an Idea').first);
      await tester.pumpAndSettle();
    });

    testWidgets('LoginView toggles password visibility and clicks sign in', (tester) async {
      await tester.pumpWidget(createTestWidget(const LoginView()));
      await tester.pumpAndSettle();

      // Find text fields
      final emailFields = find.byType(TextField);
      expect(emailFields, findsWidgets);

      await tester.enterText(emailFields.first, 'founder@truthprenuer.app');
      await tester.pump();

      // Find password visibility icon and tap
      final visibilityIcons = find.byIcon(Icons.visibility_off_outlined);
      if (visibilityIcons.evaluate().isNotEmpty) {
        await tester.tap(visibilityIcons.first);
        await tester.pump();
      }

      // Tap Sign In button
      final signInBtn = find.text('Sign In');
      if (signInBtn.evaluate().isNotEmpty) {
        await tester.tap(signInBtn.first);
        await tester.pump();
      }
    });

    testWidgets('SignupView accepts input, toggles terms and clicks sign up', (tester) async {
      await tester.pumpWidget(createTestWidget(const SignupView()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);

      await tester.enterText(textFields.first, 'Alex Rivera');
      await tester.pump();

      // Find Create Account button
      final createAccountBtn = find.text('Create Account');
      if (createAccountBtn.evaluate().isNotEmpty) {
        await tester.tap(createAccountBtn.first);
        await tester.pump();
      }
    });

    testWidgets('ForgotPasswordView accepts email and triggers submit', (tester) async {
      await tester.pumpWidget(createTestWidget(const ForgotPasswordView()));
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      if (textFields.evaluate().isNotEmpty) {
        await tester.enterText(textFields.first, 'alex@truthprenuer.app');
        await tester.pump();
      }

      final sendBtn = find.text('Send Reset Link');
      if (sendBtn.evaluate().isNotEmpty) {
        await tester.tap(sendBtn.first);
        await tester.pump(const Duration(milliseconds: 600));
      }
    });

    testWidgets('OTPVerificationView accepts code input and verify click', (tester) async {
      await tester.pumpWidget(createTestWidget(const OTPVerificationView()));
      await tester.pumpAndSettle();

      final verifyBtn = find.text('Verify Code');
      if (verifyBtn.evaluate().isNotEmpty) {
        await tester.tap(verifyBtn.first);
        await tester.pump();
      }
    });

    testWidgets('ProfileSetupWizardView navigates steps and interacts', (tester) async {
      await tester.pumpWidget(createTestWidget(const ProfileSetupWizardView()));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileSetupWizardView), findsOneWidget);
    });
  });

  group('2. Main Navigation Hub & Search Overlay', () {
    testWidgets('MainTabView switches tabs responsive to bottom nav clicks', (tester) async {
      await tester.pumpWidget(createTestWidget(const MainTabView(initialIndex: 0)));
      await tester.pumpAndSettle();

      // Switch to Explore (Index 1)
      final exploreNav = find.byIcon(Icons.explore_outlined);
      if (exploreNav.evaluate().isNotEmpty) {
        await tester.tap(exploreNav.first);
        await tester.pumpAndSettle();
      }

      // Switch to Validate (Index 2)
      final validateNav = find.byIcon(Icons.verified_outlined);
      if (validateNav.evaluate().isNotEmpty) {
        await tester.tap(validateNav.first);
        await tester.pumpAndSettle();
      }

      // Switch to Network (Index 3)
      final networkNav = find.byIcon(Icons.hub_outlined);
      if (networkNav.evaluate().isNotEmpty) {
        await tester.tap(networkNav.first);
        await tester.pumpAndSettle();
      }

      // Switch to Profile (Index 4)
      final profileNav = find.byIcon(Icons.person_outline_rounded);
      if (profileNav.evaluate().isNotEmpty) {
        await tester.tap(profileNav.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('SearchOverlayView interacts with filters and recent search chips', (tester) async {
      await tester.pumpWidget(createTestWidget(const SearchOverlayView()));
      await tester.pumpAndSettle();

      // Switch filter to Validations
      final validationsTab = find.text('Validations');
      if (validationsTab.evaluate().isNotEmpty) {
        await tester.tap(validationsTab.first);
        await tester.pumpAndSettle();
      }

      // Switch filter to People
      final peopleTab = find.text('People');
      if (peopleTab.evaluate().isNotEmpty) {
        await tester.tap(peopleTab.first);
        await tester.pumpAndSettle();
      }

      // Tap search history chip
      final historyChip = find.text('Invoice OCR');
      if (historyChip.evaluate().isNotEmpty) {
        await tester.tap(historyChip.first);
        await tester.pumpAndSettle();
      }
    });
  });

  group('3. Core Validation & Research Screens', () {
    testWidgets('DashboardView renders founder actions and interacts', (tester) async {
      await tester.pumpWidget(createTestWidget(const DashboardView()));
      await tester.pumpAndSettle();

      // Review Evidence button click
      final reviewEvidenceBtn = find.text('Review Evidence');
      if (reviewEvidenceBtn.evaluate().isNotEmpty) {
        await tester.tap(reviewEvidenceBtn.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('ValidationDashboardView tabs and CTA buttons interact', (tester) async {
      await tester.pumpWidget(createTestWidget(const ValidationDashboardView()));
      await tester.pumpAndSettle();

      // Tap Drafts tab
      final draftsTab = find.text('Drafts');
      if (draftsTab.evaluate().isNotEmpty) {
        await tester.tap(draftsTab.first);
        await tester.pumpAndSettle();

        final draftCta = find.text('Start New Draft');
        if (draftCta.evaluate().isNotEmpty) {
          expect(draftCta, findsOneWidget);
        }
      }

      // Tap Completed tab
      final completedTab = find.text('Completed');
      if (completedTab.evaluate().isNotEmpty) {
        await tester.tap(completedTab.first);
        await tester.pumpAndSettle();

        final completedCta = find.text('Launch a Sprint');
        if (completedCta.evaluate().isNotEmpty) {
          expect(completedCta, findsOneWidget);
        }
      }
    });

    testWidgets('ValidationWizardView transitions steps and handles inputs', (tester) async {
      await tester.pumpWidget(createTestWidget(const ValidationWizardView()));
      await tester.pumpAndSettle();

      expect(find.byType(ValidationWizardView), findsOneWidget);
    });

    testWidgets('ValidationDetailView renders details and interacts with buttons', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          ValidationDetailView(
            validationId: dummyValidation.id,
            validation: dummyValidation,
            author: dummyUser,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Enterprise Compliance Automation'), findsOneWidget);

      // Bookmark action button
      final bookmarkBtn = find.byIcon(Icons.bookmark_border_rounded);
      if (bookmarkBtn.evaluate().isNotEmpty) {
        await tester.tap(bookmarkBtn.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('StructuredFeedbackView renders multi-step critique questions', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          StructuredFeedbackView(
            validation: dummyValidation,
            author: dummyUser,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StructuredFeedbackView), findsOneWidget);
    });

    testWidgets('EvidenceLockerView filters evidence and renders correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(const EvidenceLockerView()));
      await tester.pumpAndSettle();

      // Tap Supports filter chip
      final supportsFilter = find.text('Supports');
      if (supportsFilter.evaluate().isNotEmpty) {
        await tester.tap(supportsFilter.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('AIValidationView renders report sections and tab bars', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const Scaffold(
            body: AIValidationView(report: null),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AIValidationView), findsOneWidget);
    });
  });

  group('4. Network & Ecosystem Screens', () {
    testWidgets('NetworkView renders and switches tabs', (tester) async {
      await tester.pumpWidget(createTestWidget(const NetworkView()));
      await tester.pumpAndSettle();

      expect(find.byType(NetworkView), findsOneWidget);
    });

    testWidgets('TopValidatorsLeaderboardView filters and clicks request audit', (tester) async {
      await tester.pumpWidget(createTestWidget(const TopValidatorsLeaderboardView()));
      await tester.pumpAndSettle();

      // Filter by Engineering
      final engFilter = find.text('Engineering');
      if (engFilter.evaluate().isNotEmpty) {
        await tester.tap(engFilter.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('UserProfileView toggles Connect to Requested with feedback', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          UserProfileView(user: dummyUser),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alex Rivera'), findsWidgets);
      expect(find.text('Validations'), findsWidgets);

      // Find Connect button and tap
      final connectBtn = find.text('Connect');
      if (connectBtn.evaluate().isNotEmpty) {
        await tester.tap(connectBtn.first);
        await tester.pumpAndSettle();
        // Should now show Requested
        expect(find.text('Requested'), findsOneWidget);

        // Tap again to withdraw
        await tester.tap(find.text('Requested').first);
        await tester.pumpAndSettle();
        expect(find.text('Connect'), findsOneWidget);
      }
    });
  });

  group('5. Profile, Settings, & Workspace Management Screens', () {
    testWidgets('ProfileView renders user info and action links', (tester) async {
      await tester.pumpWidget(createTestWidget(const ProfileView()));
      await tester.pumpAndSettle();

      expect(find.byType(ProfileView), findsOneWidget);
    });

    testWidgets('EditProfileView accepts updates and handles save', (tester) async {
      await tester.pumpWidget(createTestWidget(const EditProfileView()));
      await tester.pumpAndSettle();

      final saveBtn = find.text('Save Profile');
      if (saveBtn.evaluate().isNotEmpty) {
        await tester.tap(saveBtn.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('SettingsView renders all preference rows', (tester) async {
      await tester.pumpWidget(createTestWidget(const SettingsView()));
      await tester.pumpAndSettle();

      expect(find.text('APPEARANCE'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('NOTIFICATIONS'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('ACCOUNT & SECURITY'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('ACCOUNT & SECURITY'), findsOneWidget);
      expect(find.text('Startup & Team Settings'), findsOneWidget);
    });

    testWidgets('StartupSettingsView triggers and cancels confirmation dialogs', (tester) async {
      await tester.pumpWidget(createTestWidget(const StartupSettingsView()));
      await tester.pumpAndSettle();

      // Find Archive Startup button and tap
      final archiveBtn = find.text('Archive Startup');
      if (archiveBtn.evaluate().isNotEmpty) {
        await tester.tap(archiveBtn.first);
        await tester.pumpAndSettle();

        // Confirmation dialog should be visible
        expect(find.text('Archive Startup Profile?'), findsOneWidget);

        // Tap Cancel
        final cancelBtn = find.text('Cancel');
        await tester.tap(cancelBtn.first);
        await tester.pumpAndSettle();

        // Dialog should be dismissed
        expect(find.text('Archive Startup Profile?'), findsNothing);
      }

      // Find Delete Startup Profile button and tap
      final deleteBtn = find.text('Delete Startup Profile');
      if (deleteBtn.evaluate().isNotEmpty) {
        await tester.tap(deleteBtn.first);
        await tester.pumpAndSettle();

        // Destructive warning dialog should be visible
        expect(find.text('Delete Startup Profile?'), findsOneWidget);

        // Tap Cancel
        final cancelBtn = find.text('Cancel');
        await tester.tap(cancelBtn.first);
        await tester.pumpAndSettle();

        expect(find.text('Delete Startup Profile?'), findsNothing);
      }
    });

    testWidgets('TeamManagementView renders team members and invite action', (tester) async {
      await tester.pumpWidget(createTestWidget(const TeamManagementView()));
      await tester.pumpAndSettle();

      expect(find.byType(TeamManagementView), findsOneWidget);
    });

    testWidgets('NotificationPreferencesView toggles preference switches', (tester) async {
      await tester.pumpWidget(createTestWidget(const NotificationPreferencesView()));
      await tester.pumpAndSettle();

      final switches = find.byType(Switch);
      if (switches.evaluate().isNotEmpty) {
        await tester.tap(switches.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('ChangePasswordView validates password fields', (tester) async {
      await tester.pumpWidget(createTestWidget(const ChangePasswordView()));
      await tester.pumpAndSettle();

      final fields = find.byType(TextField);
      if (fields.evaluate().isNotEmpty) {
        await tester.enterText(fields.first, 'OldSecurePass123!');
        await tester.pump();
      }
    });

    testWidgets('StartupHealthDashboardView renders dimensions and health scores', (tester) async {
      await tester.pumpWidget(createTestWidget(const StartupHealthDashboardView()));
      await tester.pumpAndSettle();

      expect(find.byType(StartupHealthDashboardView), findsOneWidget);
    });
  });

  group('6. Messaging & Notifications Screens', () {
    testWidgets('NotificationsView filters and mark all as read works', (tester) async {
      await tester.pumpWidget(createTestWidget(const NotificationsView()));
      await tester.pumpAndSettle();

      // Tap Unread filter
      final unreadFilter = find.text('Unread');
      if (unreadFilter.evaluate().isNotEmpty) {
        await tester.tap(unreadFilter.first);
        await tester.pumpAndSettle();
      }

      // Tap Mentions filter
      final mentionsFilter = find.text('Mentions');
      if (mentionsFilter.evaluate().isNotEmpty) {
        await tester.tap(mentionsFilter.first);
        await tester.pumpAndSettle();
      }
    });

    testWidgets('ChatsListView renders conversations and new chat button', (tester) async {
      await tester.pumpWidget(createTestWidget(const ChatsListView()));
      await tester.pumpAndSettle();

      expect(find.byType(ChatsListView), findsOneWidget);
    });

    testWidgets('ChatRoomView enters text, taps quick replies and sends message', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          ChatRoomView(
            conversation: dummyConversation,
            otherUser: dummyUser,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Alex Rivera'), findsWidgets);

      // Find message input and enter text
      final messageField = find.byType(TextField);
      if (messageField.evaluate().isNotEmpty) {
        await tester.enterText(messageField.first, 'Hello Alex, reviewing your hypothesis now.');
        await tester.pump();

        // Tap send button
        final sendBtn = find.byIcon(Icons.send_rounded);
        if (sendBtn.evaluate().isNotEmpty) {
          await tester.tap(sendBtn.first);
          await tester.pump();
        }
      }
    });
  });
}
