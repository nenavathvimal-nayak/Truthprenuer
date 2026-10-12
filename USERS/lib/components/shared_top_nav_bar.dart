import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';
import '../models/models.dart';
import '../models/role_provider.dart';
import '../repositories/app_providers.dart';
import '../utils/haptic_manager.dart';

class SharedTopNavBar extends ConsumerWidget implements PreferredSizeWidget {
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final bool isHome;
  final List<Widget>? actions;

  const SharedTopNavBar({
    super.key,
    this.title,
    this.showBackButton = false,
    this.onBack,
    this.isHome = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    return SafeArea(
      bottom: false,
      child: Container(
        height: 56.0,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
        decoration: BoxDecoration(
          color: colors.background,
          border: Border(
            bottom: BorderSide(
              color: colors.divider.withAlpha(50),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Back button, title, or brand mark
            Expanded(
              child: Row(
                children: [
                  if (showBackButton)
                    _NavIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      tooltip: 'Back',
                      onTap: () {
                        HapticManager.shared.impactLight();
                        if (onBack != null) {
                          onBack!();
                        } else if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go('/');
                        }
                      },
                    )
                  else if (title != null && title!.isNotEmpty)
                    Flexible(
                      child: Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.title2.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logos/truthprenuer_mark_transparent.png',
                          height: 24,
                          width: 24,
                          fit: BoxFit.contain,
                          semanticLabel: 'Truthprenuer Logo',
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: RichText(
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              text: "TRUTH",
                              style: AppTypography.title3.copyWith(
                                color: colors.text,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.6,
                              ),
                              children: [
                                TextSpan(
                                  text: "PRENUER",
                                  style: TextStyle(
                                    color: colors.primary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // Right: Navigation actions ONLY on HOME page, Mode switch removed
            if (isHome)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ref.watch(roleProvider) == UserRole.admin || (ref.watch(currentUserProvider).valueOrNull?.isAdmin ?? false))
                    _NavIconButton(
                      icon: Icons.admin_panel_settings_outlined,
                      tooltip: 'Admin Console',
                      onTap: () {
                        HapticManager.shared.impactMedium();
                        context.push('/admin');
                      },
                    ),
                  _NavIconButton(
                    icon: Icons.chat_bubble_outline_rounded,
                    tooltip: 'Messages',
                    badgeCount: ref.watch(conversationsProvider).where((c) => c.unreadCount > 0).length,
                    onTap: () {
                      HapticManager.shared.impactLight();
                      context.push('/chats');
                    },
                  ),
                  _NavIconButton(
                    icon: Icons.notifications_none_rounded,
                    tooltip: 'Notifications',
                    badgeCount: ref.watch(notificationsProvider).where((n) => !n.isRead).length,
                    onTap: () {
                      HapticManager.shared.impactLight();
                      context.push('/notifications');
                    },
                  ),
                ],
              )
            else if (actions != null && actions!.isNotEmpty)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: actions!,
              ),
          ],
        ),
      ),
    );
  }
}

/// Borderless icon button with ink splash — premium minimal style.
class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int badgeCount;
  final String? tooltip;

  const _NavIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final label = tooltip ?? (icon == Icons.arrow_back_ios_new_rounded ? 'Back' : 'Action button');

    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: colors.textSecondary,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: 9,
                      top: 9,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppPalette.orange,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
