import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taeed_flutter/components/buttons.dart';
import 'package:taeed_flutter/models/auth_provider.dart';
import 'package:taeed_flutter/models/models.dart';
import 'package:taeed_flutter/models/role_provider.dart';
import 'package:taeed_flutter/router/app_router.dart';
import 'package:taeed_flutter/views/auth/login_view.dart';
import 'package:taeed_flutter/views/auth/signup_view.dart';
import 'package:taeed_flutter/views/auth/otp_verification_view.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Auth & Authorization Unit Tests', () {
    test('RoleNotifier default initializes to founder and supports role switching', () async {
      final notifier = RoleNotifier();
      expect(notifier.state, equals(UserRole.founder));
      expect(notifier.isFounder, isTrue);

      await notifier.switchRole(UserRole.investor);
      expect(notifier.state, equals(UserRole.investor));
      expect(notifier.isInvestor, isTrue);

      notifier.syncRoleFromProfile(UserRole.professional);
      expect(notifier.state, equals(UserRole.professional));
      expect(notifier.isProfessional, isTrue);
    });

    test('AuthNotifier handles offline / unconfigured state smoothly', () async {
      final notifier = AuthNotifier();
      await Future.delayed(const Duration(milliseconds: 50));
      expect(notifier.state.status, equals(AuthStatus.unauthenticated));

      // Attempting login in preview/offline triggers authentication
      await notifier.login('test@truthprenuer.com', 'password123');
      expect(notifier.state.status, equals(AuthStatus.authenticated));

      // Logout resets session
      await notifier.logout();
      expect(notifier.state.status, equals(AuthStatus.unauthenticated));
    });

    test('AuthNotifier verifyOTP handles mock completion without crash', () async {
      final notifier = AuthNotifier();
      final result = await notifier.verifyOTP('test@truthprenuer.com', '123456');
      expect(result, isTrue);
      expect(notifier.state.status, equals(AuthStatus.authenticated));
    });

    test('AppRouter config contains all auth and private routes with guarded redirection', () {
      final routes = appRouter.configuration.routes;
      final routePaths = routes.map((r) => (r as GoRoute).path).toList();

      expect(routePaths, contains('/auth'));
      expect(routePaths, contains('/signup'));
      expect(routePaths, contains('/otp'));
      expect(routePaths, contains('/forgot-password'));
      expect(routePaths, contains('/profile-setup'));
      expect(routePaths, contains('/validation-wizard'));
    });
  });

  group('Sign Up UI & Form Validation Widget Tests', () {
    testWidgets('SignupView renders all required fields including Confirm Password', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Full Name'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password (min 6 characters)'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('SignupView validates empty fields and shows appropriate feedback', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap PrimaryButton with empty form
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter your full name'), findsOneWidget);
    });

    testWidgets('SignupView detects password mismatch and blocks submission', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SignupView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(4));

      // Enter name
      await tester.enterText(textFields.at(0), 'Nayak Founder');
      // Enter email
      await tester.enterText(textFields.at(1), 'nayak@truthprenuer.com');
      // Enter password
      await tester.enterText(textFields.at(2), 'Pass12345');
      // Enter mismatched confirm password
      await tester.enterText(textFields.at(3), 'Pass99999');

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match. Please verify and try again.'), findsOneWidget);
    });
  });

  group('Log In UI & Error State Widget Tests', () {
    testWidgets('LoginView renders Email, Password, and Forgot Password CTA', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
    });

    testWidgets('LoginView validates invalid email address', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginView(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Enter bad email
      await tester.enterText(textFields.at(0), 'not-an-email');
      await tester.enterText(textFields.at(1), 'Password123');

      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid email address'), findsOneWidget);
    });
  });

  group('OTP Verification UI Widget Tests', () {
    testWidgets('OTPVerificationView displays email and 6-digit input', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OTPVerificationView(initialEmail: 'founder@truthprenuer.com'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Verify Account'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'founder@truthprenuer.com'), findsOneWidget);
      expect(find.byType(PrimaryButton), findsOneWidget);
      expect(find.text('Resend Code'), findsOneWidget);
    });

    testWidgets('OTPVerificationView validates 6-digit code length', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: OTPVerificationView(initialEmail: 'founder@truthprenuer.com'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Enter only 3 digits into the OTP textfield (last TextField)
      await tester.enterText(find.byType(TextField).last, '123');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('Please enter the full 6-digit verification code'), findsOneWidget);
    });
  });
}
