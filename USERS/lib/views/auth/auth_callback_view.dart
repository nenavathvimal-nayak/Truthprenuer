import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../repositories/supabase_client.dart';
import '../../utils/haptic_manager.dart';

class AuthCallbackView extends StatefulWidget {
  final String? initialError;
  final String? initialCode;
  final String? initialTokenHash;
  final String? initialType;

  const AuthCallbackView({
    super.key,
    this.initialError,
    this.initialCode,
    this.initialTokenHash,
    this.initialType,
  });

  @override
  State<AuthCallbackView> createState() => _AuthCallbackViewState();
}

class _AuthCallbackViewState extends State<AuthCallbackView> {
  bool _isProcessing = true;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _handleAuthCallback();
  }

  Future<void> _handleAuthCallback() async {
    final client = safeSupabaseClient;

    // 1. Check for passed errors
    if (widget.initialError != null && widget.initialError!.isNotEmpty) {
      setState(() {
        _isProcessing = false;
        _errorMessage = widget.initialError;
      });
      return;
    }

    if (client == null) {
      setState(() {
        _isProcessing = false;
        _errorMessage = "Backend services are unavailable. Please check configuration.";
      });
      return;
    }

    try {
      // 2. If code is present in query parameters (PKCE flow), exchange for session
      final code = widget.initialCode;
      if (code != null && code.isNotEmpty) {
        await client.auth.exchangeCodeForSession(code);
      }

      // 3. If token_hash is present (direct email template magic-link or recovery link)
      final tokenHash = widget.initialTokenHash;
      if (tokenHash != null && tokenHash.isNotEmpty) {
        OtpType otpType = OtpType.email;
        if (widget.initialType == 'recovery') {
          otpType = OtpType.recovery;
        } else if (widget.initialType == 'signup') {
          otpType = OtpType.signup;
        } else if (widget.initialType == 'magiclink' || widget.initialType == 'email') {
          otpType = OtpType.magiclink;
        }
        await client.auth.verifyOTP(tokenHash: tokenHash, type: otpType);
      }

      // 3. Inspect if an authenticated session exists now
      final session = client.auth.currentSession;
      if (session != null) {
        HapticManager.shared.success();
        setState(() {
          _isProcessing = false;
          _successMessage = "Authentication confirmed successfully!";
        });

        await Future.delayed(const Duration(milliseconds: 600));
        if (!mounted) return;

        if (widget.initialType == 'recovery') {
          context.go('/change-password?recovery=true');
        } else {
          context.go('/');
        }
        return;
      }

      // 4. If no session established
      setState(() {
        _isProcessing = false;
        _errorMessage = "This authentication link may have expired or was already used. Please request a new link.";
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = "Failed to complete authentication: ${e.toString().replaceAll('Exception:', '').trim()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: colors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: colors.divider),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isProcessing) ...[
                    const SizedBox(height: 24),
                    CircularProgressIndicator(color: colors.primary),
                    const SizedBox(height: 24),
                    Text(
                      "Verifying Authentication...",
                      style: AppTypography.title2.copyWith(color: colors.text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Securing and restoring your session. Please hold on.",
                      style: AppTypography.body.copyWith(color: colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                  ] else if (_errorMessage != null) ...[
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.riskRed.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.error_outline_rounded, color: colors.riskRed, size: 36),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Verification Failed",
                      style: AppTypography.title2.copyWith(color: colors.text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: AppTypography.body.copyWith(color: colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      title: "Back to Sign In",
                      action: () {
                        HapticManager.shared.impactLight();
                        context.go('/auth');
                      },
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        HapticManager.shared.impactLight();
                        context.go('/forgot-password');
                      },
                      child: Text(
                        "Request New Password Reset Link",
                        style: AppTypography.callout.copyWith(color: colors.primary),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: colors.evidenceGreen.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle_outline_rounded, color: colors.evidenceGreen, size: 36),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Session Verified",
                      style: AppTypography.title2.copyWith(color: colors.text),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _successMessage ?? "Redirecting you to Truthprenuer...",
                      style: AppTypography.body.copyWith(color: colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      title: "Continue to App",
                      action: () {
                        HapticManager.shared.impactLight();
                        context.go('/');
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
