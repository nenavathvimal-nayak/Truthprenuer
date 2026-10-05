import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/avatar_view.dart';
import '../../components/buttons.dart';
import '../../components/universal_state_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/models.dart';
import '../../models/startup_health_models.dart';
import '../../repositories/app_providers.dart';
import '../../utils/haptic_manager.dart';
import 'structured_feedback_view.dart';

class ValidationDetailView extends ConsumerStatefulWidget {
  final String? validationId;
  final ValidationRequest? validation;
  final User? author;

  const ValidationDetailView({
    super.key,
    this.validationId,
    this.validation,
    this.author,
  });

  @override
  ConsumerState<ValidationDetailView> createState() => _ValidationDetailViewState();
}

class _ValidationDetailViewState extends ConsumerState<ValidationDetailView> {
  bool _isBookmarked = false;
  String _evidenceFilter = "All"; // All, Supports, Contradicts, Inconclusive
  String? _selectedDecision;
  final TextEditingController _decisionRationaleCtrl = TextEditingController();
  bool _isSavingDecision = false;
  String? _savedDecisionSuccess;

  @override
  void dispose() {
    _decisionRationaleCtrl.dispose();
    super.dispose();
  }

  DecisionType _mapDecisionType(String action) {
    switch (action) {
      case "Build MVP":
        return DecisionType.build;
      case "Iterate Prototype":
        return DecisionType.iterate;
      case "Re-test Pricing":
        return DecisionType.retest;
      case "Pivot Target":
        return DecisionType.pivot;
      case "Pause Sprint":
        return DecisionType.pause;
      default:
        return DecisionType.gatherEvidence;
    }
  }

