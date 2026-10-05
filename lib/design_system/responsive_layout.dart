import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Form factor categories for auto-detection and dedicated styling
enum DeviceType {
  /// Mobile phones (portrait / narrow landscape) < 600px -> 1 Section
  mobile,

  /// Foldables & compact dual screens 600px - 839px -> 2 Sections
  foldable,

  /// Tablets & medium screens 840px - 1139px -> 2 to 3 Sections
  tablet,

  /// Desktops, laptops & ultrawide >= 1140px -> 3 Sections
  desktop,
}

/// Dedicated styling parameters tailored for each device tier
class DeviceStyles {
  final DeviceType type;
  final EdgeInsets screenPadding;
  final EdgeInsets cardPadding;
  final double cardRadius;
  final double contentMaxWidth;
  final int sectionCount;
  final int gridColumns;
  final double titleFontSize;
  final double bodyFontSize;
  final double sidebarWidth;
  final double rightPanelWidth;
  final bool showBottomNav;
  final bool showNavRail;
  final bool showFullSidebar;
  final bool showRightPanel;

  const DeviceStyles({
    required this.type,
    required this.screenPadding,
    required this.cardPadding,
    required this.cardRadius,
    required this.contentMaxWidth,
    required this.sectionCount,
    required this.gridColumns,
    required this.titleFontSize,
    required this.bodyFontSize,
    required this.sidebarWidth,
    required this.rightPanelWidth,
    required this.showBottomNav,
    required this.showNavRail,
    required this.showFullSidebar,
    required this.showRightPanel,
  });

  /// Mobile: 1 Section, bottom nav, compact touch padding
  factory DeviceStyles.mobile() {
    return const DeviceStyles(
      type: DeviceType.mobile,
      screenPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      cardPadding: EdgeInsets.all(16.0),
      cardRadius: 16.0,
      contentMaxWidth: double.infinity,
      sectionCount: 1,
      gridColumns: 1,
      titleFontSize: 24.0,
      bodyFontSize: 15.0,
      sidebarWidth: 0,
      rightPanelWidth: 0,
      showBottomNav: true,
      showNavRail: false,
      showFullSidebar: false,
      showRightPanel: false,
    );
  }

  /// Foldable: 2 Sections, navigation rail, dual-pane layout
  factory DeviceStyles.foldable() {
    return const DeviceStyles(
      type: DeviceType.foldable,
      screenPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      cardPadding: EdgeInsets.all(18.0),
      cardRadius: 18.0,
      contentMaxWidth: 720.0,
      sectionCount: 2,
      gridColumns: 2,
      titleFontSize: 26.0,
      bodyFontSize: 15.5,
      sidebarWidth: 72.0,
      rightPanelWidth: 0,
      showBottomNav: false,
      showNavRail: true,
      showFullSidebar: false,
      showRightPanel: false,
    );
  }

  /// Tablet: 2-3 Sections, nav rail or compact sidebar, optional right panel
  factory DeviceStyles.tablet({required double width}) {
    final hasThreeSections = width >= 960.0;
    return DeviceStyles(
      type: DeviceType.tablet,
      screenPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      cardPadding: const EdgeInsets.all(20.0),
      cardRadius: 20.0,
      contentMaxWidth: 880.0,
      sectionCount: hasThreeSections ? 3 : 2,
      gridColumns: 2,
      titleFontSize: 28.0,
      bodyFontSize: 16.0,
      sidebarWidth: 80.0,
      rightPanelWidth: hasThreeSections ? 290.0 : 0,
      showBottomNav: false,
      showNavRail: true,
      showFullSidebar: false,
      showRightPanel: hasThreeSections,
    );
  }

  /// Desktop: 3 Dedicated Sections, permanent full sidebar + main + right intelligence panel
  factory DeviceStyles.desktop() {
    return const DeviceStyles(
      type: DeviceType.desktop,
      screenPadding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
      cardPadding: EdgeInsets.all(22.0),
      cardRadius: 20.0,
      contentMaxWidth: 820.0,
      sectionCount: 3,
      gridColumns: 3,
      titleFontSize: 30.0,
      bodyFontSize: 16.0,
      sidebarWidth: 260.0,
      rightPanelWidth: 340.0,
      showBottomNav: false,
      showNavRail: false,
      showFullSidebar: true,
      showRightPanel: true,
    );
  }
}

/// Extension on BuildContext for quick and clean responsive queries
extension ResponsiveContext on BuildContext {
  /// Width of the current window / viewport
  double get windowWidth => MediaQuery.sizeOf(this).width;

  /// Height of the current window / viewport
  double get windowHeight => MediaQuery.sizeOf(this).height;

