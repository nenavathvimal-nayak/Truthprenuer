import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';

import 'structured_feedback_view.dart';

class ValidationDetailView extends ConsumerStatefulWidget {
  final ValidationRequest validation;
  final User author;

  const ValidationDetailView({super.key, required this.validation, required this.author});

  @override
  ConsumerState<ValidationDetailView> createState() => _ValidationDetailViewState();
}

class _ValidationDetailViewState extends ConsumerState<ValidationDetailView> {
  void _showFeedbackSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: StructuredFeedbackView(
            validation: widget.validation,
            author: widget.author,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final dataStore = ref.watch(mockDataStoreProvider);
    final feedbacks = dataStore.feedbackFor(widget.validation.id);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.text, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.validation.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: colors.primary,
            ),
            onPressed: () {
              ref.read(mockDataStoreProvider).toggleBookmark(widget.validation.id);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  widget.validation.title,
                  style: AppTypography.title1.copyWith(color: colors.text),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    AvatarView(name: widget.author.name, imageURL: widget.author.avatarURL, size: 32),
                    const SizedBox(width: 8),
                    Text(
                      widget.author.name,
                      style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
                    ),
                    const Spacer(),
                    Text(
                      widget.validation.createdAt.timeAgoDisplay,
                      style: AppTypography.caption.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),

                // Content Cards
                _ContentSection(title: "Problem", text: widget.validation.problem),
                const SizedBox(height: AppSpacing.md),
                _ContentSection(title: "Target Audience", text: widget.validation.targetAudience),
                const SizedBox(height: AppSpacing.md),
                _ContentSection(title: "Solution", text: widget.validation.solution),
                const SizedBox(height: AppSpacing.md),
                _ContentSection(title: "Existing Alternatives", text: widget.validation.existingAlternatives),
                const SizedBox(height: AppSpacing.md),
                _ContentSection(title: "Differentiator", text: widget.validation.differentiator),
                const SizedBox(height: AppSpacing.md),
                _ContentSection(title: "Business Model", text: widget.validation.businessModel),

                const SizedBox(height: AppSpacing.lg),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: AppSpacing.lg),

                // Decision Center
                _DecisionCenterSection(
                  validation: widget.validation,
                  feedbacks: feedbacks,
                ),