  void _showFeedbackSheet(ValidationRequest val, User auth) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: StructuredFeedbackView(
            validation: val,
            author: auth,
          ),
        ),
      ),
    );
  }

  Future<void> _recordDecision(ValidationRequest val, String decision) async {
    setState(() => _isSavingDecision = true);
    HapticManager.shared.impactMedium();

    final currentUser = ref.read(currentUserProvider).value;
    final repo = ref.read(decisionRepositoryProvider);

    final dec = Decision(
      id: const Uuid().v4(),
      validationId: val.id,
      authorId: currentUser?.id ?? val.authorId,
      type: _mapDecisionType(decision),
      rationale: _decisionRationaleCtrl.text.trim().isNotEmpty
          ? _decisionRationaleCtrl.text.trim()
          : "Empirical decision executed based on current evidence synthesis.",
      createdAt: DateTime.now(),
    );

    await repo.recordDecision(dec);

    if (mounted) {
      setState(() {
        _isSavingDecision = false;
        _savedDecisionSuccess = decision;
      });
      HapticManager.shared.notificationSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Decision recorded: $decision"),
          backgroundColor: AppPalette.midnight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final currentUser = ref.watch(currentUserProvider).value;

    // Resolve validation either from passed object or provider lookup
    ValidationRequest? resolvedValidation = widget.validation;
    if (resolvedValidation == null && widget.validationId != null) {
      final allValidations = ref.watch(validationsProvider).value ?? [];
      for (final v in allValidations) {
        if (v.id == widget.validationId) {
          resolvedValidation = v;
          break;
        }
      }
    }

    // 1. Not Found Check
    if (resolvedValidation == null) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: UniversalStateView.noResults(
          title: "Validation Not Found",
          message: "This validation sprint is no longer active or the URL is invalid.",
          onAction: () => Navigator.pop(context),
        ),
      );
    }

    final val = resolvedValidation;
    final isAuthor = currentUser?.id == val.authorId;

    // 2. Object-Level Authorization Guard
    if (val.visibility == ValidationVisibility.private && !isAuthor) {
      return Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          backgroundColor: colors.background,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.text, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: UniversalStateView.unauthorized(
          title: "Private Founder Intelligence",
          message: "This validation sprint is private. Raw hypothesis data, customer evidence, and AI analysis are restricted to authorized principals.",
          onAction: () => Navigator.pop(context),
        ),
      );
    }

    final author = widget.author ?? User(
      id: val.authorId,
      name: val.authorName ?? "Founder",
      username: "founder",
      bio: "",
      role: val.authorRole ?? "Founder",
    );

    // Watch responses and evidence
    final responsesAsync = ref.watch(validationResponsesProvider(val.id));
    final allEvidence = ref.watch(evidenceListProvider).where((e) => e.validationId == val.id).toList();

    final filteredEvidence = allEvidence.where((e) {
      if (_evidenceFilter == "All") return true;
      if (_evidenceFilter == "Supports") return e.classification == EvidenceClassification.supports;
      if (_evidenceFilter == "Contradicts") return e.classification == EvidenceClassification.contradicts;
      if (_evidenceFilter == "Inconclusive") return e.classification == EvidenceClassification.inconclusive;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colors.text, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: Text(
          "VALIDATION SPRINT",
          style: AppTypography.caption.copyWith(
            color: AppPalette.orange,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            tooltip: _isBookmarked ? "Remove bookmark" : "Bookmark validation",
            icon: Semantics(
              label: _isBookmarked ? "Remove bookmark" : "Bookmark validation",
              button: true,
              child: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: AppPalette.orange,
              ),
            ),
            onPressed: () {
              HapticManager.shared.selection();
              setState(() => _isBookmarked = !_isBookmarked);
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
                // Visibility & Stage Banner
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        val.visibility.name.toUpperCase(),
                        style: AppTypography.caption2.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.cardBackgroundLight,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        val.validationStage.name.toUpperCase(),
                        style: AppTypography.caption2.copyWith(
                          color: colors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      val.createdAt.timeAgoDisplay,
                      style: AppTypography.caption.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Title
                Text(
                  val.title,
                  style: AppTypography.title1.copyWith(color: colors.text, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Author Row
                InkWell(
                  onTap: () {
                    context.push('/user-profile', extra: {'user': author});
                  },
                  child: Row(
                    children: [
                      AvatarView(name: author.name, imageURL: author.avatarURL, size: 32),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author.name,
                            style: AppTypography.subheadline.copyWith(color: colors.text, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            author.role,
                            style: AppTypography.caption.copyWith(color: colors.textTertiary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Section 1: WHAT IS BEING TESTED
                const _SectionTitle(title: "WHAT IS BEING TESTED", icon: Icons.science_outlined),
                const SizedBox(height: AppSpacing.md),
                _ContentSection(title: "Problem Statement", text: val.problem),
                const SizedBox(height: AppSpacing.sm),
                _ContentSection(title: "Target Audience", text: val.targetAudience),
                const SizedBox(height: AppSpacing.sm),
                _ContentSection(title: "Proposed Solution", text: val.solution),
                if (val.existingAlternatives.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _ContentSection(title: "Current Alternatives", text: val.existingAlternatives),
                ],
                if (val.differentiator.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  _ContentSection(title: "Core Differentiator", text: val.differentiator),
                ],

                const SizedBox(height: AppSpacing.xl),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: AppSpacing.xl),

                // Section 2: STRUCTURED FEEDBACK
                responsesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Text("Failed to load responses: $err", style: TextStyle(color: colors.error)),
                  data: (responses) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: _SectionTitle(title: "STRUCTURED SIGNALS & RESPONSES", icon: Icons.forum_outlined),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppPalette.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                "${responses.length} Submissions",
                                style: AppTypography.caption.copyWith(
                                  color: AppPalette.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),

                        if (!isAuthor)
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.md),
                            child: PrimaryButton(
                              title: "Contribute Validation Feedback",
                              action: () => _showFeedbackSheet(val, author),
                            ),
                          ),

                        if (responses.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: colors.cardBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: colors.border.withValues(alpha: 0.5)),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.rate_review_outlined, color: colors.textTertiary, size: 36),
                                const SizedBox(height: 8),
                                Text(
                                  "No feedback submissions recorded yet.",
                                  style: AppTypography.body.copyWith(color: colors.textSecondary),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: responses.map((resp) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                                padding: const EdgeInsets.all(AppSpacing.md),
                                decoration: BoxDecoration(
                                  color: colors.cardBackground,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: colors.border.withValues(alpha: 0.6)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        AvatarView(name: resp.respondentName ?? "Validator", size: 28),
                                        const SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              resp.respondentName ?? "Validator",
                                              style: AppTypography.subheadline.copyWith(
                                                color: colors.text,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              resp.respondentRole ?? "Contributor",
                                              style: AppTypography.caption2.copyWith(color: colors.textTertiary),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        Text(
                                          resp.createdAt.timeAgoDisplay,
                                          style: AppTypography.caption2.copyWith(color: colors.textTertiary),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: AppSpacing.sm),
                                    ...resp.answers.map((ans) => Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("• ", style: TextStyle(color: colors.primary)),
                                          Expanded(
                                            child: Text(
                                              ans.answerText ?? "",
                                              style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: AppSpacing.xl),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: AppSpacing.xl),

                // Section 3: EVIDENCE LOCKER
                Row(
                  children: [
                    const Expanded(
                      child: _SectionTitle(title: "EVIDENCE LOCKER", icon: Icons.folder_open_outlined),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${allEvidence.length} items",
                      style: AppTypography.caption.copyWith(color: colors.textTertiary),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                // Classification Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ["All", "Supports", "Contradicts", "Inconclusive"].map((filter) {
                      final isSelected = _evidenceFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (_) {
                            HapticManager.shared.selection();
                            setState(() => _evidenceFilter = filter);
                          },
                          selectedColor: AppPalette.orange.withValues(alpha: 0.15),
                          labelStyle: TextStyle(
                            color: isSelected ? AppPalette.orange : colors.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          backgroundColor: colors.cardBackground,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                if (filteredEvidence.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colors.cardBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "No $_evidenceFilter evidence items recorded.",
                        style: AppTypography.footnote.copyWith(color: colors.textTertiary),
                      ),
                    ),
                  )
                else
                  Column(
                    children: filteredEvidence.map((ev) {
                      final badgeColor = ev.classification == EvidenceClassification.supports
                          ? colors.evidenceGreen
                          : ev.classification == EvidenceClassification.contradicts
                              ? colors.warning
                              : colors.textTertiary;

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: colors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: colors.border.withValues(alpha: 0.6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    ev.classification.name.toUpperCase(),
                                    style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "Confidence: ${ev.confidenceScore}%",
                                  style: AppTypography.caption2.copyWith(color: colors.textSecondary),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              ev.title,
                              style: AppTypography.headline.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ev.summary,
                              style: AppTypography.footnote.copyWith(color: colors.textSecondary),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: AppSpacing.xl),
                Divider(color: colors.divider, thickness: 1),
                const SizedBox(height: AppSpacing.xl),

                // Section 4: TRUTHPRENUER EVIDENCE SYNTHESIS (AI)
                const _SectionTitle(title: "TRUTHPRENUER EVIDENCE SYNTHESIS", icon: Icons.auto_awesome),
                const SizedBox(height: AppSpacing.md),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: colors.cardBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border.withValues(alpha: 0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.insights_outlined, color: AppPalette.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Evidence-Derived Signal",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTypography.headline.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.evidenceGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              "82% HEALTH",
                              style: TextStyle(
                                color: colors.evidenceGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),

                      _SynthesisRow(
                        label: "1. Observed Evidence",
                        content: "Strong operational urgency around inventory reconciliation; 88% confirm manual audits exceed 90 mins daily.",
                        colors: colors,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SynthesisRow(
                        label: "2. Detected Patterns",
                        content: "Willingness to adopt WhatsApp-first interfaces is 3x higher than desktop web dashboards.",
                        colors: colors,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SynthesisRow(
                        label: "3. Contradictions Identified",
                        content: "Price resistance emerges if OCR accuracy falls below 90% on handwritten non-standard vendor slips.",
                        colors: colors,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SynthesisRow(
                        label: "4. Major Uncertainty",
                        content: "Integration with local legacy POS systems remains untested across tier-2 restaurant samples.",
                        colors: colors,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _SynthesisRow(
                        label: "5. Next Recommended Test",
                        content: "Run 10 real-world kitchen invoice OCR tests across diverse handwriting samples.",
                        colors: colors,
                      ),
                    ],
                  ),
                ),

                // Section 5: DECISION CENTER (Founder Only)
                if (isAuthor) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Divider(color: colors.divider, thickness: 1),
                  const SizedBox(height: AppSpacing.xl),

                  const _SectionTitle(title: "FOUNDER DECISION CENTER", icon: Icons.gavel_outlined),
                  const SizedBox(height: 6),
                  Text(
                    "AI assists with synthesis; the founder records the authoritative decision.",
                    style: AppTypography.caption.copyWith(color: colors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      "Gather More Evidence",
                      "Iterate Prototype",
                      "Build MVP",
                      "Re-test Pricing",
                      "Pivot Target",
                      "Pause Sprint",
                    ].map((dec) {
                      final isSelected = (_selectedDecision ?? _savedDecisionSuccess) == dec;
                      return ChoiceChip(
                        label: Text(dec),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) {
                            HapticManager.shared.selection();
                            setState(() => _selectedDecision = dec);
                          }
                        },
                        selectedColor: AppPalette.orange,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : colors.text,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                        backgroundColor: colors.cardBackground,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }).toList(),
                  ),

                  if (_selectedDecision != null && _savedDecisionSuccess != _selectedDecision) ...[
                    const SizedBox(height: AppSpacing.md),
                    TextField(
                      controller: _decisionRationaleCtrl,
                      maxLines: 2,
                      style: TextStyle(color: colors.text),
                      decoration: InputDecoration(
                        hintText: "Optional rationale or strategic context for this decision...",
                        hintStyle: TextStyle(color: colors.textTertiary),
                        filled: true,
                        fillColor: colors.cardBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: colors.border),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      title: _isSavingDecision ? "Recording..." : "Save Strategic Decision",
                      action: _isSavingDecision
                          ? () {}
                          : () => _recordDecision(val, _selectedDecision!),
                    ),
                  ],
                ],

                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppPalette.orange),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
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
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.caption.copyWith(color: colors.textTertiary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(text, style: AppTypography.body.copyWith(color: colors.text, height: 1.4)),
        ],
      ),
    );
  }
}

class _SynthesisRow extends StatelessWidget {
  final String label;
  final String content;
  final AppThemeColors colors;

  const _SynthesisRow({
    required this.label,
    required this.content,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppPalette.orange,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          content,
          style: AppTypography.footnote.copyWith(
            color: colors.text,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
