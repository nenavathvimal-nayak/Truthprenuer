import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';
import 'dashboard_view.dart';
import 'explore_view.dart';
import '../validation/validation_dashboard_view.dart';
import '../network/network_view.dart';
import '../profile/profile_view.dart';

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

    const pages = [
      DashboardView(),
      ExploreView(),
      ValidationDashboardView(),
      NetworkView(),
      ProfileView(),
    ];

    final safeIndex = _selectedTab.clamp(0, pages.length - 1);

    return Scaffold(
      backgroundColor: colors.background,
      body: IndexedStack(
        index: safeIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
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
                currentIndex: safeIndex,
                onTap: (index) {
                  setState(() {
                    _selectedTab = index;
                  });
                  HapticManager.shared.selection();
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
      ),
    );
  }
}
