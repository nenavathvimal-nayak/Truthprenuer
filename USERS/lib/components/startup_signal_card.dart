import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';
import '../models/models.dart';

class StartupSignalCard extends StatelessWidget {
  final Startup startup;
  final String signalDescription;
  final String metric;
  final bool isPositiveSignal;
  final VoidCallback onTap;

  const StartupSignalCard({
    super.key,
    required this.startup,
    required this.signalDescription,
    required this.metric,
    required this.isPositiveSignal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.cardBackground,
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
              children: [
                CircleAvatar(
                  backgroundColor: colors.surface,
                  radius: 20,
                  child: Text(
                    startup.name.substring(0, 1).toUpperCase(),
                    style: AppTypography.title3.copyWith(color: colors.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        startup.name,
                        style: AppTypography.title3.copyWith(color: colors.text),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        startup.industry,
                        style: AppTypography.caption.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositiveSignal ? colors.success.withValues(alpha: 0.1) : colors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositiveSignal ? Icons.trending_up : Icons.trending_flat,
                        size: 14,
                        color: isPositiveSignal ? colors.success : colors.warning,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        metric,
                        style: AppTypography.labelSmall.copyWith(
                          color: isPositiveSignal ? colors.success : colors.warning,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              signalDescription,
              style: AppTypography.body.copyWith(color: colors.text),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
