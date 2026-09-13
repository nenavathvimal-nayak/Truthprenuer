import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';

class CardModifier extends StatelessWidget {
  final Widget child;
  final double padding;

  const CardModifier({
    super.key,
    required this.child,
    this.padding = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

extension CardModifierExtension on Widget {
  Widget cardStyle({double padding = AppSpacing.md}) {
    return CardModifier(
      padding: padding,
      child: this,
    );
  }
}
