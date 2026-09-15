import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../models/models.dart';
import '../models/role_provider.dart';
import '../utils/haptic_manager.dart';

class RoleSwitcherModal extends ConsumerWidget {
  const RoleSwitcherModal({super.key});

  static Future<void> show(BuildContext context) {
    HapticManager.shared.impactLight();
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const RoleSwitcherModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final currentRole = ref.watch(roleProvider);

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
      child: SafeArea(
        child: SingleChildScrollView(
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
                    color: colors.border.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Switch Workspace",
                        style: AppTypography.title2.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Select your active Truthprenuer lens",
                        style: AppTypography.footnote.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: colors.textSecondary, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // List of roles
              ...UserRole.values.map((role) {
                final isSelected = role == currentRole;
                return _buildRoleCard(
                  context: context,
                  ref: ref,
                  colors: colors,
                  role: role,
                  isSelected: isSelected,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required WidgetRef ref,
    required AppThemeColors colors,
    required UserRole role,
    required bool isSelected,
  }) {
    final (icon, tag, description) = _getRoleDetails(role);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticManager.shared.impactMedium();
            ref.read(roleProvider.notifier).switchRole(role);
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Switched to ${role.label} Workspace",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                backgroundColor: colors.primary,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: isSelected
                  ? colors.primary.withValues(alpha: 0.08)
                  : colors.background.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? colors.primary
                    : colors.border.withValues(alpha: 0.4),
                width: isSelected ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                // Role Icon Container
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.primary.withValues(alpha: 0.15)
                        : colors.cardBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colors.primary.withValues(alpha: 0.3)
                          : colors.border.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Icon(
                    icon,
                    size: 22,
                    color: isSelected ? colors.primary : colors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),

                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            role.label,
                            style: AppTypography.subheadline.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colors.primary.withValues(alpha: 0.15)
                                  : colors.border.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              tag,
                              style: AppTypography.labelSmall.copyWith(
                                color: isSelected ? colors.primary : colors.textSecondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: AppTypography.footnote.copyWith(
                          color: colors.textSecondary,
                          fontSize: 12,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                // Radio/Check indicator
                const SizedBox(width: AppSpacing.sm),
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? colors.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.border,
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  (IconData, String, String) _getRoleDetails(UserRole role) {
    switch (role) {
      case UserRole.founder:
        return (
          Icons.rocket_launch_rounded,
          "EXECUTIVE",
          "Hypothesis testing, risk radar & validation crucible",
        );
      case UserRole.investor:
        return (
          Icons.analytics_rounded,
          "SIGNALS",
          "Truth-validated deal flow, market metrics & diligence signals",
        );
      case UserRole.professional:
        return (
          Icons.psychology_rounded,
          "EXPERTISE",
          "Lend domain validation, earn karma & guide founders",
        );
      case UserRole.creator:
        return (
          Icons.campaign_rounded,
          "STUDIO",
          "Publish startup wisdom, track reach & case studies",
        );
      case UserRole.student:
        return (
          Icons.school_rounded,
          "ACADEMY",
          "Learn validation by doing, practice arena & mentor matchmaking",
        );
    }
  }
}

class RoleBadgePill extends ConsumerWidget {
  const RoleBadgePill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final currentRole = ref.watch(roleProvider);

    final icon = switch (currentRole) {
      UserRole.founder => Icons.rocket_launch_rounded,
      UserRole.investor => Icons.analytics_rounded,
      UserRole.professional => Icons.psychology_rounded,
      UserRole.creator => Icons.campaign_rounded,
      UserRole.student => Icons.school_rounded,
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => RoleSwitcherModal.show(context),
        borderRadius: BorderRadius.circular(100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: colors.primary.withValues(alpha: 0.35),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 12, color: colors.primary),
              const SizedBox(width: 5),
              Text(
                currentRole.label.toUpperCase(),
                style: AppTypography.caption.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 10,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(width: 3),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 14,
                color: colors.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
