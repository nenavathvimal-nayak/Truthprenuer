import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';

class DashboardStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final String? trendText;
  final bool isPositiveTrend;

  const DashboardStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.trendText,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.caption.copyWith(color: colors.textSecondary),
              ),
              Icon(
                icon,
                size: 18,
                color: iconColor ?? colors.primary,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTypography.h2.copyWith(color: colors.text),
          ),
          if (trendText != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositiveTrend ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isPositiveTrend ? colors.success : colors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  trendText!,
                  style: AppTypography.labelSmall.copyWith(
                    color: isPositiveTrend ? colors.success : colors.error,
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}
