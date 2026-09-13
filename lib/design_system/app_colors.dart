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
    );
  }

  static AppThemeColors get light => const AppThemeColors(
        primary: AppPalette.orange,
        primaryDark: AppPalette.orange,
        primaryMuted: Color(0x14F44A22),
        background: AppPalette.silver,                  // #FEF8E8 warm parchment
        surface: Color(0xFFF5F3EE),                     // subtle warm grey
        surfaceElevated: Color(0xFFF5F3EE),             // subtle warm grey
        cardBackground: Color(0xFFFFFFFF),              // white — cards pop against parchment
        cardBackgroundLight: Color(0xFFFAF8F5),         // between parchment and white
        tabBar: Color(0xFFFFFFFF),                      // white tab bar
        text: AppPalette.midnight,
        textSecondary: AppPalette.stone,
        textTertiary: AppPalette.grey,
        textInverted: Color(0xFFFFFFFF),
        divider: Color(0xFFE8E6E1),                     // softer divider
        border: Color(0xFFE8E6E1),                      // softer border
        success: Color(0xFF34C759),                     // real semantic green
        warning: Color(0xFFFF9500),                     // real semantic amber
        destructive: Color(0xFFFF3B30),                 // real semantic red
        info: AppPalette.stone,
        gold: Color(0xFFFFB800),                        // real gold
        evidenceGreen: Color(0xFF34C759),
        confidenceBlue: Color(0xFF007AFF),
        riskRed: Color(0xFFFF3B30),
        neutralGrey: AppPalette.grey,
        glowPrimary: Color(0x33F44A22),
      );

  static AppThemeColors get dark => const AppThemeColors(
        primary: AppPalette.orange,
        primaryDark: AppPalette.orange,
        primaryMuted: Color(0x1FF44A22),
        background: AppPalette.midnight,                // #161616 true dark
        surface: Color(0xFF1A1B1E),                     // slightly elevated
        surfaceElevated: Color(0xFF252629),              // more elevated
        cardBackground: Color(0xFF1E1F24),              // cards distinct from background
        cardBackgroundLight: Color(0xFF1A1B1E),         // subtle elevation
        tabBar: Color(0xFF1E1F24),                      // elevated tab bar
        text: AppPalette.silver,
        textSecondary: AppPalette.stone,
        textTertiary: AppPalette.grey,
        textInverted: AppPalette.midnight,
        divider: Color(0xFF2C2D32),                     // subtle dark divider
        border: Color(0xFF2C2D32),                      // subtle dark border
        success: Color(0xFF30D158),                     // iOS dark green
        warning: Color(0xFFFFD60A),                     // iOS dark amber
        destructive: Color(0xFFFF453A),                 // iOS dark red
        info: AppPalette.stone,
        gold: Color(0xFFFFD60A),                        // iOS dark gold
        evidenceGreen: Color(0xFF30D158),
        confidenceBlue: Color(0xFF0A84FF),
        riskRed: Color(0xFFFF453A),
        neutralGrey: AppPalette.grey,
        glowPrimary: Color(0x33F44A22),
      );
}

extension AppThemeColorsExtension on ThemeData {
  AppThemeColors get appColors => extension<AppThemeColors>() ?? AppThemeColors.light;
}
