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

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isUserAlreadyRegistered = false;
  bool _useOtpSignupMode = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _sanitizeRedirect(String? raw) {
    if (raw == null || raw.isEmpty) return '/';
    final decoded = Uri.decodeComponent(raw).trim();
    if (decoded.startsWith('/') && !decoded.startsWith('//') && !decoded.contains('://')) {
      return decoded;
    }
    return '/';
  }

  void _handleOtpSignUp() async {
    if (_isLoading) return;

    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Please enter your full name';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    if (name.length < 2) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Name must be at least 2 characters';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Please enter a valid email address';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    HapticManager.shared.impactMedium();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isUserAlreadyRegistered = false;
    });

    try {
      await ref.read(authProvider.notifier).signUpWithOtp(email, name);
      if (!mounted) return;
      HapticManager.shared.notificationSuccess();
      final rawRedirect = GoRouterState.of(context).uri.queryParameters['redirect'];
      final redirectParam = rawRedirect != null && rawRedirect.isNotEmpty ? '&redirect=${Uri.encodeComponent(rawRedirect)}' : '';
      context.push('/otp?email=${Uri.encodeComponent(email)}&type=email$redirectParam');
    } catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();

      String errorText = 'Unable to send 6-digit activation code. Please try again.';
      bool userExists = false;

      if (e is AuthException) {
        final msg = e.message.toLowerCase();
        if (msg.contains('already registered') || msg.contains('user already exists')) {
          errorText = 'An account with this email already exists.';
          userExists = true;
        } else if (msg.contains('rate limit') || msg.contains('over_email_send_rate_limit')) {
          errorText = 'Too many sign up requests. Please wait a minute and try again.';
        } else {
          errorText = e.message;
        }
      }

      setState(() {
        _errorMessage = errorText;
        _isUserAlreadyRegistered = userExists;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleSignUp() async {
    if (_isLoading) return;

    final name = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validation
    if (name.isEmpty) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Please enter your full name';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    if (name.length < 2) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Name must be at least 2 characters';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (email.isEmpty || !emailRegex.hasMatch(email)) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Please enter a valid email address';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    if (password.length < 6) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    if (password != confirmPassword) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = 'Passwords do not match. Please verify and try again.';
        _isUserAlreadyRegistered = false;
      });
      return;
    }

    HapticManager.shared.impactMedium();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _isUserAlreadyRegistered = false;
    });

    try {
      final isImmediateSession = await ref.read(authProvider.notifier).signup(email, password, name);
      if (!mounted) return;

      if (isImmediateSession) {
        HapticManager.shared.notificationSuccess();
        final rawRedirect = GoRouterState.of(context).uri.queryParameters['redirect'];
        context.go(_sanitizeRedirect(rawRedirect));
      } else {
        setState(() => _isLoading = false);
        _showEmailSentDialog(email);
      }
    } catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();

      String errorText = 'Failed to create account. Please check your details and try again.';
      bool userExists = false;

      if (e is AuthException) {
        final msg = e.message.toLowerCase();
        if (msg.contains('already registered') || msg.contains('user already exists')) {
          errorText = 'An account with this email already exists.';
          userExists = true;
        } else if (msg.contains('password')) {
          errorText = e.message;
        } else if (msg.contains('rate limit') || msg.contains('over_email_send_rate_limit')) {
          errorText = 'Too many sign up requests. Please wait a minute and try again.';
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
        _isUserAlreadyRegistered = userExists;
      });
    }
  }

  void _showEmailSentDialog(String email) {
    final colors = Theme.of(context).appColors;
    bool isResending = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogContext, setModalState) {
          return AlertDialog(
            backgroundColor: colors.cardBackground,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(Icons.mark_email_read_outlined, color: colors.primary, size: 28),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Verify Your Email",
                    style: AppTypography.title3.copyWith(color: colors.text),
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account created successfully! We sent an activation link and 6-digit confirmation code to:",
                  style: AppTypography.body.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.primary.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    email,
                    style: AppTypography.headline.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "You can enter your 6-digit code directly or click the confirmation link in your inbox.",
                  style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: isResending
                    ? null
                    : () async {
                        setModalState(() => isResending = true);
                        try {
                          await ref.read(authProvider.notifier).resendConfirmationEmail(email);
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('New confirmation email sent to $email'),
                              backgroundColor: colors.primary,
                            ),
                          );
                        } catch (_) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Unable to resend confirmation email. Please wait a moment.')),
                          );
                        } finally {
                          if (dialogContext.mounted) {
                            setModalState(() => isResending = false);
                          }
                        }
                      },
                child: Text(
                  isResending ? "Resending..." : "Resend Email",
                  style: TextStyle(color: colors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.push('/otp?email=${Uri.encodeComponent(email)}&type=signup');
                },
                child: Text(
                  "Enter 6-Digit Code",
                  style: TextStyle(color: colors.primary, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go('/auth');
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(color: colors.text, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    final form = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/auth');
            }
          },
          child: Icon(
            Icons.arrow_back,
            size: 26,
            color: colors.text,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const BrandLogo.mark(size: 56, asEmblem: true),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Create Account",
          style: AppTypography.hero.copyWith(color: colors.text),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          "Join a decentralized community of empirical builders.",
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
                if (_isUserAlreadyRegistered) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => context.go('/auth'),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                        child: Text(
                          'Sign In instead',
                          style: TextStyle(color: colors.primary, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
                        child: Text(
                          'Reset Password',
                          style: TextStyle(color: colors.textSecondary, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
        // Mode Selector: Password vs 6-Digit OTP Sign Up
        Container(
          margin: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _useOtpSignupMode = false;
                    _errorMessage = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: !_useOtpSignupMode ? colors.primary.withAlpha(30) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        "Password Sign Up",
                        style: AppTypography.footnote.copyWith(
                          color: !_useOtpSignupMode ? colors.primary : colors.textSecondary,
                          fontWeight: !_useOtpSignupMode ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _useOtpSignupMode = true;
                    _errorMessage = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _useOtpSignupMode ? colors.primary.withAlpha(30) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pin_outlined, size: 16, color: _useOtpSignupMode ? colors.primary : colors.textSecondary),
                          const SizedBox(width: 6),
                          Text(
                            "6-Digit OTP",
                            style: AppTypography.footnote.copyWith(
                              color: _useOtpSignupMode ? colors.primary : colors.textSecondary,
                              fontWeight: _useOtpSignupMode ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        CustomTextField(
          placeholder: "Full Name",
          controller: _fullNameController,
          icon: Icons.person_outline,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        CustomTextField(
          placeholder: "Email Address",
          controller: _emailController,
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          textInputAction: _useOtpSignupMode ? TextInputAction.done : TextInputAction.next,
          onSubmitted: _useOtpSignupMode ? _handleOtpSignUp : null,
        ),
        if (!_useOtpSignupMode) ...[
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            placeholder: "Password (min 6 characters)",
            controller: _passwordController,
            icon: Icons.lock_outline,
            isSecure: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            placeholder: "Confirm Password",
            controller: _confirmPasswordController,
            icon: Icons.lock_reset_outlined,
            isSecure: true,
            textInputAction: TextInputAction.done,
            onSubmitted: _handleSignUp,
          ),
        ] else ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            "We will send a 6-digit activation code to your email. No password needed.",
            style: AppTypography.footnote.copyWith(color: colors.textSecondary),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        PrimaryButton(
          title: _useOtpSignupMode ? "Send 6-Digit Activation Code" : "Sign Up",
          isLoading: _isLoading,
          action: _useOtpSignupMode ? _handleOtpSignUp : _handleSignUp,
        ),
        if (!_useOtpSignupMode) ...[
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() {
                _useOtpSignupMode = true;
                _errorMessage = null;
              }),
              icon: Icon(Icons.pin_outlined, size: 18, color: colors.primary),
              label: Text(
                "Sign up with 6-digit OTP code (passwordless)",
                style: AppTypography.footnote.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: () => setState(() {
                _useOtpSignupMode = false;
                _errorMessage = null;
              }),
              child: Text(
                "Switch back to standard sign up with password",
                style: AppTypography.footnote.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );

    final bottomAction = Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppTypography.callout.copyWith(
            color: colors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () {
            context.go('/auth');
          },
          child: Text(
            "Sign In",
            style: AppTypography.callout.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );

    return AdaptiveAuthLayout(
      heroTitle: "Build With Hard Evidence,\nNot Opinions",
      heroSubtitle: "Validate customer demand, test pricing thresholds, and calculate genuine PMF with truth-seeking peers.",
      form: form,
      bottomAction: bottomAction,
    );
  }
}
