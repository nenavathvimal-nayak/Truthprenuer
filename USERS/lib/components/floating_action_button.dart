import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import 'buttons.dart';

class AppFloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback action;

  const AppFloatingActionButton({
    super.key,
    required this.icon,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return ScaleButtonStyle(
      onTap: action,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: colors.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 24,
          color: Colors.white,
          // weight bold equivalent typically via a different icon or IconTheme not fully supported on standard Icons easily, but we can stick to standard icon.
        ),
      ),
    );
  }
}
