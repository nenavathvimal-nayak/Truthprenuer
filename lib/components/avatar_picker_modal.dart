import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../models/mock_data_store_provider.dart';
import '../utils/haptic_manager.dart';

class AvatarPickerModal extends ConsumerStatefulWidget {
  const AvatarPickerModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AvatarPickerModal(),
    );
  }

  @override
  ConsumerState<AvatarPickerModal> createState() => _AvatarPickerModalState();
}

class _AvatarPickerModalState extends ConsumerState<AvatarPickerModal> {
  final TextEditingController _urlController = TextEditingController();

  final List<String> _founderAvatarPresets = [
    "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&h=300&fit=crop",
    "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300&h=300&fit=crop",
    "https://images.unsplash.com/photo-1517841905240-472988babdf9?w=300&h=300&fit=crop",
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300&h=300&fit=crop",
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300&h=300&fit=crop",
    "https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=300&h=300&fit=crop",
    "https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=300&h=300&fit=crop",
    "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=300&h=300&fit=crop",
  ];

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _selectAvatar(String url) {
    HapticManager.shared.impactMedium();
    ref.read(mockDataStoreProvider).updateUserAvatar(url);
    HapticManager.shared.notificationSuccess();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final currentAvatar = ref.watch(mockDataStoreProvider).currentUser?.avatarURL;

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border.withAlpha(150),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Update Profile Photo",
                style: AppTypography.title2.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: colors.textSecondary, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "Choose an executive founder avatar or enter a custom photo link.",
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Preset Avatars Grid
          Text(
            "FOUNDER PRESETS",
            style: AppTypography.labelSmall.copyWith(
              color: colors.primary,
              letterSpacing: 1.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _founderAvatarPresets.map((url) {
              final isSelected = currentAvatar == url;
              return GestureDetector(
                onTap: () => _selectAvatar(url),
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: colors.primary, width: 2.5)
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: colors.primary.withAlpha(80),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, err, stack) => Container(
                        color: colors.border,
                        child: Icon(Icons.person, color: colors.textSecondary),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Custom URL Input
          Text(
            "OR CUSTOM IMAGE URL",
            style: AppTypography.labelSmall.copyWith(
              color: colors.textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: _urlController,
                    style: AppTypography.body.copyWith(color: colors.text, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: "https://example.com/avatar.jpg",
                      hintStyle: AppTypography.body.copyWith(color: colors.textSecondary, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final text = _urlController.text.trim();
                  if (text.isNotEmpty) {
                    _selectAvatar(text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text("Apply", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
