// Generated on: 2024-12-23T20:43:06.766614
// Model: null
// Description: An animated constellation of stars orbiting around a central point
// Complexity level: null

import 'package:flutter/material.dart';
import 'dart:math';

class ConstellationAnimation extends StatefulWidget {
  static final String generatedAt = '2024-12-23T20:43:06.766614';
  static final String model = 'null';
  static final String description = 'An animated constellation of stars orbiting around a central point';
  static final String complexityLevel = 'null';


  const ConstellationAnimation({super.key});

  @override
  _ConstellationAnimationState createState() => _ConstellationAnimationState();
}

class _ConstellationAnimationState extends State<ConstellationAnimation> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late List<StarPainter> _starPainters;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_animationController);

    _starPainters = List.generate(30, (index) {
      return StarPainter(
        animation: _animation,
        radius: Random().nextDouble() * 50 + 10,
        radiansOffset: Random().nextDouble() * 2 * pi,
        distance: Random().nextDouble() * 200 + 100,
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            children: _starPainters
                .map((painter) => CustomPaint(painter: painter))
                .toList(),
          ),
        ),
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final Animation<double> animation;
  final double radius;
  final double radiansOffset;
  final double distance;

  StarPainter({
    required this.animation,
    required this.radius,
    required this.radiansOffset,
    required this.distance,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radians = animation.value + radiansOffset;

    final double x = centerX + distance * cos(radians);
    final double y = centerY + distance * sin(radians);

    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  @override
  bool shouldRepaint(StarPainter oldDelegate) => true;
}
