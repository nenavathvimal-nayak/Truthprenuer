import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/auth_provider.dart';
import '../../utils/haptic_manager.dart';

class OTPVerificationView extends ConsumerStatefulWidget {
  final String? initialEmail;
  const OTPVerificationView({super.key, this.initialEmail});

  @override
  ConsumerState<OTPVerificationView> createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends ConsumerState<OTPVerificationView> {
  late final TextEditingController _emailController;
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_emailController.text.isEmpty) {
      final queryEmail = GoRouterState.of(context).uri.queryParameters['email'];
      if (queryEmail != null && queryEmail.isNotEmpty) {
        _emailController.text = Uri.decodeComponent(queryEmail).trim();
      }
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _cooldownSeconds = 60);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_cooldownSeconds <= 1) {
        timer.cancel();
        setState(() => _cooldownSeconds = 0);
      } else {
        setState(() => _cooldownSeconds--);
      }
    });
  }

  Future<void> _handleResend() async {
    if (_cooldownSeconds > 0 || _isLoading) return;

    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorMessage = 'Please provide a valid email to resend code');
      return;
    }

    HapticManager.shared.impactLight();
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final queryType = GoRouterState.of(context).uri.queryParameters['type'];
      final otpType = queryType == 'signup' ? OtpType.signup : OtpType.email;
      await ref.read(authProvider.notifier).resendConfirmationEmail(email, type: otpType);
      if (!mounted) return;
      HapticManager.shared.notificationSuccess();
      _startCooldown();
      setState(() {
        _successMessage = 'A new 6-digit verification code was sent to $email';
      });
    } catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();
      setState(() {
        _errorMessage = e is AuthException
            ? e.message
            : 'Unable to resend code right now. Please wait a moment.';
      });
    }
  }

  void _handleVerify() async {
    if (_isLoading) return;

    final email = _emailController.text.trim();
    final otp = _otpController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      HapticManager.shared.error();
      setState(() => _errorMessage = 'Please enter a valid email address');
      return;
    }

    if (otp.isEmpty || otp.length < 6) {
      HapticManager.shared.error();
      setState(() => _errorMessage = 'Please enter the full 6-digit verification code');
      return;
    }

    HapticManager.shared.impactMedium();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final queryType = GoRouterState.of(context).uri.queryParameters['type'];
      final otpType = queryType == 'signup' ? OtpType.signup : OtpType.email;
      final success = await ref.read(authProvider.notifier).verifyOTP(email, otp, type: otpType);
      if (!mounted) return;

      if (success) {
        HapticManager.shared.notificationSuccess();
        final rawRedirect = GoRouterState.of(context).uri.queryParameters['redirect'];
        if (rawRedirect != null && rawRedirect.isNotEmpty) {
          final decoded = Uri.decodeComponent(rawRedirect).trim();
          if (decoded.startsWith('/') && !decoded.startsWith('//') && !decoded.contains('://')) {
            context.go(decoded);
            return;
          }
        }
        context.go('/profile-setup');
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Invalid verification code. Please check your email or request a new code.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();
      setState(() {
        _isLoading = false;
        if (e is AuthException) {
          final lower = e.message.toLowerCase();
          if (lower.contains('expired') || lower.contains('invalid')) {
            _errorMessage = 'The verification code has expired or is invalid. Please request a new code.';
          } else {
            _errorMessage = e.message;
          }
        } else {
          _errorMessage = 'Verification failed. Please verify your internet connection and code.';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.md),
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
              const SizedBox(height: AppSpacing.xl),
              Text(
                "Verify Account",
                style: AppTypography.hero.copyWith(color: colors.text),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Enter the 6-digit activation code sent to your email to confirm your identity.",
                style: AppTypography.body.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.destructive.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
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
                ),
              ],
              if (_successMessage != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: colors.primary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: AppTypography.footnote.copyWith(color: colors.primary),
                        ),
                      ),
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
              Container(
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  style: AppTypography.metric.copyWith(
                    color: colors.text,
                    letterSpacing: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "000000",
                    hintStyle: AppTypography.metric.copyWith(
                      color: colors.textSecondary.withAlpha(80),
                      letterSpacing: 8,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  onChanged: (val) {
                    if (val.length == 6) {
                      _handleVerify();
                    }
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _cooldownSeconds > 0 ? null : _handleResend,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _cooldownSeconds > 0
                          ? "Resend Code in ${_cooldownSeconds}s"
                          : "Resend Code",
                      style: AppTypography.footnote.copyWith(
                        color: _cooldownSeconds > 0 ? colors.textSecondary : colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                title: "Verify & Continue",
                isLoading: _isLoading,
                action: _handleVerify,
              ),
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: TextButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(
                    "Back to Sign In",
                    style: TextStyle(color: colors.textSecondary, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
