import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../models/models.dart';
import '../../utils/haptic_manager.dart';
import '../../repositories/validation_repository.dart';

class ValidationWizardView extends ConsumerStatefulWidget {
  const ValidationWizardView({super.key});

  @override
  ConsumerState<ValidationWizardView> createState() => _ValidationWizardViewState();
}

class _ValidationWizardViewState extends ConsumerState<ValidationWizardView> {
  int _currentStep = 1;
  final int _totalSteps = 7;

  // Step 1: Type
  String _selectedType = "Idea";
  final List<Map<String, dynamic>> _types = [
    {"title": "Idea", "desc": "Validate if the core concept resonates", "icon": Icons.lightbulb_outline},
    {"title": "Problem", "desc": "Verify if the pain point is real and severe", "icon": Icons.warning_amber_outlined},
    {"title": "Pricing", "desc": "Test willingness to pay and price sensitivity", "icon": Icons.payments_outlined},
    {"title": "Feature", "desc": "Prioritize high-demand features", "icon": Icons.tune_outlined},
    {"title": "UI/UX", "desc": "Gather feedback on prototypes or designs", "icon": Icons.design_services_outlined},
    {"title": "MVP", "desc": "Gauge interest for an upcoming initial release", "icon": Icons.rocket_launch_outlined},
    {"title": "Business Model", "desc": "Validate distribution or unit economics", "icon": Icons.analytics_outlined},
    {"title": "Brand", "desc": "Test naming, value proposition, and messaging", "icon": Icons.auto_awesome_outlined},
  ];

  // Step 2: Assumption & Problem
  final TextEditingController _titleCtrl = TextEditingController(text: "Automated Restaurant Inventory");
  final TextEditingController _assumptionCtrl = TextEditingController(
    text: "We believe small restaurant owners will pay ₹999/month for automated daily inventory tracking.",
  );
  final TextEditingController _problemCtrl = TextEditingController(
    text: "Restaurant owners lose 15% of margins on food spoilage because manual stock audits take 2 hours every night.",
  );

  // Step 3: Audience
  final List<String> _availableAudienceRoles = [
    "Restaurant Owner", "Head Chef", "F&B Manager", "Retailer", "Startup Founder", "Tech Operator"
  ];
  final Set<String> _selectedAudienceRoles = {"Restaurant Owner", "F&B Manager"};
  String _selectedGeography = "India";

  // Step 4: Questions
  final List<Map<String, dynamic>> _questions = [
    {
      "id": "q1",
      "text": "How severe is inventory tracking friction in your daily operations?",
      "type": "Rating",
      "required": true,
    },
    {
      "id": "q2",
      "text": "Would you pay ₹999/month for automated WhatsApp inventory alerts?",
      "type": "Yes/No",
      "required": true,
    },
    {
      "id": "q3",
      "text": "What is the biggest concern you have with adopting new inventory software?",
      "type": "Open Text",
      "required": false,
    },
  ];

  // Step 5: Context & Attachments
  final TextEditingController _contextCtrl = TextEditingController(
    text: "We have built a simple WhatsApp bot that scans handwritten supplier invoices and logs stock automatically.",
  );
  final TextEditingController _linkCtrl = TextEditingController(text: "https://truthprenuer.app/demo/inventory");

  // Step 6: Privacy & Duration
  String _selectedVisibility = "Public";
  String _selectedDuration = "14 days";
  final String _selectedResponseLimit = "50 responses";
  bool _allowComments = true;

