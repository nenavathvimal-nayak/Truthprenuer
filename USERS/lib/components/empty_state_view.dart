import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import 'buttons.dart';

class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionTitle;
  final VoidCallback? action;

  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionTitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      width: double.infinity,
      color: colors.background,
      child: Column(
        children: [
          const Spacer(),
          
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colors.cardBackgroundLight,
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                icon,
                size: 48,
                color: colors.primary,
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          Column(
            children: [
              Text(
                title,
                style: AppTypography.editorialTitle.copyWith(color: colors.text),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  message,
                  style: AppTypography.body.copyWith(color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          
          if (actionTitle != null && action != null) ...[
            const SizedBox(height: AppSpacing.md),
            ScaleButtonStyle(
              onTap: action!,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(100), // Capsule
                ),
                child: Text(
                  actionTitle!,
                  style: AppTypography.buttonLabel.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
          
          const Spacer(flex: 2), // SwiftUI had Spacer() followed by Spacer()
        ],
      ),
    );
  }
}
