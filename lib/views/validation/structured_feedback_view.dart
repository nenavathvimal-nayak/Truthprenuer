import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';

class StructuredFeedbackView extends ConsumerStatefulWidget {
  final ValidationRequest validation;
  final User author;

  const StructuredFeedbackView({super.key, required this.validation, required this.author});

  @override
  ConsumerState<StructuredFeedbackView> createState() => _StructuredFeedbackViewState();
}

class _StructuredFeedbackViewState extends ConsumerState<StructuredFeedbackView> {
  int _step = 1;
  final int _totalSteps = 7;
  bool _isSubmitting = false;

  // Feedback State
  ProblemFrequency _problemFrequency = ProblemFrequency.rarely;
  final TextEditingController _currentSolutionCtrl = TextEditingController();
  bool _willingToPay = false;
  final TextEditingController _expectedPriceCtrl = TextEditingController();
  final TextEditingController _missingFeatureCtrl = TextEditingController();
  int _overallRating = 0;
  final TextEditingController _textFeedbackCtrl = TextEditingController();
  final TextEditingController _evidenceLinksCtrl = TextEditingController();
  final List<EvidenceAttachment> _uploadedEvidence = [];

  @override
  void dispose() {
    _currentSolutionCtrl.dispose();
    _expectedPriceCtrl.dispose();
    _missingFeatureCtrl.dispose();
    _textFeedbackCtrl.dispose();
    _evidenceLinksCtrl.dispose();
    super.dispose();
  }

  bool _isCurrentStepValid() {
    switch (_step) {
      case 1: return true;
      case 2: return _currentSolutionCtrl.text.trim().isNotEmpty;
      case 3: return !_willingToPay || _expectedPriceCtrl.text.trim().isNotEmpty;
      case 4: return _missingFeatureCtrl.text.trim().isNotEmpty;
      case 5: return _overallRating > 0;
      case 6: return true;
      case 7: return true;
      default: return false;
    }
  }