                const SizedBox(height: AppSpacing.lg),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: AppSpacing.lg),

                // Feedback Section
                Row(
                  children: [
                    Text("Structured Feedback", style: AppTypography.title2.copyWith(color: colors.text)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "${feedbacks.length}",
                        style: AppTypography.caption.copyWith(color: colors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                if (widget.validation.authorId != dataStore.currentUser?.id)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: PrimaryButton(
                      title: "Give Feedback",
                      action: _showFeedbackSheet,
                    ),
                  ),

                if (feedbacks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    child: Text("No feedback yet.", style: AppTypography.body.copyWith(color: colors.textTertiary)),
                  )
                else
                  Column(
                    children: feedbacks.map((feedback) {
                      final validator = dataStore.users.firstWhere((u) => u.id == feedback.validatorId, orElse: () => User(id: "", name: "Unknown", role: "", username: "unknown", bio: ""));
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _FeedbackCard(feedback: feedback, validator: validator),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final String text;

  const _ContentSection({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headline.copyWith(color: colors.textSecondary)),
          const SizedBox(height: AppSpacing.xs),
          Text(text, style: AppTypography.body.copyWith(color: colors.text, height: 1.4)),
        ],
      ),
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  final StructuredFeedback feedback;
  final User? validator;

  const _FeedbackCard({required this.feedback, this.validator});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarView(name: validator?.name ?? "Unknown", imageURL: validator?.avatarURL, size: 28),
              const SizedBox(width: 8),
              Text(validator?.name ?? "Unknown", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              const Spacer(),
              Text(feedback.createdAt.timeAgoDisplay, style: AppTypography.caption2.copyWith(color: colors.textTertiary)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          
          Row(
            children: List.generate(5, (i) {
              return Icon(
                i < feedback.overallRating ? Icons.star : Icons.star_border,
                size: 14,
                color: i < feedback.overallRating ? colors.warning : colors.divider,
              );
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: colors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Frequency: ${feedback.problemFrequency.value}", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                const SizedBox(height: 4),
                Text("Current Solution: ${feedback.currentSolution}", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  "Willing to Pay: ${feedback.willingToPay ? 'Yes (${feedback.expectedPrice})' : 'No'}",
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          ),
          
          if (feedback.textFeedback.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(feedback.textFeedback, style: AppTypography.body.copyWith(color: colors.text)),
          ],
          
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              if (feedback.evidence.isNotEmpty) ...[
                Icon(Icons.attach_file, size: 14, color: colors.primary),
                const SizedBox(width: 4),
                Text("${feedback.evidence.length} Evidence", style: AppTypography.caption.copyWith(color: colors.primary)),
              ],
              const Spacer(),
              Text(
                "Confidence: ${(feedback.confidenceScore * 100).toInt()}%",
                style: AppTypography.caption.copyWith(
                  color: feedback.confidenceScore >= 0.8 ? colors.success : colors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DecisionCenterSection extends StatelessWidget {
  final ValidationRequest validation;
  final List<StructuredFeedback> feedbacks;

  const _DecisionCenterSection({required this.validation, required this.feedbacks});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.memory, color: colors.primary),
            const SizedBox(width: 8),
            Text("TAEED Evidence Engine™", style: AppTypography.title2.copyWith(color: colors.text)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        
        if (feedbacks.isEmpty && validation.aiReport == null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            decoration: BoxDecoration(
              color: colors.cardBackgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Column(
              children: [
                Icon(Icons.search, size: 40, color: colors.textTertiary),
                const SizedBox(height: AppSpacing.sm),
                Text("Waiting for validation data...", style: AppTypography.body.copyWith(color: colors.textSecondary)),
              ],
            ),
          )
        else ...[
          Row(
            children: [
              Expanded(
                child: _DecisionCard(
                  icon: Icons.favorite,
                  title: "Health Score",
                  value: "${validation.startupHealth?.overallScore ?? validation.healthScore}%",
                  subtitle: (validation.startupHealth?.overallScore ?? validation.healthScore) > 50 ? "Good" : "Needs Work",
                  color: (validation.startupHealth?.overallScore ?? validation.healthScore) > 50 ? colors.evidenceGreen : colors.warning,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _DecisionCard(
                  icon: Icons.groups,
                  title: "Validators",
                  value: "${validation.feedbackCount}",
                  subtitle: validation.needsFeedback ? "Needs More" : "Sufficient",
                  color: validation.needsFeedback ? colors.warning : colors.evidenceGreen,
                ),
              ),
            ],
          ),
          
          if (validation.aiReport != null) ...[
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: () {
                context.push(
                  '/ai-validation',
                  extra: {
                    'report': validation.aiReport!,
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.primary.withOpacity(0.3), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.auto_awesome, color: colors.primary),
                        const SizedBox(width: 8),
                        Text("AI Critique Available", style: AppTypography.headline.copyWith(color: colors.text)),
                        const Spacer(),
                        Icon(Icons.chevron_right, color: colors.textSecondary),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      validation.aiReport!.problemAnalysis,
                      style: AppTypography.caption.copyWith(color: colors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBackgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("VALIDATION STATUS", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: colors.success,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("GO", style: AppTypography.h3.copyWith(fontWeight: FontWeight.w900, color: colors.text)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Aggregated Confidence", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                          const SizedBox(height: 4),
                          Text("81%", style: AppTypography.title2.copyWith(color: colors.success)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                
                // Confidence Bar
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 81,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.success,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Expanded(flex: 19, child: SizedBox()),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.md),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: AppSpacing.md),
                
                // AI Insights
                _InsightRow(icon: Icons.check_circle, text: "The problem is painfully real according to target users.", color: colors.success),
                const SizedBox(height: AppSpacing.sm),
                _InsightRow(icon: Icons.warning, text: "Risk: Low adoption if pricing is too complex.", color: colors.warning),
                
                const SizedBox(height: AppSpacing.md),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: AppSpacing.md),
                
                // Actionable Next Step
                Text("NEXT RECOMMENDED ACTION", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Icon(Icons.arrow_circle_right, color: colors.primary, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Interview 20 more users to refine pricing model.",
                          style: AppTypography.bodyMedium.copyWith(color: colors.text),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _DecisionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const _DecisionCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.cardBackgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(title, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.title2.copyWith(color: colors.text)),
          Text(subtitle, style: AppTypography.label.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InsightRow({required this.icon, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(text, style: AppTypography.subheadline.copyWith(color: colors.text)),
        ),
      ],
    );
  }
}
