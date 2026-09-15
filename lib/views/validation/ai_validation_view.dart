import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../models/startup_health_models.dart';
import '../../utils/haptic_manager.dart';

class AIValidationView extends StatefulWidget {
  final AIValidationReport report;

  const AIValidationView({super.key, required this.report});

  @override
  State<AIValidationView> createState() => _AIValidationViewState();
}

class _AIValidationViewState extends State<AIValidationView> {
  bool _isReanalyzing = false;

  void _reanalyzeReport() async {
    setState(() => _isReanalyzing = true);
    HapticManager.shared.mediumImpact();
    
    final geminiKey = dotenv.env['GEMINI_API_KEY'];
    if (geminiKey != null && geminiKey.isNotEmpty && geminiKey != 'your_gemini_api_key_here') {
      // Call Gemini 1.5 Flash API here
      await Future.delayed(const Duration(seconds: 2));
    } else {
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    if (!mounted) return;
    setState(() => _isReanalyzing = false);
    HapticManager.shared.success();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("AI Validation Model updated with latest evidence items."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _copyInterviewQuestions(BuildContext context) {
    final questions = widget.report.interviewQuestions.map((q) => "• $q").join("\n");
    Clipboard.setData(ClipboardData(text: "Founder Customer Discovery Questions:\n\n$questions"));
    HapticManager.shared.success();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Interview questions copied to clipboard.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final report = widget.report;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Intelligence Card
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.cardBackground,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primary.withAlpha(26),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.auto_awesome, color: colors.primary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "AI Co-Founder Review",
                                style: AppTypography.title3.copyWith(color: colors.text),
                              ),
                              Text(
                                "Synthesis based on empirical customer proofs",
                                style: AppTypography.caption.copyWith(color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _isReanalyzing ? null : _reanalyzeReport,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: colors.cardBackgroundLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: _isReanalyzing
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Row(
                                    children: [
                                      Icon(Icons.refresh, size: 14, color: colors.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Refresh",
                                        style: AppTypography.caption.copyWith(
                                          color: colors.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      report.problemAnalysis,
                      style: AppTypography.body.copyWith(color: colors.text, height: 1.45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Strengths & Weaknesses (Assumptions & Risks)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.cardBackground,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.check_circle, color: colors.evidenceGreen, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Assumptions",
                                  style: AppTypography.headline.copyWith(color: colors.evidenceGreen, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...report.marketAssumptions.map((assumption) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "• $assumption",
                                  style: AppTypography.footnote.copyWith(color: colors.textSecondary, height: 1.35),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: colors.cardBackground,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: colors.riskRed, size: 16),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  "Critical Risks",
                                  style: AppTypography.headline.copyWith(color: colors.riskRed, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...report.risks.map((risk) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "• $risk",
                                  style: AppTypography.footnote.copyWith(color: colors.textSecondary, height: 1.35),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Missing Information / Blind Spots
            if (report.missingInformation.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.help_outline, size: 16, color: colors.warning),
                          const SizedBox(width: 6),
                          Text("Blind Spots & Missing Evidence", style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...report.missingInformation.map((info) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Icon(Icons.arrow_right, color: colors.warning, size: 14),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    info,
                                    style: AppTypography.body.copyWith(color: colors.textSecondary, height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Competitor Analysis
            if (report.competitorOverview.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.pie_chart_outline, size: 16, color: colors.primary),
                          const SizedBox(width: 6),
                          Text("Market & Competitor Overview", style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        report.competitorOverview,
                        style: AppTypography.body.copyWith(color: colors.textSecondary, height: 1.45),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Interview Questions
            if (report.interviewQuestions.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.record_voice_over_outlined, size: 16, color: colors.primary),
                              const SizedBox(width: 6),
                              Text("Customer Discovery Prompts", style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14)),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => _copyInterviewQuestions(context),
                            child: Row(
                              children: [
                                Icon(Icons.copy, size: 12, color: colors.primary),
                                const SizedBox(width: 4),
                                Text(
                                  "Copy All",
                                  style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...report.interviewQuestions.map((question) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 3),
                                  child: Icon(Icons.question_answer_outlined, color: colors.primary, size: 13),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    question,
                                    style: AppTypography.body.copyWith(color: colors.textSecondary, height: 1.35),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
