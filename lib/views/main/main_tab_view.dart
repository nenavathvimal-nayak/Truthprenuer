import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../design_system/app_colors.dart';
import '../../design_system/app_typography.dart';
import '../../utils/haptic_manager.dart';
import 'home_container_view.dart';
import '../network/network_view.dart';
import '../profile/builder_profile_view.dart';
import 'explore_view.dart';
import '../validation/validation_dashboard_view.dart';

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

  final List<Widget> _pages = [
    HomeContainerView(),
    const ExploreView(),
    const ValidationDashboardView(),
    const NetworkView(),
    const BuilderProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;

    return Scaffold(
      extendBody: true,
      backgroundColor: colors.background,
      body: IndexedStack(
        index: _selectedTab,
        children: _pages,
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: colors.cardBackground.withAlpha(220),
              border: Border(
                top: BorderSide(
                  color: colors.border.withAlpha(128),
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
                currentIndex: _selectedTab,
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
                items: const [
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

