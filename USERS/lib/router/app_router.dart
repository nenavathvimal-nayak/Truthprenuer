import 'package:flutter/foundation.dart';
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
import '../views/main/dashboard_view.dart';
import '../views/admin/admin_dashboard_view.dart';
import '../models/models.dart';

import '../views/auth/auth_callback_view.dart';
import '../repositories/supabase_client.dart';

class GoRouterAuthNotifier extends ChangeNotifier {
  GoRouterAuthNotifier() {
    try {
      safeSupabaseClient?.auth.onAuthStateChange.listen((_) {
        notifyListeners();
      });
    } catch (_) {}
  }
}

final _authRefreshNotifier = GoRouterAuthNotifier();

String? _extractAuthError(Uri uri) {
  if (uri.queryParameters.containsKey('error_description')) {
    return uri.queryParameters['error_description'];
  }
  if (uri.queryParameters.containsKey('error')) {
    return uri.queryParameters['error'];
  }
  if (uri.fragment.isNotEmpty) {
    try {
      final fragmentParams = Uri.splitQueryString(uri.fragment);
      if (fragmentParams.containsKey('error_description')) {
        return fragmentParams['error_description'];
      }
      if (fragmentParams.containsKey('error')) {
        return fragmentParams['error'];
      }
    } catch (_) {}
  }
  return null;
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: _authRefreshNotifier,
  redirect: (context, state) {
    // Intercept auth errors in deep links (e.g. expired recovery tokens)
    final authError = _extractAuthError(state.uri);
    if (authError != null &&
        state.matchedLocation != '/forgot-password' &&
        state.matchedLocation != '/auth/callback') {
      final cleanMsg = authError.replaceAll('+', ' ');
      return '/forgot-password?error=${Uri.encodeComponent(cleanMsg)}';
    }

    final isRecoveryRoute = (state.matchedLocation == '/change-password' ||
            state.matchedLocation == '/auth/reset-password') &&
        (state.uri.queryParameters['recovery'] == 'true' ||
            state.uri.fragment.contains('type=recovery') ||
            state.uri.queryParameters.containsKey('code') ||
            state.uri.fragment.contains('access_token'));

    // Strict allowlist of public unauthenticated screens
    const publicRoutes = {
      '/splash',
      '/onboarding',
      '/action',
      '/auth',
      '/signup',
      '/otp',
      '/forgot-password',
      '/how-it-works',
      '/about',
      '/faq',
      '/auth/callback',
      '/auth/reset-password',
    };

    final isPublic = publicRoutes.contains(state.matchedLocation) || isRecoveryRoute;

    // Reject admin console in release mode or if accessed externally
    if (!kDebugMode && state.matchedLocation == '/admin') {
      return '/';
    }

    final client = safeSupabaseClient;
    final hasUser = client?.auth.currentUser != null;

    // Zero-Trust: Require active verified session for all protected application screens
    if (!isPublic && !hasUser) {
      final targetUri = state.uri.toString();
      final cleanTarget = targetUri == '/' ? '' : targetUri;
      if (cleanTarget.isNotEmpty) {
        return '/auth?redirect=${Uri.encodeComponent(cleanTarget)}';
      }
      return '/auth';
    }

    // Redirect authenticated users away from authentication pages
    if (hasUser &&
        (state.matchedLocation == '/auth' ||
            state.matchedLocation == '/signup' ||
            state.matchedLocation == '/otp')) {
      final redirectParam = state.uri.queryParameters['redirect'];
      if (redirectParam != null && redirectParam.isNotEmpty) {
        final decoded = Uri.decodeComponent(redirectParam).trim();
        if (decoded.startsWith('/') && !decoded.startsWith('//') && !decoded.contains('://')) {
          return decoded;
        }
      }
      return '/';
    }

    return null;
  },
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
      builder: (context, state) {
        final emailParam = state.uri.queryParameters['email'];
        return OTPVerificationView(initialEmail: emailParam);
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) {
        final errorParam = state.uri.queryParameters['error'];
        return ForgotPasswordView(initialError: errorParam);
      },
    ),
    GoRoute(
      path: '/auth/callback',
      builder: (context, state) {
        final error = state.uri.queryParameters['error_description'] ??
            state.uri.queryParameters['error'] ??
            _extractAuthError(state.uri);
        final code = state.uri.queryParameters['code'];
        final tokenHash = state.uri.queryParameters['token_hash'];
        final type = state.uri.queryParameters['type'];
        return AuthCallbackView(
          initialError: error,
          initialCode: code,
          initialTokenHash: tokenHash,
          initialType: type,
        );
      },
    ),
    GoRoute(
      path: '/auth/reset-password',
      builder: (context, state) => const ChangePasswordView(isRecovery: true),
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
        final extra = state.extra;
        if (extra is Map<String, dynamic> &&
            extra['conversation'] is Conversation &&
            extra['otherUser'] is User) {
          return ChatRoomView(
            conversation: extra['conversation'] as Conversation,
            otherUser: extra['otherUser'] as User,
          );
        }
        return const ChatsListView(
          noticeBanner: "The requested conversation was not found or could not be restored. Please pick a conversation from your list.",
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
      builder: (context, state) {
        final isRecovery = state.uri.queryParameters['recovery'] == 'true' ||
            state.uri.fragment.contains('type=recovery') ||
            state.uri.queryParameters.containsKey('code') ||
            state.uri.fragment.contains('access_token');
        return ChangePasswordView(isRecovery: isRecovery);
      },
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
      path: '/dashboard',
      builder: (context, state) => const DashboardView(),
    ),
    GoRoute(
      path: '/startup-validation',
      builder: (context, state) => const MainTabView(initialIndex: 2),
    ),
    GoRoute(
      path: '/ai-startup-validation',
      builder: (context, state) => const AIValidationView(),
    ),
    GoRoute(
      path: '/human-validation',
      builder: (context, state) => const MainTabView(initialIndex: 2),
    ),
    GoRoute(
      path: '/startup-analysis',
      builder: (context, state) => const StartupHealthDashboardView(),
    ),
    GoRoute(
      path: '/how-it-works',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: '/faq',
      builder: (context, state) => const OnboardingView(),
    ),
    GoRoute(
      path: '/validation-detail/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        final extra = state.extra;
        ValidationRequest? validation;
        User? author;
        if (extra is Map<String, dynamic>) {
          validation = extra['validation'] as ValidationRequest?;
          author = extra['author'] as User?;
        } else if (extra is ValidationRequest) {
          validation = extra;
        }
        return ValidationDetailView(
          validationId: id,
          validation: validation,
          author: author,
        );
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
        final extra = state.extra;
        if (extra is Map<String, dynamic> && extra['user'] is User) {
          return UserProfileView(user: extra['user'] as User);
        } else if (extra is User) {
          return UserProfileView(user: extra);
        }
        return const MainTabView(initialIndex: 4);
      },
    ),
    GoRoute(
      path: '/validation-detail',
      builder: (context, state) {
        final extra = state.extra;
        ValidationRequest? validation;
        User? author;
        if (extra is Map<String, dynamic>) {
          validation = extra['validation'] as ValidationRequest?;
          author = extra['author'] as User?;
        } else if (extra is ValidationRequest) {
          validation = extra;
        }
        final String vid = validation?.id ?? (extra is Map ? extra['id']?.toString() : null) ?? "";
        return ValidationDetailView(
          validationId: vid,
          validation: validation,
          author: author,
        );
      },
    ),
    GoRoute(
      path: '/structured-feedback',
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Map<String, dynamic> &&
            extra['validation'] is ValidationRequest &&
            extra['author'] is User) {
          return StructuredFeedbackView(
            validation: extra['validation'] as ValidationRequest,
            author: extra['author'] as User,
          );
        }
        return const MainTabView(initialIndex: 2);
      },
    ),
    GoRoute(
      path: '/ai-validation',
      builder: (context, state) {
        final extra = state.extra;
        final report = (extra is Map<String, dynamic>)
            ? extra['report'] as AIValidationReport?
            : (extra is AIValidationReport ? extra : null);
        return Scaffold(
          appBar: AppBar(backgroundColor: Theme.of(context).scaffoldBackgroundColor, elevation: 0),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: AIValidationView(report: report),
        );
      },
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardView(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
