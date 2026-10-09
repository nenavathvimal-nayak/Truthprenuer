import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/haptic_manager.dart';
import 'dashboard_view.dart';
import 'explore_view.dart';
import '../validation/validation_dashboard_view.dart';
import '../network/network_view.dart';
import '../profile/profile_view.dart';
import '../../components/adaptive_app_shell.dart';

class MainTabView extends ConsumerStatefulWidget {
  final int initialIndex;
  const MainTabView({super.key, this.initialIndex = 0});

  @override
  ConsumerState<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends ConsumerState<MainTabView> {
  late int _selectedTab;
  DateTime? _lastBackPressTime;
  final Set<int> _activatedTabs = {};

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialIndex;
    _activatedTabs.add(_selectedTab);
  }

  @override
  void didUpdateWidget(covariant MainTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialIndex != oldWidget.initialIndex) {
      setState(() {
        _selectedTab = widget.initialIndex;
        _activatedTabs.add(_selectedTab);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const rawPages = [
      DashboardView(),
      ExploreView(),
      ValidationDashboardView(),
      NetworkView(),
      ProfileView(),
    ];

    final safeIndex = _selectedTab.clamp(0, rawPages.length - 1);
    _activatedTabs.add(safeIndex);

    final pages = List<Widget>.generate(rawPages.length, (index) {
      if (_activatedTabs.contains(index)) {
        return rawPages[index];
      }
      return const SizedBox.shrink();
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectedTab != 0) {
          HapticManager.shared.impactLight();
          setState(() => _selectedTab = 0);
          return;
        }
        final now = DateTime.now();
        if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
          _lastBackPressTime = now;
          HapticManager.shared.impactLight();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Press back again to exit Truthprenuer"),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }
        SystemNavigator.pop();
      },
      child: AdaptiveAppShell(
        selectedIndex: safeIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedTab = index;
            _activatedTabs.add(index);
          });
        },
        children: pages,
      ),
    );
  }
}
