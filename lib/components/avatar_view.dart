import 'package:flutter/material.dart';
import '../design_system/app_typography.dart';

class AvatarView extends StatelessWidget {
  final String name;
  final String? imageURL; // Not used in SwiftUI yet, keeping for parity
  final double size;

  const AvatarView({
    super.key,
    required this.name,
    this.imageURL,
    this.size = 40.0,
  });

  static const List<List<Color>> _gradients = [
    [Color(0xFFF44A22), Color(0xFFD33A15)], // Orange Primary
    [Color(0xFF262626), Color(0xFF161616)], // Midnight Dark
    [Color(0xFF3D3E40), Color(0xFF222324)], // Deep Stone
    [Color(0xFFF44A22), Color(0xFFE03B13)], // Orange Bright
    [Color(0xFF2E2E2E), Color(0xFF1A1A1A)], // Midnight Charcoal
  ];

  List<Color> get _gradient {
    int hash = name.hashCode.abs();
    return _gradients[hash % _gradients.length];
  }

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    final first = parts.isNotEmpty ? parts.first : "";
    final last = parts.length > 1 ? parts.last : "";

    String initial1 = first.isNotEmpty ? first[0] : "";
    String initial2 = last.isNotEmpty ? last[0] : "";
    
    return "$initial1$initial2".toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: _gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFFE4E2E3).withOpacity(0.15),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        _initials.isEmpty ? "?" : _initials,
        style: TypographyTokens.fontPrimary(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFFEF8E8),
        ),
      ),
    );
  }
}
