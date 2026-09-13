import 'package:flutter/material.dart';

enum BrandLogoVariant {
  full,
  mark,
  horizontal,
}

class BrandLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final bool? isDark;
  final BorderRadius? borderRadius;
  final BrandLogoVariant variant;
  final bool asEmblem;
  final bool useTransparent;

  const BrandLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.isDark,
    this.borderRadius,
    this.useTransparent = true,
  })  : variant = BrandLogoVariant.full,
        asEmblem = false;

  const BrandLogo.mark({
    super.key,
    double size = 48,
    this.fit = BoxFit.contain,
    this.isDark,
    this.borderRadius,
    this.asEmblem = false,
    this.useTransparent = true,
  })  : width = size,
        height = size,
        variant = BrandLogoVariant.mark;

  const BrandLogo.horizontal({
    super.key,
    this.height = 32,
    this.isDark,
    this.borderRadius,
  })  : width = null,
        fit = BoxFit.contain,
        asEmblem = false,
        useTransparent = true,
        variant = BrandLogoVariant.horizontal;

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = isDark ?? (Theme.of(context).brightness == Brightness.dark);

    if (variant == BrandLogoVariant.horizontal) {
      final markSize = (height ?? 32) * 0.9;
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BrandLogo.mark(
            size: markSize,
            isDark: effectiveIsDark,
            useTransparent: useTransparent,
          ),
          const SizedBox(width: 8),
          Text(
            "TRUTHPRENUER",
            style: TextStyle(
              fontSize: (height ?? 32) * 0.52,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: effectiveIsDark ? const Color(0xFFFEF8E8) : const Color(0xFF161616),
            ),
          ),
        ],
      );
    }

    final String assetPath;
    if (variant == BrandLogoVariant.mark) {
      assetPath = useTransparent
          ? 'assets/logos/truthprenuer_mark_transparent.png'
          : (effectiveIsDark
              ? 'assets/logos/truthprenuer_mark_dark.png'
              : 'assets/logos/truthprenuer_mark_light.png');
    } else {
      assetPath = useTransparent
          ? (effectiveIsDark
              ? 'assets/logos/truthprenuer_logo_dark_transparent.png'
              : 'assets/logos/truthprenuer_logo_light_transparent.png')
          : (effectiveIsDark
              ? 'assets/logos/truthprenuer_logo_dark.png'
              : 'assets/logos/truthprenuer_logo_light.png');
    }

    Widget image = Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFFF44A22),
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            "T",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        );
      },
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    if (asEmblem) {
      final boxSize = width ?? 48;
      return Container(
        width: boxSize,
        height: height ?? boxSize,
        padding: EdgeInsets.all(boxSize * 0.15),
        decoration: BoxDecoration(
          color: effectiveIsDark
              ? const Color(0xFF1C1D22).withAlpha(220)
              : const Color(0xFFFFFFFF).withAlpha(240),
          borderRadius: borderRadius ?? BorderRadius.circular(boxSize * 0.28),
          border: Border.all(
            color: const Color(0xFFF44A22).withAlpha(60),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF44A22).withAlpha(30),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: image,
      );
    }

    return image;
  }
}
