import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../models/startup_health_models.dart';
import '../utils/haptic_manager.dart';
import 'buttons.dart';

class AIEvidenceInsightSheet extends StatefulWidget {
  final AIValidationReport report;
  final VoidCallback? onReanalyze;

  const AIEvidenceInsightSheet({
    super.key,
    required this.report,
    this.onReanalyze,
  });

  static Future<void> show(
    BuildContext context, {
    required AIValidationReport report,
    VoidCallback? onReanalyze,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AIEvidenceInsightSheet(
        report: report,
        onReanalyze: onReanalyze,
      ),
    );
  }

  @override
  State<AIEvidenceInsightSheet> createState() => _AIEvidenceInsightSheetState();
}

class _AIEvidenceInsightSheetState extends State<AIEvidenceInsightSheet> {
  final Set<int> _completedActionItems = {};

  void _toggleAction(int index) {
    HapticManager.shared.selection();
    setState(() {
      if (_completedActionItems.contains(index)) {
        _completedActionItems.remove(index);
      } else {
        _completedActionItems.add(index);
      }
    });
  }

  void _copyQuestions() {
    HapticManager.shared.success();
    final questions = widget.report.interviewQuestions
        .asMap()
        .entries
        .map((e) => "${e.key + 1}. ${e.value}")
        .join("\n\n");

    Clipboard.setData(
      ClipboardData(
        text: "Truthprenuer AI Co-Founder Customer Discovery Questions:\n\n$questions",
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text("Questions copied to clipboard"),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final report = widget.report;
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.88;

    return Semantics(
      label: "AI Validation Evidence & Insights Modal Sheet",
      child: Container(
        constraints: BoxConstraints(maxHeight: maxHeight),
        decoration: BoxDecoration(
          color: colors.cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Accessible Drag Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              // Sheet Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primaryMuted,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.auto_awesome, color: colors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "AI Co-Founder Evidence",
                            style: AppTypography.title3.copyWith(color: colors.text),
                          ),
                          Text(
                            "Confidence & Discovery Roadmap",
                            style: AppTypography.caption.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: colors.textSecondary,
                      tooltip: "Close sheet",
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Content Body
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Confidence Score Summary Card
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          border: Border.all(color: colors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: colors.primary.withValues(alpha: 0.12),
                                border: Border.all(color: colors.primary, width: 2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${(report.overallScore * 100).round()}%",
                                style: AppTypography.title2.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hypothesis Confidence",
                                    style: AppTypography.title3.copyWith(
                                      color: colors.text,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    report.summary,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.footnote.copyWith(
                                      color: colors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Metric Strengths & Risks
                      Text(
                        "Market Signals",
                        style: AppTypography.title3.copyWith(color: colors.text),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SignalTile(
                        icon: Icons.check_circle_rounded,
                        color: colors.evidenceGreen,
                        title: "Strengths Identified",
                        items: report.strengths,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SignalTile(
                        icon: Icons.warning_amber_rounded,
                        color: colors.warning,
                        title: "Critical Risks",
                        items: report.risks,
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Interactive Discovery Checklist
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Next Discovery Actions",
                            style: AppTypography.title3.copyWith(color: colors.text),
                          ),
                          Text(
                            "${_completedActionItems.length}/${report.recommendedActions.length} Completed",
                            style: AppTypography.caption.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...report.recommendedActions.asMap().entries.map((entry) {
                        final index = entry.key;
                        final action = entry.value;
                        final isDone = _completedActionItems.contains(index);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: InkWell(
                            onTap: () => _toggleAction(index),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.all(AppSpacing.sm + 2),
                              decoration: BoxDecoration(
                                color: isDone
                                    ? colors.success.withValues(alpha: 0.08)
                                    : colors.surface,
                                borderRadius: BorderRadius.circular(AppRadius.md),
                                border: Border.all(
                                  color: isDone ? colors.success : colors.border,
                                  width: isDone ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Icon(
                                      isDone ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                                      size: 20,
                                      color: isDone ? colors.success : colors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      action,
                                      style: AppTypography.body.copyWith(
                                        fontSize: 14,
                                        color: isDone ? colors.textSecondary : colors.text,
                                        decoration: isDone ? TextDecoration.lineThrough : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: AppSpacing.lg),

                      // Customer Discovery Questions Callout
                      Text(
                        "Suggested Interview Questions",
                        style: AppTypography.title3.copyWith(color: colors.text),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        "Ground truth questions designed to probe customer pain without leading bias.",
                        style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: colors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...report.interviewQuestions.map(
                              (q) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "• ",
                                      style: AppTypography.body.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        q,
                                        style: AppTypography.body.copyWith(
                                          fontSize: 14,
                                          color: colors.text,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            SecondaryButton(
                              title: "Copy Interview Questions",
                              icon: Icons.copy_rounded,
                              action: _copyQuestions,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Action button
                      PrimaryButton(
                        title: "Done with Review",
                        icon: Icons.check_rounded,
                        action: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignalTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final List<String> items;

  const _SignalTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTypography.callout.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "– ",
                    style: AppTypography.footnote.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: AppTypography.footnote.copyWith(color: colors.text),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
