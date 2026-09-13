import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';

class OTPVerificationView extends StatefulWidget {
  const OTPVerificationView({super.key});

  @override
  State<OTPVerificationView> createState() => _OTPVerificationViewState();
}

class _OTPVerificationViewState extends State<OTPVerificationView> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    setState(() {
      _isLoading = true;
    });

    HapticManager.shared.notificationSuccess();
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted) return;
    
    // In SwiftUI: navState = .profileSetup
    context.push('/profile-setup');
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
                    context.go('/auth'); // fallback
                  }
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 28, // .title2
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
                "Enter the 6-digit code we sent to your email.",
                style: AppTypography.body.copyWith(
                  color: colors.text.withOpacity(0.7),
                ),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              Container(
                decoration: BoxDecoration(
                  color: colors.cardBackgroundLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: AppTypography.metric.copyWith(color: colors.text),
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    hintText: "000000",
                    hintStyle: AppTypography.metric.copyWith(color: colors.text.withOpacity(0.3)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(AppSpacing.md),
                  ),
                ),
              ),
              
              const SizedBox(height: AppSpacing.sm),
              
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // Logic to resend code
                  },
                  child: Text(
                    "Resend Code",
                    style: AppTypography.footnote.copyWith(
                      color: colors.primary,
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              PrimaryButton(
                title: "Verify & Continue",
                isLoading: _isLoading,
                action: _handleVerify,
              ),
              
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}
