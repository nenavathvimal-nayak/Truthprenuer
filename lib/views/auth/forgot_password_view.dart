import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/buttons.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _isSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendLink() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
      _isSent = true;
    });
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
                  color: colors.text.withOpacity(0.7),
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              if (_isSent)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle, // checkmark.circle.fill
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
                          "Check your email for the reset link.",
                          style: AppTypography.body.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                CustomTextField(
                  placeholder: "Email Address",
                  controller: _emailController,
                  icon: Icons.mail_outline, // envelope
                ),
                
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
