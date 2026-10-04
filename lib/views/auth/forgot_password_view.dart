import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../main.dart';
import '../../repositories/supabase_client.dart';
import '../../utils/haptic_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  final String? initialError;
  const ForgotPasswordView({super.key, this.initialError});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _isSent = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _errorMessage = widget.initialError;
  }

  @override
  void didUpdateWidget(covariant ForgotPasswordView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialError != oldWidget.initialError && widget.initialError != null) {
      setState(() {
        _errorMessage = widget.initialError;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _handleSendLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email)) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = "Please enter a valid email address.";
      });
      return;
    }

    HapticManager.shared.impactMedium();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final client = safeSupabaseClient;
      if (client != null) {
        // High Security: Secure production origin for web redirects
        final String origin = kIsWeb && Uri.base.hasAuthority && Uri.base.host.isNotEmpty
            ? Uri.base.origin
            : AppConfig.appPublicUrl;
        final redirectUrl = '$origin/change-password?recovery=true';

        await client.auth.resetPasswordForEmail(
          email,
          redirectTo: redirectUrl,
        );
      } else {
        // Mock fallback for offline preview
        await Future.delayed(const Duration(milliseconds: 300));
      }

      if (!mounted) return;
      HapticManager.shared.success();
      setState(() {
        _isLoading = false;
        _isSent = true;
      });
    } on AuthException catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();
      setState(() {
        _isLoading = false;
        _errorMessage = "Unable to send reset link. Please verify your connection.";
      });
    }
  }

  void _handleVerifyToken() async {
    final rawInput = _tokenController.text.trim();
    if (rawInput.isEmpty) {
      HapticManager.shared.error();
      setState(() {
        _errorMessage = "Please enter or paste your reset link / token.";
      });
      return;
    }

    String token = rawInput;
    // Extract token query parameter if full URL was pasted
    if (rawInput.contains('token=')) {
      try {
        final uri = Uri.parse(rawInput);
        final paramToken = uri.queryParameters['token'];
        if (paramToken != null && paramToken.isNotEmpty) {
          token = paramToken;
        }
      } catch (_) {
        final match = RegExp(r'token=([^&]+)').firstMatch(rawInput);
        if (match != null) {
          token = match.group(1)!;
        }
      }
    }

    HapticManager.shared.impactMedium();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final client = safeSupabaseClient;
      if (client != null) {
        bool verified = false;
        if (rawInput.startsWith('http://') || rawInput.startsWith('https://')) {
          try {
            final uri = Uri.parse(rawInput);
            final paramCode = uri.queryParameters['code'];
            final paramTokenHash = uri.queryParameters['token_hash'];
            if (paramCode != null && paramCode.isNotEmpty) {
              await client.auth.exchangeCodeForSession(paramCode);
              verified = true;
            } else if (paramTokenHash != null && paramTokenHash.isNotEmpty) {
              await client.auth.verifyOTP(
                tokenHash: paramTokenHash,
                type: OtpType.recovery,
              );
              verified = true;
            }
          } catch (_) {}
        }

        if (!verified) {
          if (token.startsWith('pkce_')) {
            try {
              await client.auth.exchangeCodeForSession(token);
            } catch (_) {
              await client.auth.verifyOTP(
                tokenHash: token,
                type: OtpType.recovery,
              );
            }
          } else if (token.length > 20) {
            await client.auth.verifyOTP(
              tokenHash: token,
              type: OtpType.recovery,
            );
          } else {
            final email = _emailController.text.trim();
            await client.auth.verifyOTP(
              email: email.isNotEmpty ? email : null,
              token: token,
              type: OtpType.recovery,
            );
          }
        }
      }

      if (!mounted) return;
      HapticManager.shared.success();
      context.go('/change-password?recovery=true');
    } on AuthException catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();
      setState(() {
        _isLoading = false;
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      HapticManager.shared.error();
      setState(() {
        _isLoading = false;
        _errorMessage = "Verification failed: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 580),
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
                  size: 28,
                  color: colors.text,
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              Text(
                "Reset Password",
                style: AppTypography.hero.copyWith(color: colors.text),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                "Enter your email or paste your recovery link to choose a new password.",
                style: AppTypography.body.copyWith(
                  color: colors.text.withValues(alpha: 0.7),
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              if (_errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent.withAlpha(80)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: AppTypography.footnote.copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              
              if (_isSent)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.mark_email_read_outlined,
                          size: 64,
                          color: colors.primary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "Link Sent!",
                          style: AppTypography.title3.copyWith(color: colors.text),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          "A recovery link was dispatched to:",
                          style: AppTypography.body.copyWith(color: colors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _emailController.text.trim(),
                          style: AppTypography.headline.copyWith(color: colors.primary),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          "Click the link in your email to reset your password.",
                          style: AppTypography.caption1.copyWith(color: colors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Divider(color: colors.cardBackgroundLight),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          "Or paste the reset link / token from your email:",
                          style: AppTypography.caption1.copyWith(color: colors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        CustomTextField(
                          placeholder: "Paste reset link or token here",
                          controller: _tokenController,
                          icon: Icons.key_outlined,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleVerifyToken,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: _isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text("Verify Token & Set Password"),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isSent = false;
                            });
                          },
                          child: Text(
                            "Try another email",
                            style: AppTypography.footnote.copyWith(color: colors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // Option 1: Send reset link
                Text(
                  "Option 1: Request Reset Link",
                  style: AppTypography.caption1.copyWith(color: colors.textSecondary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                CustomTextField(
                  placeholder: "Email Address",
                  controller: _emailController,
                  icon: Icons.mail_outline,
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  title: "Send Reset Link",
                  isLoading: _isLoading,
                  action: _handleSendLink,
                ),
                
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(child: Divider(color: colors.cardBackgroundLight)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                      child: Text("OR", style: AppTypography.caption2.copyWith(color: colors.textSecondary)),
                    ),
                    Expanded(child: Divider(color: colors.cardBackgroundLight)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Option 2: Paste link or token
                Text(
                  "Option 2: Already Have Link or Token",
                  style: AppTypography.caption1.copyWith(color: colors.textSecondary, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "Paste the link or token from your email to set a new password directly:",
                  style: AppTypography.caption2.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.sm),
                CustomTextField(
                  placeholder: "Paste reset link or token here",
                  controller: _tokenController,
                  icon: Icons.link_rounded,
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _handleVerifyToken,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.primary, width: 1.5),
                      foregroundColor: colors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(
                            "Verify & Choose New Password",
                            style: AppTypography.buttonLabel.copyWith(color: colors.primary),
                          ),
                  ),
                ),
              ],
              
              const SizedBox(height: AppSpacing.xxl),
              
              GestureDetector(
                onTap: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/auth');
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(100), // Capsule
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Back to Login",
                    style: AppTypography.headline.copyWith(color: colors.text),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    ),
  ),
);
  }
}
