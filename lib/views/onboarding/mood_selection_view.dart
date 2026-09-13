import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../components/buttons.dart';
import '../../components/mascot_face_view.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_spacing.dart';
import '../../design_system/app_typography.dart';

class MoodSelectionView extends StatefulWidget {
  const MoodSelectionView({super.key});

  @override
  State<MoodSelectionView> createState() => _MoodSelectionViewState();
}

class _MoodSelectionViewState extends State<MoodSelectionView> {
  final MascotEmotion _selectedEmotion = MascotEmotion.sad;
  final String _moodText = "Rueful";

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    // In SwiftUI it sets background and expects white elements.
    // The original MascotFaceView handles dark mode logic, but it's hardcoded to `.white` foreground color here.

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                "How's your\nentrepreneurial\nenergy today?",
                style: AppTypography.title2.copyWith(color: colors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            
            const Spacer(),
            
            // Mascot
            MascotFaceView(
              emotion: _selectedEmotion,
              size: 200,
            ),
            
            const Spacer(),
            
            Column(
              children: [
                Text(
                  "I'm feeling",
                  style: AppTypography.body.copyWith(color: colors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  _moodText,
                  style: AppTypography.title3.copyWith(color: Colors.white),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Paging dots placeholder
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  if (index == 4) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm / 2),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: colors.primary, width: 2),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.primary,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm / 2),
                      width: 4,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2), // Capsule
                      ),
                    );
                  }
                }),
              ),
            ),
            
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
                    onTap: () => context.go('/action'),
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
                            style: AppTypography.headline.copyWith(color: Colors.white),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Icon(
                            Icons.keyboard_double_arrow_right, // chevron.right.2
                            color: Colors.white,
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