  /// Auto-detects device type based on window width
  DeviceType get deviceType {
    final width = windowWidth;
    if (width < 600) return DeviceType.mobile;
    if (width < 840) return DeviceType.foldable;
    if (width < 1140) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isFoldable => deviceType == DeviceType.foldable;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isFoldableOrTab => isFoldable || isTablet;

  /// Section count: Mobile = 1, Foldable & Tab = 2-3, Desktop = 3
  int get sectionCount {
    switch (deviceType) {
      case DeviceType.mobile:
        return 1;
      case DeviceType.foldable:
        return 2;
      case DeviceType.tablet:
        return windowWidth >= 960 ? 3 : 2;
      case DeviceType.desktop:
        return 3;
    }
  }

  /// Dedicated device styles
  DeviceStyles get deviceStyles {
    switch (deviceType) {
      case DeviceType.mobile:
        return DeviceStyles.mobile();
      case DeviceType.foldable:
        return DeviceStyles.foldable();
      case DeviceType.tablet:
        return DeviceStyles.tablet(width: windowWidth);
      case DeviceType.desktop:
        return DeviceStyles.desktop();
    }
  }

  /// Selects a responsive value based on device type
  T responsive<T>({
    required T mobile,
    T? foldable,
    T? tablet,
    T? desktop,
  }) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.foldable:
        return foldable ?? tablet ?? mobile;
      case DeviceType.tablet:
        return tablet ?? foldable ?? desktop ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

/// Responsive builder widget that passes device type and styles to child
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType, DeviceStyles styles) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final DeviceType type;
        final DeviceStyles styles;

        if (width < 600) {
          type = DeviceType.mobile;
          styles = DeviceStyles.mobile();
        } else if (width < 840) {
          type = DeviceType.foldable;
          styles = DeviceStyles.foldable();
        } else if (width < 1140) {
          type = DeviceType.tablet;
          styles = DeviceStyles.tablet(width: width);
        } else {
          type = DeviceType.desktop;
          styles = DeviceStyles.desktop();
        }

        return builder(context, type, styles);
      },
    );
  }
}

/// Container that constrains content to readable limits on tablet & desktop
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final AlignmentGeometry alignment;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.deviceStyles;
    final effectiveMaxWidth = maxWidth ?? styles.contentMaxWidth;
    final effectivePadding = padding ?? styles.screenPadding;

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: effectiveMaxWidth,
        ),
        child: Padding(
          padding: effectivePadding,
          child: child,
        ),
      ),
    );
  }
}

/// Adaptive Auth Layout:
/// - Mobile: 1 Section (clean centered auth form)
/// - Foldable / Tab / Desktop: 2 Sections (Left: Hero branding & value proposition, Right: Form card)
class AdaptiveAuthLayout extends StatelessWidget {
  final Widget form;
  final String heroTitle;
  final String heroSubtitle;
  final Widget? bottomAction;

  const AdaptiveAuthLayout({
    super.key,
    required this.form,
    this.heroTitle = "Test What Would Be\nExpensive To Get Wrong",
    this.heroSubtitle = "Turn raw hypotheses into verified market truth with decentralized founder validation.",
    this.bottomAction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    final isWide = !context.isMobile;

    if (!isWide) {
      // Mobile: 1 Section
      return Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                form,
                if (bottomAction != null) ...[
                  const SizedBox(height: AppSpacing.xl),
                  bottomAction!,
                ],
              ],
            ),
          ),
        ),
      );
    }

    // Foldable, Tablet & Desktop: 2 Sections Split
    return Scaffold(
      backgroundColor: colors.background,
      body: Row(
        children: [
          // Section 1: Hero Branding & Market Value Proposition
          Expanded(
            flex: context.isDesktop ? 6 : 5,
            child: Container(
              decoration: BoxDecoration(
                color: colors.cardBackground,
                border: Border(
                  right: BorderSide(
                    color: colors.cardBackgroundLight.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(AppSpacing.xxxl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/logos/truthprenuer_mark_transparent.png',
                        height: 48,
                        width: 48,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 12),
                      RichText(
                        text: TextSpan(
                          text: "TRUTH",
                          style: AppTypography.title1.copyWith(
                            color: colors.text,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
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
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    heroTitle,
                    style: AppTypography.hero.copyWith(
                      color: colors.text,
                      height: 1.15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    heroSubtitle,
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                      fontSize: 17,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  // Feature pills
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _AuthFeaturePill(icon: Icons.verified_user_outlined, label: "Cryptographic Evidence"),
                      _AuthFeaturePill(icon: Icons.psychology_outlined, label: "AI Signal Synthesis"),
                      _AuthFeaturePill(icon: Icons.shield_outlined, label: "Zero-Knowledge Privacy"),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Section 2: Form Container
          Expanded(
            flex: context.isDesktop ? 5 : 5,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.xl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      form,
                      if (bottomAction != null) ...[
                        const SizedBox(height: AppSpacing.xl),
                        bottomAction!,
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthFeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AuthFeaturePill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: colors.cardBackgroundLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppPalette.orange),
          const SizedBox(width: 8),
          Text(
            label,
            style: AppTypography.caption1.copyWith(
              color: colors.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