  // Step 7: Publishing State
  bool _isPublishing = false;
  String _publishingStatus = "Preparing validation...";
  bool _isPublishedSuccess = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _assumptionCtrl.dispose();
    _problemCtrl.dispose();
    _contextCtrl.dispose();
    _linkCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    HapticManager.shared.selection();
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      _showPublishConfirmation();
    }
  }

  void _previousStep() {
    HapticManager.shared.selection();
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      _handleExit();
    }
  }

  void _handleExit() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).appColors.surface,
        title: const Text("Save draft?"),
        content: const Text("You can resume this validation later from your dashboard."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text("Discard"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Draft saved successfully!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).appColors.primary,
            ),
            child: const Text("Save Draft"),
          ),
        ],
      ),
    );
  }

  void _showPublishConfirmation() {
    final colors = Theme.of(context).appColors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Publish this validation?",
                style: AppTypography.title2.copyWith(color: colors.text, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Your validation will be published to the ${_selectedVisibility.toLowerCase()} community. It will remain active for $_selectedDuration or until $_selectedResponseLimit are collected.",
                style: AppTypography.body.copyWith(color: colors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              _buildSummaryRow("Type", _selectedType, colors),
              _buildSummaryRow("Audience", _selectedAudienceRoles.join(", "), colors),
              _buildSummaryRow("Questions", "${_questions.length} questions", colors),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: SecondaryButton(
                      title: "Go Back",
                      action: () => Navigator.pop(sheetContext),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      title: "Publish Now",
                      action: () {
                        Navigator.pop(sheetContext);
                        _executePublish();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, AppThemeColors colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.caption.copyWith(color: colors.textSecondary)),
          Flexible(
            child: Text(
              value,
              style: AppTypography.footnote.copyWith(color: colors.text, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _executePublish() async {
    setState(() {
      _isPublishing = true;
      _publishingStatus = "Preparing validation...";
    });

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _publishingStatus = "Publishing questions & audience filters...");

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _publishingStatus = "Indexing on Truthprenuer marketplace...");

    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final dataStore = ref.read(mockDataStoreProvider);
    final repository = ref.read(validationRepositoryProvider);

    final newValidation = ValidationRequest(
      id: "val_${DateTime.now().millisecondsSinceEpoch}",
      title: _titleCtrl.text.trim(),
      problem: _problemCtrl.text.trim(),
      solution: _contextCtrl.text.trim().isNotEmpty ? _contextCtrl.text.trim() : "Proposed solution under validation",
      targetAudience: _selectedAudienceRoles.join(", "),
      authorId: dataStore.currentUser?.id ?? "me",
      authorName: dataStore.currentUser?.name ?? "Founder",
      authorRole: dataStore.currentUser?.role ?? "Founder",
      authorAvatarURL: dataStore.currentUser?.avatarURL,
      tags: [_selectedType, ..._selectedAudienceRoles],
      createdAt: DateTime.now(),
      status: "active",
    );

    await repository.createValidation(newValidation, []);

    setState(() {
      _isPublishing = false;
      _isPublishedSuccess = true;
    });
    HapticManager.shared.notificationSuccess();
  }

  void _addQuestionModal() {
    final colors = Theme.of(context).appColors;
    final textCtrl = TextEditingController();
    String type = "Multiple choice";
    bool req = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Question", style: AppTypography.title2.copyWith(color: colors.text)),
              const SizedBox(height: 12),
              TextField(
                controller: textCtrl,
                style: TextStyle(color: colors.text),
                decoration: InputDecoration(
                  hintText: "e.g. How likely are you to use this weekly?",
                  hintStyle: TextStyle(color: colors.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: type,
                dropdownColor: colors.surface,
                style: TextStyle(color: colors.text),
                decoration: InputDecoration(
                  labelText: "Question Type",
                  labelStyle: TextStyle(color: colors.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: ["Multiple choice", "Rating", "Scale", "Yes/No", "Open text"]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setModalState(() => type = val!),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: Text("Required Question", style: TextStyle(color: colors.text)),
                value: req,
                activeThumbColor: colors.primary,
                onChanged: (val) => setModalState(() => req = val),
              ),
              const SizedBox(height: 14),
              PrimaryButton(
                title: "Save Question",
                action: () {
                  if (textCtrl.text.trim().isNotEmpty) {
                    setState(() {
                      _questions.add({
                        "id": "q_${_questions.length + 1}",
                        "text": textCtrl.text.trim(),
                        "type": type,
                        "required": req,
                      });
                    });
                    Navigator.pop(ctx);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    if (_isPublishedSuccess) {
      return _buildSuccessScreen(colors);
    }

    if (_isPublishing) {
      return _buildPublishingScreen(colors);
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: _previousStep,
        ),
        title: Column(
          children: [
            Text(
              "Step $_currentStep of $_totalSteps",
              style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              _getStepTitle(_currentStep),
              style: AppTypography.headline.copyWith(color: colors.text, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _handleExit,
            child: Text("Save Draft", style: TextStyle(color: colors.textSecondary)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: _currentStep / _totalSteps,
            backgroundColor: colors.divider,
            valueColor: AlwaysStoppedAnimation<Color>(colors.primary),
            minHeight: 4,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _buildCurrentStepContent(colors),
              ),
            ),
            _buildBottomActionBar(colors),
          ],
        ),
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1: return "Validation Type";
      case 2: return "Define Assumption";
      case 3: return "Target Audience";
      case 4: return "Create Questions";
      case 5: return "Context & Links";
      case 6: return "Privacy & Duration";
      case 7: return "Review & Preview";
      default: return "";
    }
  }

  Widget _buildCurrentStepContent(AppThemeColors colors) {
    switch (_currentStep) {
      case 1: return _buildStep1Type(colors);
      case 2: return _buildStep2Assumption(colors);
      case 3: return _buildStep3Audience(colors);
      case 4: return _buildStep4Questions(colors);
      case 5: return _buildStep5Context(colors);
      case 6: return _buildStep6Settings(colors);
      case 7: return _buildStep7Preview(colors);
      default: return const SizedBox.shrink();
    }
  }

  // STEP 1: WHAT ARE YOU VALIDATING?
  Widget _buildStep1Type(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("What do you want to validate?", style: AppTypography.title1.copyWith(color: colors.text)),
        const SizedBox(height: 6),
        Text(
          "Select the core hypothesis area you need feedback on.",
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemCount: _types.length,
          itemBuilder: (context, idx) {
            final t = _types[idx];
            final isSelected = _selectedType == t["title"];

            return InkWell(
              onTap: () {
                setState(() => _selectedType = t["title"]);
                HapticManager.shared.selection();
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isSelected ? colors.primary.withAlpha(20) : colors.cardBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? colors.primary : colors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      t["icon"] as IconData,
                      color: isSelected ? colors.primary : colors.textSecondary,
                      size: 26,
                    ),
                    const Spacer(),
                    Text(
                      t["title"] as String,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t["desc"] as String,
                      style: AppTypography.caption.copyWith(color: colors.textSecondary, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // STEP 2: DEFINE YOUR ASSUMPTION
  Widget _buildStep2Assumption(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Define your assumption", style: AppTypography.title1.copyWith(color: colors.text)),
        const SizedBox(height: 6),
        Text(
          "What do you believe to be true that needs evidence?",
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 20),
        Text("Validation Title", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _titleCtrl,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        Text("Core Hypothesis", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _assumptionCtrl,
          maxLines: 3,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            hintText: "We believe [audience] will [action] because [reason]...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        Text("Problem Being Solved", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _problemCtrl,
          maxLines: 3,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            hintText: "What friction or pain point are customers experiencing?",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  // STEP 3: TARGET AUDIENCE
  Widget _buildStep3Audience(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Target Audience", style: AppTypography.title1.copyWith(color: colors.text)),
        const SizedBox(height: 6),
        Text(
          "Who are the ideal respondents to critique this assumption?",
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 20),
        Text("Relevant Roles & Personas", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableAudienceRoles.map((role) {
            final isSelected = _selectedAudienceRoles.contains(role);
            return FilterChip(
              label: Text(role),
              selected: isSelected,
              selectedColor: colors.primary.withAlpha(40),
              checkmarkColor: colors.primary,
              labelStyle: TextStyle(
                color: isSelected ? colors.primary : colors.text,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: colors.cardBackground,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedAudienceRoles.add(role);
                  } else {
                    _selectedAudienceRoles.remove(role);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Text("Geographic Focus", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedGeography,
          dropdownColor: colors.surface,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: ["India", "Global", "United States", "Southeast Asia", "Middle East"]
              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
              .toList(),
          onChanged: (val) => setState(() => _selectedGeography = val!),
        ),
      ],
    );
  }

  // STEP 4: CREATE QUESTIONS
  Widget _buildStep4Questions(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Questions (${_questions.length})", style: AppTypography.title1.copyWith(color: colors.text)),
            TextButton.icon(
              onPressed: _addQuestionModal,
              icon: const Icon(Icons.add, size: 18),
              label: const Text("Add"),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Formulate specific questions to test your hypothesis.",
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 16),
        ..._questions.asMap().entries.map((entry) {
          final idx = entry.key;
          final q = entry.value;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "Q${idx + 1} • ${q['type']}",
                        style: AppTypography.caption.copyWith(color: colors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 18),
                      color: colors.textSecondary,
                      onPressed: () {
                        setState(() => _questions.removeAt(idx));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  q["text"] as String,
                  style: AppTypography.bodyMedium.copyWith(color: colors.text, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // STEP 5: ADD CONTEXT
  Widget _buildStep5Context(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Context & Details", style: AppTypography.title1.copyWith(color: colors.text)),
        const SizedBox(height: 6),
        Text(
          "Provide background so respondents can evaluate your idea thoroughly.",
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 20),
        Text("Product Narrative", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _contextCtrl,
          maxLines: 4,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            hintText: "Explain how your product or solution works...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        Text("Prototype or Demo Link", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 6),
        TextField(
          controller: _linkCtrl,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            prefixIcon: const Icon(Icons.link),
            hintText: "https://...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  // STEP 6: PRIVACY & DURATION
  Widget _buildStep6Settings(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Privacy & Duration", style: AppTypography.title1.copyWith(color: colors.text)),
        const SizedBox(height: 6),
        Text(
          "Control who can participate and how long this validation stays active.",
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 20),
        Text("Visibility", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedVisibility,
          dropdownColor: colors.surface,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: ["Public", "Community Only", "Connections Only", "Private / Invite Only"]
              .map((v) => DropdownMenuItem(value: v, child: Text(v)))
              .toList(),
          onChanged: (val) => setState(() => _selectedVisibility = val!),
        ),
        const SizedBox(height: 16),
        Text("Duration", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedDuration,
          dropdownColor: colors.surface,
          style: TextStyle(color: colors.text),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.cardBackground,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          items: ["7 days", "14 days", "30 days"]
              .map((d) => DropdownMenuItem(value: d, child: Text(d)))
              .toList(),
          onChanged: (val) => setState(() => _selectedDuration = val!),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text("Allow open discussion comments", style: TextStyle(color: colors.text)),
          value: _allowComments,
          activeThumbColor: colors.primary,
          onChanged: (val) => setState(() => _allowComments = val),
        ),
      ],
    );
  }

  // STEP 7: PREVIEW
  Widget _buildStep7Preview(AppThemeColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Respondent Preview", style: AppTypography.title1.copyWith(color: colors.text)),
        const SizedBox(height: 6),
        Text(
          "This is exactly what verified founders and testers will see.",
          style: AppTypography.body.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.primary.withAlpha(120)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: colors.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(_selectedType, style: TextStyle(color: colors.primary, fontSize: 11)),
                  ),
                  const Spacer(),
                  Text("~2 min completion", style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              Text(_titleCtrl.text, style: AppTypography.title2.copyWith(color: colors.text, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(_assumptionCtrl.text, style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary)),
              const Divider(height: 24),
              Text("Survey Questions:", style: AppTypography.caption.copyWith(color: colors.textSecondary)),
              const SizedBox(height: 8),
              ..._questions.map((q) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.help_outline, size: 16, color: colors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(q["text"], style: TextStyle(color: colors.text))),
                  ],
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(AppThemeColors colors) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.divider)),
      ),
      child: Row(
        children: [
          if (_currentStep > 1) ...[
            Expanded(
              child: SecondaryButton(
                title: "Back",
                action: _previousStep,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: PrimaryButton(
              title: _currentStep == _totalSteps ? "Publish Validation" : "Continue",
              action: _nextStep,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublishingScreen(AppThemeColors colors) {
    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: colors.primary),
              const SizedBox(height: 24),
              Text("Publishing Validation", style: AppTypography.title2.copyWith(color: colors.text)),
              const SizedBox(height: 8),
              Text(_publishingStatus, style: AppTypography.body.copyWith(color: colors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessScreen(AppThemeColors colors) {
    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colors.primary.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, size: 40, color: colors.primary),
              ),
              const SizedBox(height: 24),
              Text(
                "Validation Published!",
                style: AppTypography.title1.copyWith(color: colors.text, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Your validation is now live and waiting for responses from the community.",
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: 36),
              PrimaryButton(
                title: "View Validation",
                action: () {
                  Navigator.pop(context);
                  context.push('/explore');
                },
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                title: "Back to Home",
                action: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
