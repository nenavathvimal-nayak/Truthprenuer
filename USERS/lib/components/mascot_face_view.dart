import 'package:flutter/material.dart';

enum MascotEmotion {
  happy,
  neutral,
  sad,
  motivated,
}

class MascotFaceView extends StatelessWidget {
  final MascotEmotion emotion;
  final double size;

  const MascotFaceView({
    super.key,
    required this.emotion,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Eyes
          Positioned(
            top: size * 0.5 - (size * 0.1), // center offset by -size*0.1
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _EyeView(isLeft: true, emotion: emotion, size: size),
                SizedBox(width: size * 0.15),
                _EyeView(isLeft: false, emotion: emotion, size: size),
              ],
            ),
          ),

          // Cheeks (Only for happy/motivated)
          if (emotion == MascotEmotion.happy || emotion == MascotEmotion.motivated)
            Positioned(
              top: size * 0.5 + (size * 0.05), // offset y: size * 0.05
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.rotate(
                    angle: -10 * 3.14159 / 180,
                    child: Container(
                      width: size * 0.15,
                      height: size * 0.08,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B4A),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.elliptical(100, 50)), // approximate ellipse
                      ),
                    ),
                  ),
                  SizedBox(width: size * 0.5 - (size * 0.15)), // Equivalent to HStack spacing size * 0.5 minus width
                  Transform.rotate(
                    angle: 10 * 3.14159 / 180,
                    child: Container(
                      width: size * 0.15,
                      height: size * 0.08,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B4A),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.elliptical(100, 50)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
          // Mouth
          Positioned(
            top: size * 0.5 + (size * 0.2), // offset y: size * 0.2
            child: _MouthView(emotion: emotion, size: size),
          ),
        ],
      ),
    );
  }
}

class _EyeView extends StatelessWidget {
  final bool isLeft;
  final MascotEmotion emotion;
  final double size;

  const _EyeView({
    required this.isLeft,
    required this.emotion,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: size * 0.25,
      height: size * 0.35,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Sclera (White part)
          Transform.rotate(
            angle: emotion == MascotEmotion.sad ? (isLeft ? -10 * 3.14159 / 180 : 10 * 3.14159 / 180) : 0,
            child: Container(
              width: size * 0.25,
              height: size * 0.35,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.elliptical(100, 150)),
              ),
            ),
          ),

          // Pupil
          Positioned(
            left: (size * 0.25 - size * 0.15) / 2 + (emotion == MascotEmotion.sad ? (isLeft ? 5 : -5) : (isLeft ? 8 : -8)),
            top: (size * 0.35 - size * 0.22) / 2 + (emotion == MascotEmotion.sad ? 10 : 5),
            child: Container(
              width: size * 0.15,
              height: size * 0.22,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.elliptical(100, 150)),
              ),
            ),
          ),

          // Catchlight
          Positioned(
            left: (size * 0.25 - size * 0.05) / 2 + (emotion == MascotEmotion.sad ? (isLeft ? 2 : -8) : (isLeft ? 4 : -12)),
            top: (size * 0.35 - size * 0.05) / 2 + (emotion == MascotEmotion.sad ? 5 : 0),
            child: Container(
              width: size * 0.05,
              height: size * 0.05,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Eyelashes
          if (emotion == MascotEmotion.happy || emotion == MascotEmotion.motivated)
            Positioned(
              top: -size * 0.2 + (size * 0.35 / 2), 
              child: SizedBox(
                width: 30,
                height: 10,
                child: CustomPaint(
                  painter: _EyelashPainter(),
                ),
              ),
            ),
            
          // Eyebrow (Sad)
          if (emotion == MascotEmotion.sad)
            Positioned(
              top: -size * 0.25 + (size * 0.35 / 2),
              child: Transform.rotate(
                angle: (isLeft ? -15 : 15) * 3.14159 / 180,
                child: SizedBox(
                  width: 30,
                  height: 10,
                  child: CustomPaint(
                    painter: _SadEyebrowPainter(color: isDark ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MouthView extends StatelessWidget {
  final MascotEmotion emotion;
  final double size;

  const _MouthView({
    required this.emotion,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (emotion == MascotEmotion.happy || emotion == MascotEmotion.motivated) {
      return SizedBox(
        width: size * 0.2,
        height: size * 0.1,
        child: CustomPaint(
          painter: _SmilePainter(),
        ),
      );
    } else if (emotion == MascotEmotion.sad) {
      return SizedBox(
        width: size * 0.2,
        height: size * 0.1,
        child: CustomPaint(
          painter: _SadMouthPainter(color: isDark ? Colors.white : Colors.black),
        ),
      );
    } else {
      // Neutral
      return Container(
        width: size * 0.15,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(2), // Capsule
        ),
      );
    }
  }
}

class _EyelashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(-5, -10);
    path.moveTo(10, -2);
    path.lineTo(10, -12);
    path.moveTo(20, 0);
    path.lineTo(25, -10);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SadEyebrowPainter extends CustomPainter {
  final Color color;
  _SadEyebrowPainter({required this.color});
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    final path = Path();
    path.moveTo(0, 10);
    path.quadraticBezierTo(15, -5, 30, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmilePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width * 0.5, size.height, size.width, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SadMouthPainter extends CustomPainter {
  final Color color;
  _SadMouthPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    
    final path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 0.5, 0, size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
