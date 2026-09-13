import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TypographyTokens {
  // Ordinary: Modern bold sans-serif (Product Voice)
  // Placeholder: Inter
  static TextStyle fontPrimary({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.inter(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }

  // Parisian: Elegant editorial serif (Brand/Editorial Voice)
  // Placeholder: Playfair Display
  static TextStyle fontEditorial({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    Color? color,
  }) {
    return GoogleFonts.playfairDisplay(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    );
  }
}

class AppTypography {
  // ---------------------------------------------------------
  // ORDINARY (Functional, Product, 80-90%)
  // ---------------------------------------------------------

  // Display
  static TextStyle get display => TypographyTokens.fontPrimary(fontSize: 48, fontWeight: FontWeight.w900, height: 1.1, letterSpacing: -1.0);
  static TextStyle get displayMedium => TypographyTokens.fontPrimary(fontSize: 40, fontWeight: FontWeight.w800, height: 1.1, letterSpacing: -0.5);

  // Headings
  static TextStyle get h1 => TypographyTokens.fontPrimary(fontSize: 34, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5);
  static TextStyle get h2 => TypographyTokens.fontPrimary(fontSize: 28, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.5);
  static TextStyle get h3 => TypographyTokens.fontPrimary(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3);

  // Titles
  static TextStyle get title1 => TypographyTokens.fontPrimary(fontSize: 22, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get title2 => TypographyTokens.fontPrimary(fontSize: 20, fontWeight: FontWeight.w600, height: 1.3);
  static TextStyle get title3 => TypographyTokens.fontPrimary(fontSize: 18, fontWeight: FontWeight.w600, height: 1.3);

  // Body
  static TextStyle get bodyLarge => TypographyTokens.fontPrimary(fontSize: 18, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get body => TypographyTokens.fontPrimary(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodyMedium => TypographyTokens.fontPrimary(fontSize: 16, fontWeight: FontWeight.w500, height: 1.5);
  
  // Secondary / Supporting
  static TextStyle get subheadline => TypographyTokens.fontPrimary(fontSize: 15, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get callout => TypographyTokens.fontPrimary(fontSize: 14, fontWeight: FontWeight.w500, height: 1.4);
  static TextStyle get footnote => TypographyTokens.fontPrimary(fontSize: 13, fontWeight: FontWeight.w400, height: 1.4);
  static TextStyle get caption => TypographyTokens.fontPrimary(fontSize: 12, fontWeight: FontWeight.w500, height: 1.4);
  static TextStyle get label => TypographyTokens.fontPrimary(fontSize: 11, fontWeight: FontWeight.w600, height: 1.2, letterSpacing: 0.5);
  static TextStyle get labelSmall => TypographyTokens.fontPrimary(fontSize: 10, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: 0.5);

  // Metrics (Data, Numbers)
  static TextStyle get metricLarge => TypographyTokens.fontPrimary(fontSize: 48, fontWeight: FontWeight.w900, height: 1.0, letterSpacing: -1.0);
  static TextStyle get metric => TypographyTokens.fontPrimary(fontSize: 32, fontWeight: FontWeight.w700, height: 1.1, letterSpacing: -0.5);

  // Semantic UI tokens
  static TextStyle get appBarTitle => TypographyTokens.fontPrimary(fontSize: 18, fontWeight: FontWeight.w700, height: 1.3);
  static TextStyle get buttonLabel => TypographyTokens.fontPrimary(fontSize: 15, fontWeight: FontWeight.w600, height: 1.2);

  // ---------------------------------------------------------
  // PARISIAN (Editorial, Brand, Emotional, 10-20%)
  // ---------------------------------------------------------

  static TextStyle get editorialDisplay => TypographyTokens.fontEditorial(fontSize: 56, fontWeight: FontWeight.w600, height: 1.1, letterSpacing: -0.5);
  static TextStyle get editorialHero => TypographyTokens.fontEditorial(fontSize: 42, fontWeight: FontWeight.w500, height: 1.1);
  static TextStyle get editorialHeadline => TypographyTokens.fontEditorial(fontSize: 32, fontWeight: FontWeight.w600, height: 1.2);
  static TextStyle get editorialTitle => TypographyTokens.fontEditorial(fontSize: 24, fontWeight: FontWeight.w500, height: 1.3);
  static TextStyle get editorialQuote => TypographyTokens.fontEditorial(fontSize: 20, fontWeight: FontWeight.w400, height: 1.5, letterSpacing: 0.5);
  
  // Legacy aliases (migration bridges — will be phased out)
  static TextStyle get hero => h1;
  static TextStyle get title4 => bodyLarge;
  static TextStyle get headline => title3;
  static TextStyle get caption1 => caption;
  static TextStyle get caption2 => label;
  static TextStyle get mono => body;
  static TextStyle get monoSmall => caption;
  static TextStyle get brandLogo => title1;
  static TextStyle get brandHero => editorialDisplay;
}

