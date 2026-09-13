import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../components/custom_text_field.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';
import '../../models/mock_data_store_provider.dart';
import '../../utils/haptic_manager.dart';

class ProfileSetupWizardView extends ConsumerStatefulWidget {
  const ProfileSetupWizardView({super.key});

  @override
  ConsumerState<ProfileSetupWizardView> createState() => _ProfileSetupWizardViewState();
}

class _ProfileSetupWizardViewState extends ConsumerState<ProfileSetupWizardView> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form Data
  final TextEditingController _usernameController = TextEditingController();
  String _founderType = "";
  final Set<String> _selectedInterests = {};
  final Set<String> _selectedSkills = {};
  final TextEditingController _locationController = TextEditingController();
  bool _notificationsEnabled = false;

  bool _isFinishing = false;

  @override
  void dispose() {
    _pageController.dispose();
    _usernameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _finishSetup() async {
    setState(() {
      _isFinishing = true;
    });
    
    HapticManager.shared.notificationSuccess();
    ref.read(mockDataStoreProvider).login();

    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (!mounted) return;
    
    setState(() {
      _isFinishing = false;
      _currentStep = 4;
    });

    _pageController.animateToPage(
      4,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    await Future.delayed(const Duration(milliseconds: 1200));
    
    if (!mounted) return;
    
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header / Progress
            if (_currentStep < 4)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Row(
                        children: [
                          if (_currentStep > 0)
                            GestureDetector(
                              onTap: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 20,
                                color: colors.text,
                              ),
                            )
                          else
                            const SizedBox(width: 20),
                            
                          const Spacer(),
                          
                          Text(
                            "Step ${_currentStep + 1} of 4",
                            style: AppTypography.headline.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                          
                          const Spacer(),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          Container(
                            height: 8,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic,
                                height: 8,
                                width: constraints.maxWidth * (_currentStep + 1) / 4,
                                decoration: BoxDecoration(
                                  color: colors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(), // Disable swipe
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                children: [
                  _UsernameStepView(controller: _usernameController),
                  _FounderTypeStepView(
                    selectedType: _founderType,
                    onTypeSelected: (type) {
                      setState(() {
                        _founderType = type;
                      });
                    },
                  ),
                  _SkillsStepView(
                    selectedInterests: _selectedInterests,
                    selectedSkills: _selectedSkills,
                    onStateChanged: () => setState(() {}),
                  ),
                  _LocationStepView(
                    controller: _locationController,
                    notificationsEnabled: _notificationsEnabled,
                    onToggleNotifications: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                  ),
                  const _SetupSuccessStepView(),
                ],
              ),
            ),
            
            // Bottom Action
            if (_currentStep < 4)
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                child: GestureDetector(
                  onTap: _isFinishing
                      ? null
                      : () {
                          if (_currentStep < 3) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _finishSetup();
                          }
                        },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _currentStep == 3 ? "Complete Profile" : "Continue",
                          style: AppTypography.headline.copyWith(color: Colors.white),
                        ),
                        if (_isFinishing) ...[
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ] else ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UsernameStepView extends StatelessWidget {
  final TextEditingController controller;

  const _UsernameStepView({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pick a username",
            style: AppTypography.title1.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            "This is how other builders will find you.",
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          CustomTextField(
            placeholder: "@founder",
            controller: controller,
            icon: Icons.alternate_email, // at symbol
          ),
        ],
      ),
    );
  }
}

class _FounderTypeStepView extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const _FounderTypeStepView({
    required this.selectedType,
    required this.onTypeSelected,
  });

  final List<Map<String, String>> types = const [
    {"title": "Solo Founder", "desc": "Building it all alone right now."},
    {"title": "Technical", "desc": "I code and build the product."},
    {"title": "Non-Technical", "desc": "I handle business, sales, and design."},
    {"title": "Seeking Co-founder", "desc": "Looking for someone to join me."},
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What type of\nfounder are you?",
            style: AppTypography.title1.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: ListView.separated(
              itemCount: types.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final type = types[index];
                final isSelected = selectedType == type["title"];
                
                return GestureDetector(
                  onTap: () => onTypeSelected(type["title"]!),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: colors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? colors.primary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type["title"]!,
                                style: AppTypography.headline.copyWith(color: colors.text),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                type["desc"]!,
                                style: AppTypography.caption.copyWith(color: colors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: colors.primary,
                            size: 24,
                          )
                        else
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colors.textSecondary.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillsStepView extends StatelessWidget {
  final Set<String> selectedInterests;
  final Set<String> selectedSkills;
  final VoidCallback onStateChanged;

  const _SkillsStepView({
    required this.selectedInterests,
    required this.selectedSkills,
    required this.onStateChanged,
  });

  final List<String> industries = const ["AI", "SaaS", "EdTech", "FinTech", "HealthTech", "Crypto"];
  final List<String> skills = const ["Swift", "React", "Design", "Marketing", "Sales", "Backend"];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What are your\ninterests & skills?",
            style: AppTypography.title1.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            "Industries",
            style: AppTypography.headline.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          _WrapSelector(
            items: industries,
            selectedItems: selectedInterests,
            onChanged: onStateChanged,
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            "Skills",
            style: AppTypography.headline.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          _WrapSelector(
            items: skills,
            selectedItems: selectedSkills,
            onChanged: onStateChanged,
          ),
          
          const SizedBox(height: AppSpacing.xxl), // padding bottom
        ],
      ),
    );
  }
}

class _WrapSelector extends StatelessWidget {
  final List<String> items;
  final Set<String> selectedItems;
  final VoidCallback onChanged;

  const _WrapSelector({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        
        return GestureDetector(
          onTap: () {
            if (isSelected) {
              selectedItems.remove(item);
            } else {
              selectedItems.add(item);
            }
            onChanged();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.cardBackgroundLight,
              borderRadius: BorderRadius.circular(100), // Capsule
            ),
            child: Text(
              item,
              style: AppTypography.subheadline.copyWith(
                color: isSelected ? Colors.white : colors.text,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LocationStepView extends StatelessWidget {
  final TextEditingController controller;
  final bool notificationsEnabled;
  final ValueChanged<bool> onToggleNotifications;

  const _LocationStepView({
    required this.controller,
    required this.notificationsEnabled,
    required this.onToggleNotifications,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.lg, right: AppSpacing.lg, top: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Almost there",
            style: AppTypography.title1.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            "Where are you based?",
            style: AppTypography.headline.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpacing.sm),
          CustomTextField(
            placeholder: "e.g. San Francisco, CA",
            controller: controller,
            icon: Icons.location_on_outlined, // mappin.and.ellipse
          ),
          
          const SizedBox(height: AppSpacing.xl),
          
          Text(
            "Stay Updated",
            style: AppTypography.headline.copyWith(color: colors.text),
          ),
          const SizedBox(height: AppSpacing.md),
          
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: colors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enable Notifications",
                        style: AppTypography.body.copyWith(color: colors.text),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Get notified when people validate your ideas or send messages.",
                        style: AppTypography.caption.copyWith(color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: notificationsEnabled,
                  activeColor: colors.primary,
                  onChanged: onToggleNotifications,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupSuccessStepView extends StatefulWidget {
  const _SetupSuccessStepView();

  @override
  State<_SetupSuccessStepView> createState() => _SetupSuccessStepViewState();
}

class _SetupSuccessStepViewState extends State<_SetupSuccessStepView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: _animation.value,
                child: Opacity(
                  opacity: _animation.value.clamp(0.0, 1.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.auto_awesome, // sparkles
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Opacity(
                opacity: _animation.value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - _animation.value)),
                  child: Text(
                    "You're all set!",
                    style: AppTypography.title1.copyWith(color: colors.text),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Opacity(
                opacity: _animation.value.clamp(0.0, 1.0),
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - _animation.value)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    child: Text(
                      "Welcome to TAEED.\nLet's start building ideas that matter.",
                      style: AppTypography.headline.copyWith(color: colors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
