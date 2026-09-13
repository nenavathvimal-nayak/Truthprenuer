import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import 'buttons.dart';

class TagView extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? action;

  const TagView({
    super.key,
    required this.title,
    this.isSelected = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    if (action != null) {
      return ScaleButtonStyle(
        onTap: action!,
        child: _TagContent(title: title, isSelected: isSelected),
      );
    } else {
      return _TagContent(title: title, isSelected: isSelected);
    }
  }
}

class _TagContent extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _TagContent({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: isSelected ? colors.primary : colors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100), // Capsule
      ),
      child: Text(
        title,
        style: AppTypography.caption.copyWith(
          color: isSelected ? Colors.white : colors.primary,
        ),
      ),
    );
  }
}
