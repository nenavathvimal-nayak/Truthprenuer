import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/buttons.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class ActionSelectionView extends StatelessWidget {
  const ActionSelectionView({super.key});

  final List<String> actions = const [
    "Validate an Idea",
    "Build a Product",
    "Find Co-founder",
    "Explore Startups"
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xxl),
            
            Text(
              "What are you\nworking on today?",
              style: AppTypography.title1.copyWith(color: colors.text),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                children: actions.map((action) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ScaleButtonStyle(
                      onTap: () {
                        context.go('/'); // navState = .main
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: isDark ? colors.cardBackground : Colors.white,
                          borderRadius: BorderRadius.circular(100), // Capsule
                          border: Border.all(
                            color: Colors.black.withOpacity(0.1),
                            width: isDark ? 0 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              action,
                              style: AppTypography.headline.copyWith(color: colors.text),
                            ),
                            const Spacer(),
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.north_east, // arrow.up.right
                                size: 14,
                                color: Colors.white,
                                weight: 700, // bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: AppSpacing.xl),
            
            // Share an Update Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Share an Update",
                      style: AppTypography.headline.copyWith(
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            "Post your progress, wins,\nor challenges with the\nTAEED community.",
                            style: AppTypography.subheadline.copyWith(
                              color: (isDark ? Colors.black : Colors.white).withOpacity(0.8),
                              height: 1.2, // lineSpacing
                            ),
                          ),
                        ),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.north_east,
                            size: 16,
                            color: Colors.black,
                            weight: 700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const Spacer(),
            
            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/'),
                    child: Text(
                      "Skip",
                      style: AppTypography.headline.copyWith(color: colors.text),
                    ),
                  ),
                  const Spacer(),
                  ScaleButtonStyle(
                    onTap: () => context.go('/'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Next",
                            style: AppTypography.headline.copyWith(
                              color: isDark ? Colors.black : Colors.white,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Icon(
                            Icons.keyboard_double_arrow_right, // chevron.right.2
                            color: isDark ? Colors.black : Colors.white,
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
      ),
    );
  }
}
