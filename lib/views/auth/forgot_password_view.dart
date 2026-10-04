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
  bool _isLoading = false;
  bool _isSent = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _errorMessage = widget.initialError;
  }

  @override
  void dispose() {
    _emailController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
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
                "Enter your email to receive a reset link.",
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
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
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
                CustomTextField(
                  placeholder: "Email Address",
                  controller: _emailController,
                  icon: Icons.mail_outline, // envelope
                ),
              ],
                
              const Spacer(),
              
              if (!_isSent)
                PrimaryButton(
                  title: "Send Link",
                  isLoading: _isLoading,
                  action: _handleSendLink,
                )
              else
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
                
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
