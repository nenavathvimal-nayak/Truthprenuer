import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../views/main/main_tab_view.dart';
import '../views/onboarding/splash_view.dart';
import '../views/validation/validation_detail_view.dart';
import '../views/validation/validation_wizard_view.dart';
import '../views/validation/ai_validation_view.dart';
import '../views/validation/structured_feedback_view.dart';
import '../models/startup_health_models.dart';
import '../views/onboarding/onboarding_view.dart';
import '../views/onboarding/action_selection_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/signup_view.dart';
import '../views/auth/otp_verification_view.dart';
import '../views/auth/forgot_password_view.dart';
import '../views/auth/profile_setup_wizard_view.dart';
import '../views/main/search_overlay_view.dart';
import '../views/main/notifications_view.dart';
import '../views/messaging/chats_list_view.dart';
import '../views/messaging/chat_room_view.dart';
import '../views/profile/startup_settings_views.dart';
import '../views/profile/user_profile_view.dart';
import '../views/profile/settings_view.dart';
import '../views/network/top_validators_leaderboard_view.dart';
import '../views/profile/change_password_view.dart';
import '../views/profile/notification_preferences_view.dart';
import '../views/profile/edit_profile_view.dart';
import '../views/validation/startup_health_dashboard_view.dart';
import '../views/validation/evidence_locker_view.dart';
import '../views/main/founder_home_view.dart';
import '../views/main/investor_home_view.dart';
import '../views/main/professional_home_view.dart';
import '../views/main/creator_home_view.dart';
import '../views/main/student_home_view.dart';
import '../models/models.dart';
import '../models/mock_data_store.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: '/action',
      builder: (context, state) => const ActionSelectionView(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const LoginView(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupView(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OTPVerificationView(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordView(),
    ),
    GoRoute(
      path: '/profile-setup',
      builder: (context, state) => const ProfileSetupWizardView(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) {
        final tabParam = state.uri.queryParameters['tab'];
        final index = tabParam != null ? int.tryParse(tabParam) ?? 0 : 0;
        return MainTabView(initialIndex: index);
      },
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const MainTabView(initialIndex: 1),
    ),
    GoRoute(
      path: '/validate',
      builder: (context, state) => const MainTabView(initialIndex: 2),
    ),
    GoRoute(
      path: '/network',
      builder: (context, state) => const MainTabView(initialIndex: 3),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const MainTabView(initialIndex: 4),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchOverlayView(),
    ),
    GoRoute(
      path: '/validation-wizard',
      builder: (context, state) => const ValidationWizardView(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsView(),
    ),
    GoRoute(
      path: '/chats',
      builder: (context, state) => const ChatsListView(),
    ),
    GoRoute(
      path: '/chat-room',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return ChatRoomView(
          conversation: args['conversation'] as Conversation,
          otherUser: args['otherUser'] as User,
        );
      },
    ),
    GoRoute(
      path: '/team-management',
      builder: (context, state) => const TeamManagementView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/change-password',
      builder: (context, state) => const ChangePasswordView(),
    ),
    GoRoute(
      path: '/top-validators',
      builder: (context, state) => const TopValidatorsLeaderboardView(),
    ),
    GoRoute(
      path: '/leaderboard',
      builder: (context, state) => const TopValidatorsLeaderboardView(),
    ),
    GoRoute(
      path: '/startup-health',
      builder: (context, state) => const StartupHealthDashboardView(),
    ),
    GoRoute(
      path: '/evidence-locker',
      builder: (context, state) => const EvidenceLockerView(),
    ),
    GoRoute(
      path: '/founder-home',
      builder: (context, state) => const FounderHomeView(),
    ),
    GoRoute(
      path: '/investor-home',
      builder: (context, state) => const InvestorHomeView(),
    ),
    GoRoute(
      path: '/professional-home',
      builder: (context, state) => const ProfessionalHomeView(),
    ),
    GoRoute(
      path: '/creator-home',
      builder: (context, state) => const CreatorHomeView(),
    ),
    GoRoute(
      path: '/student-home',
      builder: (context, state) => const StudentHomeView(),
    ),
    GoRoute(
      path: '/validation-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final dataStore = MockDataStore();
        final validation = dataStore.validations.firstWhere(
          (v) => v.id == id,
          orElse: () => dataStore.validations.first,
        );
        final author = dataStore.users.firstWhere(
          (u) => u.id == validation.authorId,
          orElse: () => User(
            id: validation.authorId,
            name: validation.authorName ?? 'Founder',
            username: 'founder',
            bio: '',
            role: validation.authorRole ?? 'Builder',
          ),
        );
        return ValidationDetailView(validation: validation, author: author);
      },
    ),
    GoRoute(
      path: '/notification-preferences',
      builder: (context, state) => const NotificationPreferencesView(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileView(),
    ),
    GoRoute(
      path: '/user-profile',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return UserProfileView(user: args['user'] as User);
      },
    ),
    GoRoute(
      path: '/validation-detail',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map<String, dynamic>) {
          return ValidationDetailView(
            validation: extra['validation'] as ValidationRequest,
            author: extra['author'] as User,
          );
        }
        // Fallback: if only validation is passed, look up author from data store
        if (extra is ValidationRequest) {
          final dataStore = MockDataStore();
          final author = dataStore.users.firstWhere(
            (u) => u.id == extra.authorId,
            orElse: () => User(
              id: extra.authorId,
              name: extra.authorName ?? 'Founder',
              username: 'founder',
              bio: '',
              role: extra.authorRole ?? 'Builder',
            ),
          );
          return ValidationDetailView(validation: extra, author: author);
        }
        // Safety fallback
        return const Scaffold(body: Center(child: Text('Invalid navigation')));
      },
    ),
    GoRoute(
      path: '/structured-feedback',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return StructuredFeedbackView(
          validation: args['validation'] as ValidationRequest,
          author: args['author'] as User,
        );
      },
    ),
    GoRoute(
      path: '/ai-validation',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        return Scaffold(
          appBar: AppBar(backgroundColor: Theme.of(context).scaffoldBackgroundColor, elevation: 0),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: AIValidationView(report: args['report'] as AIValidationReport),
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
