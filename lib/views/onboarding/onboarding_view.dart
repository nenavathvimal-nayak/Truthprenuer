import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "Validate First.",
      description: "Don't build in the dark. Get structured feedback from a relevant community before spending months coding.",
      icon: Icons.verified,
    ),
    OnboardingPage(
      title: "Find Co-founders.",
      description: "Connect with builders, designers, and innovators who share your vision.",
      icon: Icons.people,
    ),
    OnboardingPage(
      title: "Build Your Network.",
      description: "Share your startup journey, learn from experienced founders, and grow your professional connections.",
      icon: Icons.language, // network equivalent
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (!mounted) return;
    context.go('/auth'); // Route to auth after onboarding
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          const Spacer(),
          
          SizedBox(
            height: 350,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TweenAnimationBuilder for simple bounce/scale effect could go here
                      Icon(
                        page.icon,
                        size: 80,
                        color: colors.primary,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text(
                        page.title,
                        style: AppTypography.title1.copyWith(color: colors.text),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        page.description,
                        style: AppTypography.body.copyWith(
                          color: colors.text.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Custom Paging Indicator
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl, top: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? colors.primary : colors.divider,
                    borderRadius: BorderRadius.circular(4), // Capsule
                  ),
                );
              }),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: PrimaryButton(
              title: _currentPage == _pages.length - 1 ? "Get Started" : "Next",
              action: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _completeOnboarding();
                }
              },
            ),
          ),
          
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
