import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_typography.dart';
import '../design_system/responsive_layout.dart';
import '../models/role_provider.dart';
import '../repositories/app_providers.dart';
import '../utils/haptic_manager.dart';
import 'role_switcher_modal.dart';

import '../repositories/network_connectivity_provider.dart';

/// Master Adaptive Shell that automatically detects device types:
/// - MOBILE (< 600px): 1 Section with bottom navigation
/// - FOLDABLE & TAB (600px - 1139px): 2 to 3 Sections with Nav Rail + Workspace + Optional Intel Panel
/// - DESKTOP (>= 1140px): 3 Dedicated Sections with Sidebar + Workspace + Intelligence Console
class AdaptiveAppShell extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<Widget> children;

  const AdaptiveAppShell({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.children,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final deviceType = context.deviceType;
    final safeIndex = selectedIndex.clamp(0, children.length - 1);

    // 1. MOBILE: 1 Section with Bottom Navigation Bar
    if (deviceType == DeviceType.mobile) {
      return Scaffold(
        backgroundColor: colors.background,
        body: Column(
          children: [
            const _OfflineSyncBanner(),
            Expanded(
              child: IndexedStack(
                index: safeIndex,
                children: children,
              ),
            ),
          ],
        ),
        bottomNavigationBar: _MobileBottomBar(
          selectedIndex: safeIndex,
          onTap: onTabSelected,
        ),
      );
    }

    // 2. FOLDABLE & TABLET: 2-3 Sections with Navigation Rail
    if (deviceType == DeviceType.foldable || deviceType == DeviceType.tablet) {
      final showThirdSection = context.windowWidth >= 960.0;

      return Scaffold(
        backgroundColor: colors.background,
        body: Column(
          children: [
            const _OfflineSyncBanner(),
            Expanded(
              child: Row(
                children: [
                  // Section 1: Navigation Rail
                  _AdaptiveNavRail(
                    selectedIndex: safeIndex,
                    onTap: onTabSelected,
                  ),
                  VerticalDivider(width: 1, thickness: 1, color: colors.border),

                  // Section 2: Center Primary Workspace
                  Expanded(
                    child: IndexedStack(
                      index: safeIndex,
                      children: children,
                    ),
                  ),

                  // Section 3: Right Contextual Intelligence Panel (if width >= 960)
                  if (showThirdSection) ...[
                    VerticalDivider(width: 1, thickness: 1, color: colors.border),
                    const SizedBox(
                      width: 300,
                      child: _AdaptiveRightIntelligencePanel(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    // 3. DESKTOP: 3 Dedicated Permanent Sections
    return Scaffold(
      backgroundColor: colors.background,
      body: Column(
        children: [
          const _OfflineSyncBanner(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1: Left Navigation Console & Founder Hub (260px)
                SizedBox(
                  width: 260,
                  child: _DesktopLeftSidebar(
                    selectedIndex: safeIndex,
                    onTabSelected: onTabSelected,
                  ),
                ),
                VerticalDivider(width: 1, thickness: 1, color: colors.border),

                // Section 2: Center Primary Workspace (Expanded, centered with optimal reading constraint)
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 860),
                      child: IndexedStack(
                        index: safeIndex,
                        children: children,
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 1, thickness: 1, color: colors.border),

                // Section 3: Right Intelligence Console & Live Signals (340px)
                const SizedBox(
                  width: 340,
                  child: _AdaptiveRightIntelligencePanel(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfflineSyncBanner extends ConsumerWidget {
  const _OfflineSyncBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final netState = ref.watch(networkConnectivityProvider);
    final colors = Theme.of(context).appColors;

    if (netState.isOnline) {
      return const SizedBox.shrink();
    }

    if (netState.isSyncing) {
      return Semantics(
        liveRegion: true,
        label: "Reconnecting and synchronizing state",
        child: Container(
          width: double.infinity,
          color: colors.primary.withValues(alpha: 0.15),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: colors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Reconnecting and synchronizing state...",
                style: AppTypography.caption.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Offline state
    return Semantics(
      liveRegion: true,
      label: "Offline mode. Showing cached empirical data.",
      child: Container(
        key: const ValueKey('offline_banner'),
        width: double.infinity,
        color: colors.surfaceElevated,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 16,
              color: colors.warning,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Offline. Showing cached empirical data.",
                style: AppTypography.caption.copyWith(
                  color: colors.warning,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            InkWell(
              key: const ValueKey('offline_retry_btn'),
              onTap: () {
                HapticManager.shared.impactLight();
                ref.read(networkConnectivityProvider.notifier).checkConnectivity();
              },
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "Retry",
                  style: AppTypography.caption.copyWith(
                    color: colors.warning,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.underline,
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

// ============================================================================
// MOBILE NAVIGATION BAR (SECTION 1 OF MOBILE)
// ============================================================================
class _MobileBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _MobileBottomBar({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      color: colors.cardBackground,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              currentIndex: selectedIndex,
              onTap: (index) {
                HapticManager.shared.selection();
                onTap(index);
              },
              selectedItemColor: AppPalette.orange,
              unselectedItemColor: colors.textTertiary,
              selectedFontSize: 10,
              unselectedFontSize: 10,
              selectedLabelStyle: AppTypography.tabBarLabel.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppPalette.orange,
              ),
              unselectedLabelStyle: AppTypography.tabBarLabel.copyWith(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: colors.textTertiary,
              ),
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.home_outlined, size: 22),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.home_rounded, size: 22),
                  ),
                  label: "HOME",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.explore_outlined, size: 22),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.explore_rounded, size: 22),
                  ),
                  label: "EXPLORE",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.verified_outlined, size: 22),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.verified_rounded, size: 22),
                  ),
                  label: "VALIDATE",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.people_outline_rounded, size: 22),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.people_rounded, size: 22),
                  ),
                  label: "NETWORK",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.person_outline_rounded, size: 22),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Icon(Icons.person_rounded, size: 22),
                  ),
                  label: "PROFILE",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// FOLDABLE & TABLET NAVIGATION RAIL (SECTION 1 OF TABLET)
// ============================================================================
class _AdaptiveNavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const _AdaptiveNavRail({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Container(
      width: 76,
      color: colors.cardBackground,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            // Brand Mark
            Image.asset(
              'assets/logos/truthprenuer_mark_transparent.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),

            // Quick Create Floating Button
            Material(
              color: AppPalette.orange,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: () {
                  HapticManager.shared.impactMedium();
                  context.push('/validation-wizard');
                },
                borderRadius: BorderRadius.circular(14),
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.add_rounded, color: Colors.white, size: 24),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: colors.cardBackgroundLight, indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // Nav Rail Items
            _RailIconItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: "Home",
              isSelected: selectedIndex == 0,
              onTap: () => onTap(0),
            ),
            _RailIconItem(
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore_rounded,
              label: "Explore",
              isSelected: selectedIndex == 1,
              onTap: () => onTap(1),
            ),
            _RailIconItem(
              icon: Icons.verified_outlined,
              activeIcon: Icons.verified_rounded,
              label: "Validate",
              isSelected: selectedIndex == 2,
              onTap: () => onTap(2),
            ),
            _RailIconItem(
              icon: Icons.people_outline_rounded,
              activeIcon: Icons.people_rounded,
              label: "Network",
              isSelected: selectedIndex == 3,
              onTap: () => onTap(3),
            ),
            _RailIconItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              label: "Profile",
              isSelected: selectedIndex == 4,
              onTap: () => onTap(4),
            ),

            const Spacer(),

            // Settings & Switcher
            IconButton(
              icon: Icon(Icons.settings_outlined, color: colors.textSecondary),
              tooltip: "Settings",
              onPressed: () {
                HapticManager.shared.impactLight();
                context.push('/settings');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _RailIconItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RailIconItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () {
            HapticManager.shared.selection();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected ? AppPalette.orange.withValues(alpha: 0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected ? Border.all(color: AppPalette.orange.withValues(alpha: 0.4)) : null,
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              color: isSelected ? AppPalette.orange : colors.textTertiary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DESKTOP LEFT SIDEBAR (SECTION 1 OF DESKTOP)
// ============================================================================
class _DesktopLeftSidebar extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const _DesktopLeftSidebar({
    this.selectedIndex = 0,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final currentRole = ref.watch(roleProvider);
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.valueOrNull;
    final userName = user?.name ?? (user != null ? "Founder" : "Truthprenuer");

    return Container(
      color: colors.cardBackground,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Branding & Engine Status
            Row(
              children: [
                Image.asset(
                  'assets/logos/truthprenuer_mark_transparent.png',
                  height: 32,
                  width: 32,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      text: "TRUTH",
                      style: AppTypography.title2.copyWith(
                        color: colors.text,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                      children: const [
                        TextSpan(
                          text: "PRENUER",
                          style: TextStyle(
                            color: AppPalette.orange,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x6610B981),
                        blurRadius: 6,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Profile Snapshot Card & Role Switcher
            if (user == null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.cardBackgroundLight),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: colors.primary.withAlpha(30),
                      child: Icon(Icons.person_outline, color: colors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Guest Explorer",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.subheadline.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Click to Sign In",
                            style: AppTypography.caption2.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/auth'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        backgroundColor: colors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("Sign In", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.cardBackgroundLight),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppPalette.orange.withValues(alpha: 0.15),
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : "T",
                        style: AppTypography.headline.copyWith(color: AppPalette.orange),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.subheadline.copyWith(
                              color: colors.text,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            currentRole.name.toUpperCase(),
                            style: AppTypography.caption2.copyWith(
                              color: AppPalette.orange,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.swap_horiz_rounded, size: 18, color: colors.textTertiary),
                      tooltip: "Switch Role",
                      onPressed: () => RoleSwitcherModal.show(context),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Quick Create Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  HapticManager.shared.impactMedium();
                  context.push('/validation-wizard');
                },
                icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
                label: Text(
                  "Create Validation",
                  style: AppTypography.subheadline.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 24),
            Text(
              "WORKSPACES",
              style: AppTypography.caption2.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 10),

            // Desktop Navigation Items
            _DesktopSidebarItem(
              icon: Icons.dashboard_outlined,
              activeIcon: Icons.dashboard_rounded,
              title: "Home Operating Focus",
              tabIndex: 0,
              selectedIndex: selectedIndex,
              onTabSelected: onTabSelected,
            ),
            _DesktopSidebarItem(
              icon: Icons.explore_outlined,
              activeIcon: Icons.explore_rounded,
              title: "Explore Hypotheses",
              tabIndex: 1,
              selectedIndex: selectedIndex,
              onTabSelected: onTabSelected,
            ),
            _DesktopSidebarItem(
              icon: Icons.verified_outlined,
              activeIcon: Icons.verified_rounded,
              title: "Validation Workspaces",
              tabIndex: 2,
              selectedIndex: selectedIndex,
              onTabSelected: onTabSelected,
            ),
            _DesktopSidebarItem(
              icon: Icons.people_outline_rounded,
              activeIcon: Icons.people_rounded,
              title: "Founder Network",
              tabIndex: 3,
              selectedIndex: selectedIndex,
              onTabSelected: onTabSelected,
            ),
            _DesktopSidebarItem(
              icon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
              title: "Profile & Badges",
              tabIndex: 4,
              selectedIndex: selectedIndex,
              onTabSelected: onTabSelected,
            ),

            const SizedBox(height: 20),
            Text(
              "INTELLIGENCE TOOLS",
              style: AppTypography.caption2.copyWith(
                color: colors.textTertiary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),

            _DesktopToolLink(
              icon: Icons.speed_rounded,
              title: "Startup Health Radar",
              onTap: () => context.push('/startup-health'),
            ),
            _DesktopToolLink(
              icon: Icons.lock_outline_rounded,
              title: "Evidence Locker",
              onTap: () => context.push('/evidence-locker'),
            ),
            _DesktopToolLink(
              icon: Icons.leaderboard_outlined,
              title: "Top Validators",
              onTap: () => context.push('/top-validators'),
            ),
            _DesktopToolLink(
              icon: Icons.admin_panel_settings_outlined,
              title: "Admin Console",
              onTap: () => context.push('/admin'),
            ),

            const Spacer(),

            // Footer settings & app info
            Divider(color: colors.cardBackgroundLight),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.shield_outlined, size: 14, color: colors.textTertiary),
                const SizedBox(width: 6),
                Text(
                  "RLS Enforced • Zero Knowledge",
                  style: AppTypography.caption2.copyWith(color: colors.textTertiary),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.settings_outlined, size: 18, color: colors.textTertiary),
                  onPressed: () => context.push('/settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopSidebarItem extends ConsumerWidget {
  final IconData icon;
  final IconData activeIcon;
  final String title;
  final int tabIndex;
  final int selectedIndex;
  final ValueChanged<int>? onTabSelected;

  const _DesktopSidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.title,
    required this.tabIndex,
    required this.selectedIndex,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;
    final uriPath = GoRouterState.of(context).uri.path;
    final bool isSelected = uriPath == '/'
        ? selectedIndex == tabIndex
        : uriPath == '/explore'
            ? tabIndex == 1
            : uriPath == '/validate'
                ? tabIndex == 2
                : uriPath == '/network'
                    ? tabIndex == 3
                    : uriPath == '/profile'
                        ? tabIndex == 4
                        : selectedIndex == tabIndex;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Material(
        color: isSelected ? AppPalette.orange.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () {
            HapticManager.shared.selection();
            if (onTabSelected != null && (uriPath == '/' || uriPath.isEmpty)) {
              onTabSelected!(tabIndex);
            } else {
              switch (tabIndex) {
                case 0:
                  context.go('/');
                  break;
                case 1:
                  context.go('/explore');
                  break;
                case 2:
                  context.go('/validate');
                  break;
                case 3:
                  context.go('/network');
                  break;
                case 4:
                  context.go('/profile');
                  break;
              }
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 19,
                  color: isSelected ? AppPalette.orange : colors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.subheadline.copyWith(
                      color: isSelected ? colors.text : colors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppPalette.orange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _DesktopToolLink extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DesktopToolLink({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return InkWell(
      onTap: () {
        HapticManager.shared.impactLight();
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          children: [
            Icon(icon, size: 17, color: colors.textTertiary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTypography.footnote.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 11, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// RIGHT INTELLIGENCE PANEL (SECTION 3 OF DESKTOP / WIDE TABLET)
// ============================================================================
class _AdaptiveRightIntelligencePanel extends ConsumerWidget {
  const _AdaptiveRightIntelligencePanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).appColors;

    return Container(
      color: colors.cardBackground,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.insights_rounded, size: 18, color: AppPalette.orange),
                const SizedBox(width: 8),
                Text(
                  "INTELLIGENCE FEED",
                  style: AppTypography.caption1.copyWith(
                    color: colors.text,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Card 1: Startup Health Score
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.cardBackgroundLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "STARTUP HEALTH INDEX",
                        style: AppTypography.caption2.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          "STRONG",
                          style: AppTypography.caption2.copyWith(
                            color: const Color(0xFF10B981),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "84",
                        style: AppTypography.hero.copyWith(
                          color: colors.text,
                          fontWeight: FontWeight.w900,
                          fontSize: 36,
                        ),
                      ),
                      Text(
                        "/100",
                        style: AppTypography.subheadline.copyWith(
                          color: colors.textTertiary,
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () => context.push('/startup-health'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppPalette.orange.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        ),
                        child: Text(
                          "Full Radar",
                          style: AppTypography.caption2.copyWith(
                            color: AppPalette.orange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress bars
                  const _HealthMetricBar(label: "Demand Validation", value: 0.88, color: AppPalette.orange),
                  const SizedBox(height: 6),
                  const _HealthMetricBar(label: "PMF Readiness", value: 0.76, color: Color(0xFF3B82F6)),
                  const SizedBox(height: 6),
                  const _HealthMetricBar(label: "Evidence Rigor", value: 0.91, color: Color(0xFF10B981)),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Card 2: Live Market Signals
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.cardBackgroundLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "REAL-TIME SIGNALS",
                        style: AppTypography.caption2.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Icon(Icons.bolt_rounded, size: 16, color: AppPalette.orange),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _SignalMiniRow(
                    icon: Icons.trending_up_rounded,
                    title: "3 Enterprise Responses",
                    subtitle: "\$49/seat/mo validated",
                    color: Color(0xFF10B981),
                  ),
                  const Divider(height: 16),
                  _SignalMiniRow(
                    icon: Icons.warning_amber_rounded,
                    title: "Onboarding Contradiction",
                    subtitle: "Compliance requirement noted",
                    color: colors.warning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Card 3: Top Community Validators
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.cardBackgroundLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "TOP VALIDATORS",
                        style: AppTypography.caption2.copyWith(
                          color: colors.textTertiary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/top-validators'),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                        child: Text(
                          "View All",
                          style: AppTypography.caption2.copyWith(
                            color: AppPalette.orange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _ValidatorMiniItem(name: "Siddharth Verma", score: "99.4%", rank: "#1"),
                  const SizedBox(height: 8),
                  const _ValidatorMiniItem(name: "Ananya Deshmukh", score: "98.1%", rank: "#2"),
                  const SizedBox(height: 8),
                  const _ValidatorMiniItem(name: "Rohan Kulkarni", score: "96.8%", rank: "#3"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthMetricBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _HealthMetricBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTypography.caption2.copyWith(color: colors.textSecondary)),
            Text("${(value * 100).toInt()}%", style: AppTypography.caption2.copyWith(color: colors.text, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 4,
            backgroundColor: colors.cardBackgroundLight,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}

class _SignalMiniRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _SignalMiniRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 14, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.caption1.copyWith(
                  color: colors.text,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.caption2.copyWith(color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValidatorMiniItem extends StatelessWidget {
  final String name;
  final String score;
  final String rank;

  const _ValidatorMiniItem({
    required this.name,
    required this.score,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Row(
      children: [
        Container(
          width: 20,
          alignment: Alignment.center,
          child: Text(
            rank,
            style: AppTypography.caption2.copyWith(
              color: AppPalette.orange,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 12,
          backgroundColor: colors.cardBackgroundLight,
          child: Text(
            name[0],
            style: AppTypography.caption2.copyWith(color: colors.text),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            name,
            style: AppTypography.caption1.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          score,
          style: AppTypography.caption2.copyWith(
            color: const Color(0xFF10B981),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
