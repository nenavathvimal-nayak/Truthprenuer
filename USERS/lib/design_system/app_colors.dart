import 'package:flutter/material.dart';

class AppPalette {
  static const Color orange = Color(0xFFF44A22);
  static const Color midnight = Color(0xFF161616);
  static const Color silver = Color(0xFFFEF8E8);
  static const Color grey = Color(0xFFE4E2E3);
  static const Color stone = Color(0xFFA8AAAC);
}

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color primary;
  final Color primaryDark;
  final Color primaryMuted;

  final Color background;
  final Color surface;
  final Color surfaceElevated;
  final Color cardBackground;
  final Color cardBackgroundLight;
  final Color tabBar;

  final Color text;
  final Color textSecondary;
  final Color textTertiary;
  final Color textInverted;

  final Color divider;
  final Color border;

  final Color success;
  final Color warning;
  final Color destructive;
  final Color info;
  final Color gold;

  final Color evidenceGreen;
  final Color confidenceBlue;
  final Color riskRed;
  final Color neutralGrey;

  final Color glowPrimary;

  // Accessibility & Interactive State Tokens
  final Color focusRing;
  final Color errorSurface;
  final Color errorBorder;
  final Color interactiveHover;
  final Color interactivePressed;
  final Color skeletonBase;
  final Color skeletonHighlight;

  Color get error => destructive;

  const AppThemeColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryMuted,
    required this.background,
    required this.surface,
    required this.surfaceElevated,
    required this.cardBackground,
    required this.cardBackgroundLight,
    required this.tabBar,
    required this.text,
    required this.textSecondary,
    required this.textTertiary,
    required this.textInverted,
    required this.divider,
    required this.border,
    required this.success,
    required this.warning,
    required this.destructive,
    required this.info,
    required this.gold,
    required this.evidenceGreen,
    required this.confidenceBlue,
    required this.riskRed,
    required this.neutralGrey,
    required this.glowPrimary,
    this.focusRing = AppPalette.orange,
    this.errorSurface = const Color(0xFFFFF0EF),
    this.errorBorder = const Color(0xFFFFB3AD),
    this.interactiveHover = const Color(0x0A000000),
    this.interactivePressed = const Color(0x18000000),
    this.skeletonBase = const Color(0xFFEAE7DF),
    this.skeletonHighlight = const Color(0xFFF7F5EE),
  });

  @override
  ThemeExtension<AppThemeColors> copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryMuted,
    Color? background,
    Color? surface,
    Color? surfaceElevated,
    Color? cardBackground,
    Color? cardBackgroundLight,
    Color? tabBar,
    Color? text,
    Color? textSecondary,
    Color? textTertiary,
    Color? textInverted,
    Color? divider,
    Color? border,
    Color? success,
    Color? warning,
    Color? destructive,
    Color? info,
    Color? gold,
    Color? evidenceGreen,
    Color? confidenceBlue,
    Color? riskRed,
    Color? neutralGrey,
    Color? glowPrimary,
    Color? focusRing,
    Color? errorSurface,
    Color? errorBorder,
    Color? interactiveHover,
    Color? interactivePressed,
    Color? skeletonBase,
    Color? skeletonHighlight,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryMuted: primaryMuted ?? this.primaryMuted,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      cardBackground: cardBackground ?? this.cardBackground,
      cardBackgroundLight: cardBackgroundLight ?? this.cardBackgroundLight,
      tabBar: tabBar ?? this.tabBar,
      text: text ?? this.text,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textInverted: textInverted ?? this.textInverted,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      destructive: destructive ?? this.destructive,
      info: info ?? this.info,
      gold: gold ?? this.gold,
      evidenceGreen: evidenceGreen ?? this.evidenceGreen,
      confidenceBlue: confidenceBlue ?? this.confidenceBlue,
      riskRed: riskRed ?? this.riskRed,
      neutralGrey: neutralGrey ?? this.neutralGrey,
      glowPrimary: glowPrimary ?? this.glowPrimary,
      focusRing: focusRing ?? this.focusRing,
      errorSurface: errorSurface ?? this.errorSurface,
      errorBorder: errorBorder ?? this.errorBorder,
      interactiveHover: interactiveHover ?? this.interactiveHover,
      interactivePressed: interactivePressed ?? this.interactivePressed,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    );
  }

  @override
  ThemeExtension<AppThemeColors> lerp(
    covariant ThemeExtension<AppThemeColors>? other,
    double t,
  ) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryMuted: Color.lerp(primaryMuted, other.primaryMuted, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardBackgroundLight: Color.lerp(cardBackgroundLight, other.cardBackgroundLight, t)!,
      tabBar: Color.lerp(tabBar, other.tabBar, t)!,
      text: Color.lerp(text, other.text, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textInverted: Color.lerp(textInverted, other.textInverted, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      destructive: Color.lerp(destructive, other.destructive, t)!,
      info: Color.lerp(info, other.info, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      evidenceGreen: Color.lerp(evidenceGreen, other.evidenceGreen, t)!,
      confidenceBlue: Color.lerp(confidenceBlue, other.confidenceBlue, t)!,
      riskRed: Color.lerp(riskRed, other.riskRed, t)!,
      neutralGrey: Color.lerp(neutralGrey, other.neutralGrey, t)!,
      glowPrimary: Color.lerp(glowPrimary, other.glowPrimary, t)!,
      focusRing: Color.lerp(focusRing, other.focusRing, t)!,
      errorSurface: Color.lerp(errorSurface, other.errorSurface, t)!,
      errorBorder: Color.lerp(errorBorder, other.errorBorder, t)!,
      interactiveHover: Color.lerp(interactiveHover, other.interactiveHover, t)!,
      interactivePressed: Color.lerp(interactivePressed, other.interactivePressed, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      skeletonHighlight: Color.lerp(skeletonHighlight, other.skeletonHighlight, t)!,
    );
  }

  static AppThemeColors get light => const AppThemeColors(
        primary: AppPalette.orange,
        primaryDark: Color(0xFFD63B15),
        primaryMuted: Color(0x14F44A22),
        background: AppPalette.silver,                  // #FEF8E8 warm parchment
        surface: Color(0xFFF5F3EE),                     // subtle warm grey
        surfaceElevated: Color(0xFFFFFFFF),             // elevated cards pop
        cardBackground: Color(0xFFFFFFFF),              // crisp white cards
        cardBackgroundLight: Color(0xFFFAF8F5),         // between parchment and white
        tabBar: Color(0xFFFFFFFF),                      // white tab bar
        text: AppPalette.midnight,                      // #161616 high contrast
        textSecondary: Color(0xFF5A5D62),               // WCAG AA compliant (5.5:1 on parchment)
        textTertiary: Color(0xFF767A82),                // Legible subtle captions (3.8:1)
        textInverted: Color(0xFFFFFFFF),
        divider: Color(0xFFE8E5DD),                     // gentle warm divider
        border: Color(0xFFE2DFD6),                      // gentle warm border
        success: Color(0xFF248A3D),                     // WCAG compliant green
        warning: Color(0xFFB25E00),                     // WCAG compliant amber
        destructive: Color(0xFFD92D20),                 // WCAG compliant red
        info: Color(0xFF0066CC),                        // Accessible blue
        gold: Color(0xFFB8860B),                        // Dark goldenrod
        evidenceGreen: Color(0xFF248A3D),
        confidenceBlue: Color(0xFF0066CC),
        riskRed: Color(0xFFD92D20),
        neutralGrey: Color(0xFF767A82),
        glowPrimary: Color(0x33F44A22),
        focusRing: AppPalette.orange,
        errorSurface: Color(0xFFFFF0EF),
        errorBorder: Color(0xFFFFB3AD),
        interactiveHover: Color(0x0A000000),
        interactivePressed: Color(0x14000000),
        skeletonBase: Color(0xFFEAE7DF),
        skeletonHighlight: Color(0xFFF7F5EE),
      );

  static AppThemeColors get dark => const AppThemeColors(
        primary: AppPalette.orange,
        primaryDark: Color(0xFFFF6A42),
        primaryMuted: Color(0x26F44A22),
        background: AppPalette.midnight,                // #161616 true dark
        surface: Color(0xFF1E1F24),                     // elevated surface
        surfaceElevated: Color(0xFF282A30),              // more elevated
        cardBackground: Color(0xFF1E1F24),              // cards distinct from background
        cardBackgroundLight: Color(0xFF24262C),         // subtle elevation
        tabBar: Color(0xFF1E1F24),                      // elevated tab bar
        text: Color(0xFFF5F3ED),                        // soft high contrast text
        textSecondary: Color(0xFFA6ABB2),               // WCAG AA compliant on dark
        textTertiary: Color(0xFF7C828A),                // subtle captions on dark
        textInverted: AppPalette.midnight,
        divider: Color(0xFF2C2D32),                     // subtle dark divider
        border: Color(0xFF33353C),                      // subtle dark border
        success: Color(0xFF30D158),                     // iOS dark green
        warning: Color(0xFFFFD60A),                     // iOS dark amber
        destructive: Color(0xFFFF453A),                 // iOS dark red
        info: Color(0xFF5AC8FA),                        // Accessible cyan-blue
        gold: Color(0xFFFFD60A),                        // iOS dark gold
        evidenceGreen: Color(0xFF30D158),
        confidenceBlue: Color(0xFF0A84FF),
        riskRed: Color(0xFFFF453A),
        neutralGrey: Color(0xFF7C828A),
        glowPrimary: Color(0x33F44A22),
        focusRing: Color(0xFFFF6A42),
        errorSurface: Color(0xFF2E1917),
        errorBorder: Color(0xFF6B221E),
        interactiveHover: Color(0x0AFFFFFF),
        interactivePressed: Color(0x18FFFFFF),
        skeletonBase: Color(0xFF22242A),
        skeletonHighlight: Color(0xFF2C2E35),
      );
}

extension AppThemeColorsExtension on ThemeData {
  AppThemeColors get appColors => extension<AppThemeColors>() ?? AppThemeColors.light;
}
