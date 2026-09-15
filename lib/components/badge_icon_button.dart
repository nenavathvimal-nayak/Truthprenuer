import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';

class BadgeIconButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final VoidCallback onTap;

  const BadgeIconButton({
    super.key,
    required this.icon,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: Icon(icon, size: 22, color: colors.text),
          ),
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: colors.primary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "$count",
                  style: AppTypography.label.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