  void _submitFeedback() async {
    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final currentUser = ref.read(mockDataStoreProvider).currentUser;

    final newFeedback = StructuredFeedback(
      id: "fb_${DateTime.now().millisecondsSinceEpoch}",
      validationId: widget.validation.id,
      validatorId: currentUser?.id ?? "me",
      problemFrequency: _problemFrequency,
      currentSolution: _currentSolutionCtrl.text,
      willingToPay: _willingToPay,
      expectedPrice: _expectedPriceCtrl.text,
      missingFeature: _missingFeatureCtrl.text,
      overallRating: _overallRating,
      textFeedback: _textFeedbackCtrl.text,
      evidence: _uploadedEvidence,
      createdAt: DateTime.now(),
    );

    ref.read(mockDataStoreProvider).addStructuredFeedback(newFeedback);

    setState(() {
      _isSubmitting = false;
    });

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: AppSpacing.md),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: colors.text),
                    onPressed: () {
                      if (Navigator.canPop(context)) Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Validation Feedback",
                      style: AppTypography.headline.copyWith(color: colors.text),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for back button
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: LinearProgressIndicator(
                value: _step / _totalSteps,
                backgroundColor: colors.cardBackgroundLight,
                valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Idea Context
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.validation.title,
                    style: AppTypography.title3.copyWith(color: colors.text),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.validation.problem,
                    style: AppTypography.body.copyWith(color: colors.textSecondary),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Divider(color: colors.divider, height: 1, thickness: 1),

            // Steps content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                  child: _buildStepContent(colors),
                ),
              ),
            ),

            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
              child: Row(
                children: [
                  if (_step > 1) ...[
                    Expanded(
                      child: SecondaryButton(
                        title: "Back",
                        action: () {
                          setState(() {
                            _step -= 1;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Expanded(
                    flex: 2,
                    child: Opacity(
                      opacity: _isCurrentStepValid() ? 1.0 : 0.5,
                      child: _step < _totalSteps
                          ? PrimaryButton(
                              title: "Next",
                              action: _isCurrentStepValid() ? () {
                                setState(() {
                                  _step += 1;
                                });
                              } : () {},
                            )
                          : PrimaryButton(
                              title: "Submit Feedback",
                              isLoading: _isSubmitting,
                              action: _isCurrentStepValid() ? _submitFeedback : () {},
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(AppThemeColors colors) {
    switch (_step) {
      case 1:
        return _buildFrequencyStep(colors);
      case 2:
        return _buildCurrentSolutionStep(colors);
      case 3:
        return _buildPricingStep(colors);
      case 4:
        return _buildMissingFeatureStep(colors);
      case 5:
        return _buildRatingStep(colors);
      case 6:
        return _buildTextFeedbackStep(colors);
      case 7:
        return _buildEvidenceStep(colors);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFrequencyStep(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("How often do you experience this problem?", style: AppTypography.title2.copyWith(color: colors.text)),
        const SizedBox(height: AppSpacing.md),
        ...ProblemFrequency.values.map((freq) {
          final isSelected = _problemFrequency == freq;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _problemFrequency = freq;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary.withValues(alpha: 0.1) : colors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? colors.primary : colors.border, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(freq.value, style: AppTypography.body.copyWith(color: colors.text)),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: colors.primary)
                    else
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.divider, width: 1),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCurrentSolutionStep(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What do you currently use to solve this?", style: AppTypography.title2.copyWith(color: colors.text)),
        const SizedBox(height: 4),
        Text(
          "Competitors, spreadsheets, manual work, or nothing?",
          style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.divider, width: 1),
          ),
          child: TextField(
            controller: _currentSolutionCtrl,
            onChanged: (v) => setState(() {}),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: AppTypography.body.copyWith(color: colors.text),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppSpacing.sm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPricingStep(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Would you pay for a solution to this?", style: AppTypography.title2.copyWith(color: colors.text)),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _willingToPay = true;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _willingToPay ? colors.primary : colors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border, width: 1),
                  ),
                  child: Text(
                    "Yes",
                    style: AppTypography.buttonLabel.copyWith(color: _willingToPay ? Colors.white : colors.text),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _willingToPay = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: !_willingToPay ? colors.primary : colors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border, width: 1),
                  ),
                  child: Text(
                    "No",
                    style: AppTypography.buttonLabel.copyWith(color: !_willingToPay ? Colors.white : colors.text),
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_willingToPay) ...[
          const SizedBox(height: AppSpacing.lg),
          Text("What would you expect to pay?", style: AppTypography.headline.copyWith(color: colors.text)),
          const SizedBox(height: AppSpacing.sm),
          Container(
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.divider, width: 1),
            ),
            child: TextField(
              controller: _expectedPriceCtrl,
              onChanged: (v) => setState(() {}),
              style: AppTypography.body.copyWith(color: colors.text),
              decoration: InputDecoration(
                hintText: "E.g. \$10/month, \$100 one-time",
                hintStyle: AppTypography.body.copyWith(color: colors.textSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSpacing.md),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMissingFeatureStep(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What's the #1 thing existing solutions are missing?", style: AppTypography.title2.copyWith(color: colors.text)),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.divider, width: 1),
          ),
          child: TextField(
            controller: _missingFeatureCtrl,
            onChanged: (v) => setState(() {}),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: AppTypography.body.copyWith(color: colors.text),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppSpacing.sm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingStep(AppThemeColors colors) {
    String ratingDesc = "Select a rating";
    switch (_overallRating) {
      case 1: ratingDesc = "Terrible idea, do not build"; break;
      case 2: ratingDesc = "Weak, needs major pivot"; break;
      case 3: ratingDesc = "Average, execution will be hard"; break;
      case 4: ratingDesc = "Strong idea, I would use this"; break;
      case 5: ratingDesc = "Incredible, I want to invest/buy now"; break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Overall, how strong is this idea?", style: AppTypography.title2.copyWith(color: colors.text)),
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final star = index + 1;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _overallRating = star;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  star <= _overallRating ? Icons.star : Icons.star_border,
                  size: 40,
                  color: star <= _overallRating ? colors.warning : colors.divider,
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(ratingDesc, style: AppTypography.headline.copyWith(color: colors.textSecondary)),
      ],
    );
  }

  Widget _buildTextFeedbackStep(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Any additional thoughts?", style: AppTypography.title2.copyWith(color: colors.text)),
        const SizedBox(height: 4),
        Text(
          "Be brutally honest. Founders need truth, not validation.",
          style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.divider, width: 1),
          ),
          child: TextField(
            controller: _textFeedbackCtrl,
            onChanged: (v) => setState(() {}),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: AppTypography.body.copyWith(color: colors.text),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(AppSpacing.sm),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvidenceStep(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Provide Evidence", style: AppTypography.title2.copyWith(color: colors.text)),
        const SizedBox(height: 4),
        Text(
          "Opinions are cheap. Add links or screenshots to prove your feedback.",
          style: AppTypography.subheadline.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        
        GestureDetector(
          onTap: () {
            setState(() {
              _uploadedEvidence.add(
                EvidenceAttachment(
                  id: "ev_${DateTime.now().millisecondsSinceEpoch}",
                  type: EvidenceType.image,
                  url: "simulated_upload.jpg",
                  description: "Uploaded Screenshot",
                ),
              );
            });
          },
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colors.border, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo, color: colors.primary),
                const SizedBox(width: 8),
                Text("Upload Screenshot", style: AppTypography.buttonLabel.copyWith(color: colors.primary)),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border, width: 1),
          ),
          child: TextField(
            controller: _evidenceLinksCtrl,
            onChanged: (v) => setState(() {}),
            style: AppTypography.body.copyWith(color: colors.text),
            decoration: InputDecoration(
              hintText: "Add a link (e.g., to a competitor's pricing)",
              hintStyle: AppTypography.body.copyWith(color: colors.textSecondary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSpacing.md),
            ),
          ),
        ),
        if (_evidenceLinksCtrl.text.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _uploadedEvidence.add(
                    EvidenceAttachment(
                      id: "ev_${DateTime.now().millisecondsSinceEpoch}",
                      type: EvidenceType.link,
                      url: _evidenceLinksCtrl.text,
                      description: "Link provided",
                    ),
                  );
                  _evidenceLinksCtrl.clear();
                });
              },
              child: Text("Attach Link", style: AppTypography.caption.copyWith(color: colors.primary)),
            ),
          ),
        
        if (_uploadedEvidence.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text("Attached Evidence", style: AppTypography.headline.copyWith(color: colors.text)),
          const SizedBox(height: AppSpacing.sm),
          ..._uploadedEvidence.map((evidence) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: colors.cardBackgroundLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    evidence.type == EvidenceType.image ? Icons.photo : Icons.link,
                    size: 20,
                    color: colors.text,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      evidence.url,
                      style: AppTypography.caption.copyWith(color: colors.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: colors.destructive, size: 20),
                    onPressed: () {
                      setState(() {
                        _uploadedEvidence.removeWhere((e) => e.id == evidence.id);
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
