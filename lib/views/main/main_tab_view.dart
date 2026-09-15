import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../models/models.dart';
import '../../models/role_provider.dart';
import '../../utils/haptic_manager.dart';
import 'home_container_view.dart';
import '../network/network_view.dart';
import '../network/top_validators_leaderboard_view.dart';
import '../profile/builder_profile_view.dart';
import 'explore_view.dart';
import '../validation/validation_dashboard_view.dart';
import '../validation/startup_health_dashboard_view.dart';

class MainTabView extends ConsumerStatefulWidget {
  final int initialIndex;
  const MainTabView({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends ConsumerState<MainTabView> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final currentRole = ref.watch(roleProvider);

    final (pages, items) = _getNavConfig(currentRole);

    // Safeguard index within bounds
    final safeIndex = _selectedTab.clamp(0, pages.length - 1);

    return Scaffold(
      extendBody: true,
      backgroundColor: colors.background,
      body: IndexedStack(
        index: safeIndex,
        children: pages,
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: colors.cardBackground.withValues(alpha: 0.88),
              border: Border(
                top: BorderSide(
                  color: colors.border.withValues(alpha: 0.5),
                  width: 0.5,
                ),
              ),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: BottomNavigationBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                currentIndex: safeIndex,
                onTap: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                  HapticManager.shared.selection();
                },
                selectedItemColor: colors.primary,
                unselectedItemColor: colors.textSecondary,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                selectedLabelStyle: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  fontSize: 10,
                ),
                unselectedLabelStyle: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                  fontSize: 10,
                ),
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                items: items,
              ),
            ),
          ),
        ),
      ),
    );
  }

  (List<Widget>, List<BottomNavigationBarItem>) _getNavConfig(UserRole role) {
    switch (role) {
      case UserRole.founder:
        return (
          const [
            HomeContainerView(),
            ExploreView(),
            ValidationDashboardView(),
            NetworkView(),
            BuilderProfileView(),
          ],
          const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore_rounded),
              label: "EXPLORE",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.verified_outlined),
              activeIcon: Icon(Icons.verified_rounded),
              label: "VALIDATE",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: "NETWORK",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "PROFILE",
            ),
          ]
        );

      case UserRole.investor:
        return (
          const [
            HomeContainerView(),
            ExploreView(),
            StartupHealthDashboardView(),
            NetworkView(),
            BuilderProfileView(),
          ],
          const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.travel_explore_outlined),
              activeIcon: Icon(Icons.travel_explore_rounded),
              label: "DEAL FLOW",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights_rounded),
              label: "SIGNALS",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: "NETWORK",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "PROFILE",
            ),
          ]
        );

      case UserRole.professional:
        return (
          const [
            HomeContainerView(),
            ExploreView(),
            ValidationDashboardView(),
            TopValidatorsLeaderboardView(),
            BuilderProfileView(),
          ],
          const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded),
              activeIcon: Icon(Icons.work_rounded),
              label: "REQUESTS",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.rate_review_outlined),
              activeIcon: Icon(Icons.rate_review_rounded),
              label: "CRUCIBLE",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.military_tech_outlined),
              activeIcon: Icon(Icons.military_tech_rounded),
              label: "LEADERS",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "PROFILE",
            ),
          ]
        );

      case UserRole.creator:
        return (
          const [
            HomeContainerView(),
            ExploreView(),
            ValidationDashboardView(),
            NetworkView(),
            BuilderProfileView(),
          ],
          const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_outlined),
              activeIcon: Icon(Icons.auto_awesome_rounded),
              label: "DISCOVER",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              activeIcon: Icon(Icons.article_rounded),
              label: "STORIES",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: "AUDIENCE",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "PROFILE",
            ),
          ]
        );

      case UserRole.student:
        return (
          const [
            HomeContainerView(),
            ExploreView(),
            TopValidatorsLeaderboardView(),
            NetworkView(),
            BuilderProfileView(),
          ],
          const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: "HOME",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center_outlined),
              activeIcon: Icon(Icons.fitness_center_rounded),
              label: "PRACTICE",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school_rounded),
              label: "ACADEMY",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.co_present_outlined),
              activeIcon: Icon(Icons.co_present_rounded),
              label: "MENTORS",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: "PROFILE",
            ),
          ]
        );
    }
  }
}
