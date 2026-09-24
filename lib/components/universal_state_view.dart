import 'package:flutter/material.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../utils/haptic_manager.dart';

enum UniversalStateType {
  loading,
  skeleton,
  empty,
  noResults,
  offline,
  error,
  unauthorized,
  sessionExpired,
}

class UniversalStateView extends StatelessWidget {
  final UniversalStateType type;
  final String? title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  const UniversalStateView({
    super.key,
    required this.type,
    this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.icon,
  });

  const UniversalStateView.loading({
    super.key,
    this.title,
    this.message = "Loading...",
  })  : type = UniversalStateType.loading,
        actionLabel = null,
        onAction = null,
        icon = null;

  const UniversalStateView.empty({
    super.key,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_outlined,
  }) : type = UniversalStateType.empty;

  const UniversalStateView.noResults({
    super.key,
    this.title = "No results found",
    this.message = "Try broadening your search terms or clearing filters.",
    this.actionLabel = "Clear Filters",
    this.onAction,
    this.icon = Icons.search_off_rounded,
  }) : type = UniversalStateType.noResults;

  const UniversalStateView.error({
    super.key,
    this.title = "Something went wrong",
    this.message = "We couldn't load this information. Please check your connection and try again.",
    this.actionLabel = "Try Again",
    this.onAction,
    this.icon = Icons.error_outline_rounded,
  }) : type = UniversalStateType.error;

  const UniversalStateView.offline({
    super.key,
    this.title = "You're offline",
    this.message = "Connect to the internet to load updated validations and intelligence.",
    this.actionLabel = "Retry Connection",
    this.onAction,
    this.icon = Icons.wifi_off_rounded,
  }) : type = UniversalStateType.offline;

  const UniversalStateView.unauthorized({
    super.key,
    this.title = "Access Restricted",
    this.message = "This validation sprint is private to its founder and authorized collaborators.",
    this.actionLabel = "Return to Explore",
    this.onAction,
    this.icon = Icons.lock_outline_rounded,
  }) : type = UniversalStateType.unauthorized;

  const UniversalStateView.sessionExpired({
    super.key,
    this.title = "Session Expired",
    this.message = "Your authentication session has expired. Please sign in to continue.",
    this.actionLabel = "Sign In Again",
    this.onAction,
    this.icon = Icons.schedule_outlined,
  }) : type = UniversalStateType.sessionExpired;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    if (type == UniversalStateType.loading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: colors.primary,
                ),
              ),
              if (message != null && message!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  message!,
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    }

    final defaultIcon = switch (type) {
      UniversalStateType.empty => Icons.inbox_outlined,
      UniversalStateType.noResults => Icons.search_off_rounded,
      UniversalStateType.error => Icons.error_outline_rounded,
      UniversalStateType.offline => Icons.wifi_off_rounded,
      UniversalStateType.unauthorized => Icons.lock_outline_rounded,
      UniversalStateType.sessionExpired => Icons.schedule_outlined,
      _ => Icons.info_outline_rounded,
    };

    final displayIcon = icon ?? defaultIcon;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: colors.cardBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colors.border.withValues(alpha: 0.6),
                  width: 1,
                ),
              ),
              child: Icon(
                displayIcon,
                size: 26,
                color: type == UniversalStateType.error || type == UniversalStateType.unauthorized
                    ? colors.primary
                    : colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (title != null && title!.isNotEmpty)
              Text(
                title!,
                style: AppTypography.title3.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                message!,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ElevatedButton(
                onPressed: () {
                  HapticManager.shared.impactLight();
                  onAction!();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.button.copyWith(color: Colors.white),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
