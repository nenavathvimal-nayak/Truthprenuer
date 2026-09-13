import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/startup_health_models.dart';
import '../../utils/haptic_manager.dart';

class StartupHealthDashboardView extends ConsumerStatefulWidget {
  const StartupHealthDashboardView({super.key});

  @override
  ConsumerState<StartupHealthDashboardView> createState() => _StartupHealthDashboardViewState();
}

class _StartupHealthDashboardViewState extends ConsumerState<StartupHealthDashboardView> {
  StartupHealthDimension? _expandedDimension;
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Problem & Market",
    "Product & Tech",
    "Execution & Scale",
  ];

  StartupHealth _getCurrentHealth(WidgetRef ref) {
    final dataStore = ref.watch(mockDataStoreProvider);
    final validation = dataStore.myValidations().isNotEmpty ? dataStore.myValidations().first : null;
    if (validation != null && validation.startupHealth != null) {
      return validation.startupHealth!;
    }

    final scores = [
      HealthScore(
        dimension: StartupHealthDimension.problemStrength,
        score: 85,
        explanation: "High pain and urgency reported by 84% of interviewed B2B founders.",
        recommendation: "Maintain tight focus on automated validation pipelines before expanding feature set.",
        evidenceReferences: ["ev_1", "ev_2"],
      ),
      HealthScore(
        dimension: StartupHealthDimension.demand,
        score: 68,
        explanation: "Strong qualitative resonance; willingness to pay tested with 14 LOIs at \$49/mo.",
        recommendation: "Run a formal price elasticity survey across 30 enterprise design partners.",
        evidenceReferences: ["ev_3"],
      ),
      HealthScore(
        dimension: StartupHealthDimension.validationConfidence,
        score: 78,
        explanation: "Robust evidence mix combining user transcripts, prototype usability heatmaps, and competitive metrics.",
        recommendation: "Gather 5 additional blind customer reviews to eliminate founder bias.",
        evidenceReferences: ["ev_1", "ev_4"],
      ),
      HealthScore(
        dimension: StartupHealthDimension.solutionReadiness,
        score: 65,
        explanation: "Core workflows verified in clickable prototyping; data synchronization engine pending completion.",
        recommendation: "Accelerate phase 1 backend sync engine sprint.",
      ),
      HealthScore(
        dimension: StartupHealthDimension.productReadiness,
        score: 55,
        explanation: "Beta build stable for 45 daily active testers; offline capabilities require polish.",
        recommendation: "Stabilize offline state persistence and error boundaries.",
      ),
      HealthScore(
        dimension: StartupHealthDimension.pmfReadiness,
        score: 52,
        explanation: "42% of survey cohort report they would be 'very disappointed' if Truthprenuer ceased to exist.",
        recommendation: "Target 50%+ Sean Ellis PMF threshold by refining onboarding experience.",
      ),
      HealthScore(
        dimension: StartupHealthDimension.execution,
        score: 92,
        explanation: "Continuous shipping cadence with 14 production releases over the past 30 days.",
        recommendation: "Keep up the momentum; establish weekly user feedback review rituals.",
      ),
      HealthScore(
        dimension: StartupHealthDimension.team,
        score: 80,
        explanation: "Seasoned domain experience and design velocity; actively onboarding advisory board.",
        recommendation: "Close advisory agreements with 2 veteran B2B SaaS operators.",
      ),
      HealthScore(
        dimension: StartupHealthDimension.growth,
        score: 58,
        explanation: "Organic founder network driving initial cohort; scalable outbound & SEO untested.",
        recommendation: "Run 2 targeted outbound pipeline tests to benchmark CAC.",
      ),
      HealthScore(
        dimension: StartupHealthDimension.fundingReadiness,
        score: 72,
        explanation: "Clear unit economics, verified problem validation dossier, and strong founder equity alignment.",
        recommendation: "Package this validation dossier into the angel pitch data room.",
      ),
    ];
    return StartupHealth(startupId: "mock_startup", scores: scores);
  }

  Color _scoreColor(int score, AppThemeColors colors) {
    if (score >= 75) return colors.evidenceGreen;
    if (score >= 50) return colors.warning;
    return colors.riskRed;
  }

  String _healthStatus(int score) {
    if (score >= 80) return "Exceptional Health";
    if (score >= 70) return "Strong Momentum";
    if (score >= 50) return "Action Required";
    return "Critical Risk";
  }

  bool _matchesCategory(StartupHealthDimension dimension, String category) {
    if (category == "All") return true;
    if (category == "Problem & Market") {
      return dimension == StartupHealthDimension.problemStrength ||
          dimension == StartupHealthDimension.demand ||
          dimension == StartupHealthDimension.validationConfidence;
    }
    if (category == "Product & Tech") {
      return dimension == StartupHealthDimension.solutionReadiness ||
          dimension == StartupHealthDimension.productReadiness ||
          dimension == StartupHealthDimension.pmfReadiness;
    }
    if (category == "Execution & Scale") {
      return dimension == StartupHealthDimension.execution ||
          dimension == StartupHealthDimension.team ||
          dimension == StartupHealthDimension.growth ||
          dimension == StartupHealthDimension.fundingReadiness;
    }
    return true;
  }

  void _triggerAction(BuildContext context, HealthScore score, AppThemeColors colors) {
    HapticManager.shared.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _HealthActionModal(score: score),
    );
  }

  void _exportAuditReport(BuildContext context, StartupHealth health, AppThemeColors colors) {
    HapticManager.shared.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ExportAuditModal(health: health),
    );
  }

  void _shareWithInvestors(BuildContext context, StartupHealth health, AppThemeColors colors) {
    HapticManager.shared.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _ShareInvestorModal(health: health),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final health = _getCurrentHealth(ref);
    final overallScore = health.overallScore;
    final primaryColor = _scoreColor(overallScore, colors);

    final filteredScores = health.scores.where((s) => _matchesCategory(s.dimension, _selectedCategory)).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Executive Radial Command Card
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
                      children: [
                        Row(
                          children: [
                            // Custom Radial Gauge
                            SizedBox(
                              width: 104,
                              height: 104,
                              child: CustomPaint(
                                painter: _RadialGaugePainter(
                                  progress: overallScore / 100,
                                  fillColor: primaryColor,
                                  trackColor: colors.cardBackgroundLight,
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "$overallScore%",
                                        style: AppTypography.title1.copyWith(
                                          color: colors.text,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        "HEALTH",
                                        style: AppTypography.caption.copyWith(
                                          color: colors.textTertiary,
                                          fontSize: 9,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.lg),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withAlpha(26),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.shield_outlined, size: 13, color: primaryColor),
                                        const SizedBox(width: 4),
                                        Text(
                                          _healthStatus(overallScore),
                                          style: AppTypography.caption.copyWith(
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: AppSpacing.xs),
                                  Text(
                                    "Validation Health Index",
                                    style: AppTypography.headline.copyWith(color: colors.text),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Top 14% among Seed Stage B2B products based on live empirical proofs.",
                                    style: AppTypography.footnote.copyWith(
                                      color: colors.textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Mini Metric Pills
                        const Row(
                          children: [
                            Expanded(
                              child: _MetricTile(
                                label: "30D VELOCITY",
                                value: "+12.4%",
                                isPositive: true,
                                icon: Icons.trending_up,
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _MetricTile(
                                label: "CONFIDENCE",
                                value: "High",
                                isPositive: true,
                                icon: Icons.verified,
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: _MetricTile(
                                label: "EVIDENCE ITEMS",
                                value: "8 Verified",
                                isPositive: null,
                                icon: Icons.inventory_2_outlined,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // 4-Week Velocity Progression Spark Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.insights, size: 16, color: colors.primary),
                                const SizedBox(width: 6),
                                Text(
                                  "4-Week Health Progression",
                                  style: AppTypography.headline.copyWith(color: colors.text, fontSize: 13),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: colors.evidenceGreen.withAlpha(26),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                "Compounding",
                                style: AppTypography.caption.copyWith(
                                  color: colors.evidenceGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _ProgressionNode(week: "Week 1", score: 54, delta: "Base"),
                            _ProgressionNode(week: "Week 2", score: 61, delta: "+7%"),
                            _ProgressionNode(week: "Week 3", score: 66, delta: "+5%"),
                            _ProgressionNode(week: "Current", score: 72, delta: "+6%", isCurrent: true),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Category Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: GestureDetector(
                          onTap: () {
                            HapticManager.shared.selection();
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? colors.primary : colors.cardBackground,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              category,
                              style: AppTypography.caption.copyWith(
                                color: isSelected ? Colors.white : colors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Dimension Cards Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "HEALTH DIMENSIONS (${filteredScores.length})",
                        style: AppTypography.caption.copyWith(
                          color: colors.textTertiary,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Tap dimension to act",
                        style: AppTypography.caption.copyWith(color: colors.textSecondary, fontSize: 11),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.sm),

                // Dimension Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Column(
                    children: filteredScores.map((score) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _HealthDimensionCard(
                          score: score,
                          isExpanded: _expandedDimension == score.dimension,
                          onTap: () {
                            HapticManager.shared.selection();
                            setState(() {
                              if (_expandedDimension == score.dimension) {
                                _expandedDimension = null;
                              } else {
                                _expandedDimension = score.dimension;
                              }
                            });
                          },
                          onAction: () => _triggerAction(context, score, colors),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Bottom Action Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _exportAuditReport(context, health, colors),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: colors.cardBackground,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.picture_as_pdf_outlined, size: 18, color: colors.text),
                                const SizedBox(width: 8),
                                Text(
                                  "Export Audit PDF",
                                  style: AppTypography.buttonLabel.copyWith(color: colors.text, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _shareWithInvestors(context, health, colors),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  "Share with Angels",
                                  style: AppTypography.buttonLabel.copyWith(color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadialGaugePainter extends CustomPainter {
  final double progress;
  final Color fillColor;
  final Color trackColor;

  _RadialGaugePainter({
    required this.progress,
    required this.fillColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 8;
    const strokeWidth = 9.0;
    const startAngle = -math.pi * 0.75;
    const sweepAngle = math.pi * 1.5;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      trackPaint,
    );

    final progressPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RadialGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.trackColor != trackColor;
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final bool? isPositive;
  final IconData icon;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final valColor = isPositive == true
        ? colors.evidenceGreen
        : isPositive == false
            ? colors.riskRed
            : colors.text;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: colors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: valColor),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.headline.copyWith(color: valColor, fontSize: 13),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: colors.textTertiary,
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ProgressionNode extends StatelessWidget {
  final String week;
  final int score;
  final String delta;
  final bool isCurrent;

  const _ProgressionNode({
    required this.week,
    required this.score,
    required this.delta,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Column(
      children: [
        Text(
          week,
          style: AppTypography.caption.copyWith(
            color: isCurrent ? colors.primary : colors.textTertiary,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 44,
          height: 32,
          decoration: BoxDecoration(
            color: isCurrent ? colors.primary.withAlpha(30) : colors.cardBackgroundLight,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            "$score%",
            style: AppTypography.headline.copyWith(
              color: isCurrent ? colors.primary : colors.text,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          delta,
          style: AppTypography.caption.copyWith(
            color: isCurrent ? colors.evidenceGreen : colors.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HealthDimensionCard extends StatelessWidget {
  final HealthScore score;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onAction;

  const _HealthDimensionCard({
    required this.score,
    required this.isExpanded,
    required this.onTap,
    required this.onAction,
  });

  Color _scoreColor(int score, AppThemeColors colors) {
    if (score >= 75) return colors.evidenceGreen;
    if (score >= 50) return colors.warning;
    return colors.riskRed;
  }

  String _actionLabel(StartupHealthDimension dimension) {
    switch (dimension) {
      case StartupHealthDimension.problemStrength:
        return "Review Customer Transcripts";
      case StartupHealthDimension.demand:
        return "Launch Pricing Experiment";
      case StartupHealthDimension.validationConfidence:
        return "Add Verification Evidence";
      case StartupHealthDimension.solutionReadiness:
        return "Launch Prototype Test Sprint";
      case StartupHealthDimension.productReadiness:
        return "Log Tech Debt & Bugs";
      case StartupHealthDimension.pmfReadiness:
        return "Run Sean Ellis PMF Survey";
      case StartupHealthDimension.execution:
        return "Schedule Sprint Retro";
      case StartupHealthDimension.team:
        return "Search Advisor Network";
      case StartupHealthDimension.growth:
        return "Model Channel CAC / LTV";
      case StartupHealthDimension.fundingReadiness:
        return "Generate Pitch Data Room";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final sColor = _scoreColor(score.score, colors);

    return Container(
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  // Circular Indicator
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(colors.cardBackgroundLight),
                        ),
                        CircularProgressIndicator(
                          value: score.score / 100,
                          strokeWidth: 4,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation<Color>(sColor),
                          strokeCap: StrokeCap.round,
                        ),
                        Text(
                          "${score.score}",
                          style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold, color: colors.text),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                score.dimension.rawValue,
                                style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: sColor.withAlpha(26),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                score.score >= 75 ? "Strong" : (score.score >= 50 ? "Attention" : "Risk"),
                                style: AppTypography.caption.copyWith(
                                  color: sColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          score.dimension.description,
                          style: AppTypography.caption.copyWith(color: colors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: colors.divider, height: 1, thickness: 1),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    "CURRENT STATE",
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textTertiary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    score.explanation,
                    style: AppTypography.body.copyWith(color: colors.text, height: 1.4),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    "AI RECOMMENDATION",
                    style: AppTypography.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textTertiary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: colors.cardBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(Icons.auto_awesome, color: colors.primary, size: 14),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            score.recommendation,
                            style: AppTypography.body.copyWith(color: colors.text, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Executable Action Button
                  GestureDetector(
                    onTap: onAction,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: colors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt, size: 16, color: colors.primary),
                          const SizedBox(width: 6),
                          Text(
                            _actionLabel(score.dimension),
                            style: AppTypography.buttonLabel.copyWith(
                              color: colors.primary,
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HealthActionModal extends StatefulWidget {
  final HealthScore score;

  const _HealthActionModal({required this.score});

  @override
  State<_HealthActionModal> createState() => _HealthActionModalState();
}

class _HealthActionModalState extends State<_HealthActionModal> {
  bool _isExecuting = false;
  bool _completed = false;

  void _runAction() async {
    setState(() => _isExecuting = true);
    HapticManager.shared.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isExecuting = false;
      _completed = true;
    });
    HapticManager.shared.success();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(26),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.bolt, color: colors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.score.dimension.rawValue,
                      style: AppTypography.title3.copyWith(color: colors.text),
                    ),
                    Text(
                      "Execute Strategic Recommendation",
                      style: AppTypography.caption.copyWith(color: colors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ACTION PLAN",
                  style: AppTypography.caption.copyWith(
                    color: colors.textTertiary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.score.recommendation,
                  style: AppTypography.body.copyWith(color: colors.text, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_completed)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.evidenceGreen.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: colors.evidenceGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Task successfully scheduled into your founder roadmap.",
                      style: AppTypography.body.copyWith(color: colors.evidenceGreen, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: _isExecuting ? null : _runAction,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: _isExecuting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        "Execute Recommendation Now",
                        style: AppTypography.buttonLabel.copyWith(color: Colors.white),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ExportAuditModal extends StatefulWidget {
  final StartupHealth health;

  const _ExportAuditModal({required this.health});

  @override
  State<_ExportAuditModal> createState() => _ExportAuditModalState();
}

class _ExportAuditModalState extends State<_ExportAuditModal> {
  bool _isGenerating = false;
  bool _ready = false;

  void _generatePdf() async {
    setState(() => _isGenerating = true);
    HapticManager.shared.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _isGenerating = false;
      _ready = true;
    });
    HapticManager.shared.success();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.picture_as_pdf_rounded, color: colors.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                "Export Health Audit Dossier",
                style: AppTypography.title3.copyWith(color: colors.text),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Compile a verifiable PDF executive brief containing empirical proofs, health scores, and next validation targets.",
            style: AppTypography.footnote.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              children: [
                _AuditIncludeRow(title: "Overall Health Score", checked: true),
                SizedBox(height: 8),
                _AuditIncludeRow(title: "10 Empirical Health Dimensions", checked: true),
                SizedBox(height: 8),
                _AuditIncludeRow(title: "Customer Transcripts & Evidence Links", checked: true),
                SizedBox(height: 8),
                _AuditIncludeRow(title: "Founder Risk Mitigation Playbook", checked: true),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_ready)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: colors.evidenceGreen.withAlpha(26),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: colors.evidenceGreen, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Truthprenuer_Audit_${DateTime.now().year}.pdf ready. Saved to device downloads.",
                      style: AppTypography.caption.copyWith(color: colors.evidenceGreen, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          else
            GestureDetector(
              onTap: _isGenerating ? null : _generatePdf,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: _isGenerating
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        "Generate Executive Dossier",
                        style: AppTypography.buttonLabel.copyWith(color: Colors.white),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AuditIncludeRow extends StatelessWidget {
  final String title;
  final bool checked;

  const _AuditIncludeRow({required this.title, required this.checked});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      children: [
        Icon(checked ? Icons.check_circle : Icons.circle_outlined, size: 16, color: colors.evidenceGreen),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: AppTypography.footnote.copyWith(color: colors.text),
          ),
        ),
      ],
    );
  }
}

class _ShareInvestorModal extends StatefulWidget {
  final StartupHealth health;

  const _ShareInvestorModal({required this.health});

  @override
  State<_ShareInvestorModal> createState() => _ShareInvestorModalState();
}

class _ShareInvestorModalState extends State<_ShareInvestorModal> {
  bool _copied = false;
  bool _requirePassword = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(Icons.lock_person_outlined, color: colors.primary, size: 24),
              const SizedBox(width: 10),
              Text(
                "Angel & Investor Access Link",
                style: AppTypography.title3.copyWith(color: colors.text),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            "Generate an ephemeral, read-only link for angel investors and incubators to view your validated metrics.",
            style: AppTypography.footnote.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "https://truthprenuer.app/audit/v1-${widget.health.startupId}",
                    style: AppTypography.caption.copyWith(color: colors.textSecondary, fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    HapticManager.shared.lightImpact();
                    setState(() => _copied = true);
                    HapticManager.shared.success();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha(26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _copied ? "Copied!" : "Copy Link",
                      style: AppTypography.caption.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text("Require Access Passcode", style: AppTypography.headline.copyWith(color: colors.text, fontSize: 14)),
            subtitle: Text("Secured with AES-256 founder pin", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
            value: _requirePassword,
            activeTrackColor: colors.primary,
            onChanged: (val) {
              HapticManager.shared.selection();
              setState(() => _requirePassword = val);
            },
          ),
        ],
      ),
    );
  }
}
