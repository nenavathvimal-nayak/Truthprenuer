import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../design_system/app_colors.dart';
import '../design_system/app_spacing.dart';
import '../design_system/app_typography.dart';

class StreakData {
  final String id;
  final String day;
  final double value;
  final bool isToday;

  StreakData({
    String? id,
    required this.day,
    required this.value,
    required this.isToday,
  }) : id = id ?? const Uuid().v4();
}

class CustomBarChart extends StatelessWidget {
  final List<StreakData> data;
  final double maxValue;

  const CustomBarChart({
    super.key,
    required this.data,
    this.maxValue = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).appColors;
    
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: data.map((item) {
          final barHeight = 24.0 > (item.value / maxValue) * 100 
              ? 24.0 
              : (item.value / maxValue) * 100;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm), // Spacing.md equivalent half on each side? Wait, Spacing.md between items.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Face + Bar Container
                SizedBox(
                  height: barHeight + 12, // +12 for face offset
                  child: Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // The Bar
                      Positioned(
                        bottom: 0,
                        child: Container(
                          width: 24,
                          height: barHeight,
                          decoration: BoxDecoration(
                            color: item.isToday ? colors.cardBackgroundLight : colors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      
                      // Face on top of the bar
                      Positioned(
                        top: 0, // offset
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: item.isToday ? colors.cardBackgroundLight : colors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 14, // Roughly 
                              height: 10,
                              child: CustomPaint(
                                painter: _SmileyFacePainter(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppSpacing.xs),
                
                // Day Label
                Text(
                  item.day,
                  style: AppTypography.caption.copyWith(color: colors.textSecondary),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SmileyFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    
    // Eyes
    // HStack spacing 4, circles width 3
    const eyeRadius = 1.5;
    canvas.drawCircle(Offset(size.width / 2 - 3.5, size.height * 0.3), eyeRadius, paint);
    canvas.drawCircle(Offset(size.width / 2 + 3.5, size.height * 0.3), eyeRadius, paint);
    
    // Smile
    final smilePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    final path = Path();
    path.moveTo(size.width / 2 - 4, size.height * 0.7);
    path.quadraticBezierTo(
      size.width / 2, size.height * 1.1, // control point
      size.width / 2 + 4, size.height * 0.7,
    );
    canvas.drawPath(path, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
