import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/brand_logo.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../design_system/responsive_layout.dart';
import '../../models/auth_provider.dart';
import '../../utils/haptic_manager.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  bool _isEmailNotConfirmed = false;
  bool _isInvalidCredentials = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String _sanitizeRedirect(String? raw) {
    if (raw == null || raw.isEmpty) return '/';
    final decoded = Uri.decodeComponent(raw).trim();
    // Enforce internal path starting with single slash, prevent external / schema / protocol-relative
    if (decoded.startsWith('/') && !decoded.startsWith('//') && !decoded.contains('://')) {
      return decoded;
    }
    return '/';
  }

  void _handleSignIn() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Please enter a valid email address';
        _isEmailNotConfirmed = false;
        _isInvalidCredentials = false;
      });
      return;
    }
    if (password.length < 6) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
        _isEmailNotConfirmed = false;
        _isInvalidCredentials = false;
      });
      return;
    }

    HapticManager.shared.impactMedium();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isEmailNotConfirmed = false;
      _isInvalidCredentials = false;
    });

    try {
      await ref.read(authProvider.notifier).login(email, password);
      if (!mounted) return;
      HapticManager.shared.notificationSuccess();
      final rawRedirect = GoRouterState.of(context).uri.queryParameters['redirect'];
      context.go(_sanitizeRedirect(rawRedirect));
    } catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();

      String errorText = 'Invalid email or password. Please try again.';
      bool unconfirmed = false;
      bool badCreds = false;

      if (e is AuthException) {
        final lowerMsg = e.message.toLowerCase();
        if (lowerMsg.contains('email not confirmed')) {
          errorText = 'Your email has not been verified yet. Check your inbox or enter your verification code.';
          unconfirmed = true;
        } else if (lowerMsg.contains('invalid login credentials') || lowerMsg.contains('invalid credentials')) {
          errorText = 'Invalid email or password. Please check your credentials and try again.';
          badCreds = true;
        } else if (lowerMsg.contains('rate limit') || lowerMsg.contains('over_email_send_rate_limit')) {
          errorText = 'Too many attempts. Please wait a minute and try again.';
        } else {
          errorText = e.message;
        }
      } else {
        final provError = ref.read(authProvider).errorMessage;
        if (provError != null && provError.isNotEmpty) {
          errorText = provError;
        }
      }

      setState(() {
        _isLoading = false;
        _errorMessage = errorText;
        _isEmailNotConfirmed = unconfirmed;
        _isInvalidCredentials = badCreds;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.xl),
        const BrandLogo.mark(size: 56, asEmblem: true),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Welcome Back",
          style: AppTypography.hero.copyWith(color: colors.text),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          "Sign in to continue your validation journey.",
          style: AppTypography.body.copyWith(
            color: colors.textSecondary,
          ),
        ),
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.destructive.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline, color: colors.destructive, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTypography.footnote.copyWith(color: colors.destructive),
                      ),
                    ),
                  ],
                ),
                if (_isEmailNotConfirmed) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final email = _emailController.text.trim();
                          if (email.isNotEmpty) {
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              await ref.read(authProvider.notifier).resendConfirmationEmail(email);
                              if (!mounted) return;
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('Verification link resent to $email'),
                                  backgroundColor: colors.primary,
                                ),
                              );
                            } catch (_) {
                              if (!mounted) return;
                              messenger.showSnackBar(
                                const SnackBar(content: Text('Please wait a moment before resending.')),
                              );
                            }
                          }
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                        child: Text(
                          'Resend verification email',
                          style: TextStyle(color: colors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final email = _emailController.text.trim();
                          context.push('/otp?email=${Uri.encodeComponent(email)}');
                        },
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                        child: Text(
                          'Enter 6-digit code',
                          style: TextStyle(color: colors.text, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ] else if (_isInvalidCredentials) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.push('/forgot-password'),
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                    child: Text(
                      'Forgot your password? Reset it here',
                      style: TextStyle(color: colors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        CustomTextField(
          placeholder: "Email Address",
          controller: _emailController,
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          placeholder: "Password",
          controller: _passwordController,
          icon: Icons.lock_outline,
          isSecure: true,
          textInputAction: TextInputAction.done,
          onSubmitted: _handleSignIn,
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () {
              context.push('/forgot-password');
            },
            child: Text(
              "Forgot Password?",
              style: AppTypography.footnote.copyWith(
                color: colors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          title: "Sign In",
          isLoading: _isLoading,
          action: _handleSignIn,
        ),
      ],
    );

    final bottomAction = Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTypography.callout.copyWith(
            color: colors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            final rawRedirect = GoRouterState.of(context).uri.queryParameters['redirect'];
            if (rawRedirect != null && rawRedirect.isNotEmpty) {
              context.push('/signup?redirect=${Uri.encodeComponent(rawRedirect)}');
            } else {
              context.push('/signup');
            }
          },
          child: Text(
            "Sign Up",
            style: AppTypography.callout.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );

    return AdaptiveAuthLayout(
      form: form,
      bottomAction: bottomAction,
    );
  }
}
