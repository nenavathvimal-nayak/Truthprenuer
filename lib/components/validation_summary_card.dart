import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';
import '../models/models.dart';
import 'tag_view.dart';

class ValidationSummaryCard extends StatelessWidget {
  final ValidationRequest validation;
  final VoidCallback onTap;

  const ValidationSummaryCard({
    super.key,
    required this.validation,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    validation.title,
                    style: AppTypography.title3.copyWith(color: colors.text),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Active',
                    style: AppTypography.labelSmall.copyWith(color: colors.success),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              validation.problem,
              style: AppTypography.body.copyWith(color: colors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: validation.tags.map((tag) => TagView(title: tag)).toList(),
            ),
            const SizedBox(height: 16),
            Divider(color: colors.divider),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric(context, "Upvotes", "${validation.upvotes} ▲", Icons.thumb_up_alt_outlined),
                _buildMetric(context, "Evidence", "12", Icons.analytics_outlined),
                _buildMetric(context, "Responses", "48", Icons.forum_outlined),
                _buildMetric(context, "Confidence", "75%", Icons.check_circle_outline),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value, IconData icon) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.textTertiary),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTypography.label.copyWith(color: colors.text),
            ),
            Text(
              label,
              style: AppTypography.caption.copyWith(color: colors.textTertiary),
            ),
          ],
        ),
      ],
    );
  }
}
