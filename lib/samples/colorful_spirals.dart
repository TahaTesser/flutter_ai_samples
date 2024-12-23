// Generated on: 2023-05-10
// Model: claude-3-sonnet-20240229
// Description: A colorful animated spiral pattern made with CustomPaint and AnimatedBuilder
// Complexity level: intermediate

import 'dart:math';
import 'package:flutter/material.dart';

class ColorfulSpirals extends StatefulWidget {
  static final String generatedAt = '2023-05-10';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A colorful animated spiral pattern made with CustomPaint and AnimatedBuilder';
  static final String complexityLevel = 'intermediate';


  @override
  _ColorfulSpiralsState createState() => _ColorfulSpiralsState();
}

class _ColorfulSpiralsState extends State<ColorfulSpirals> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_animationController);
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
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: SpiralPainter(_animation.value),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class SpiralPainter extends CustomPainter {
  final double value;
  final Random _random = Random();

  SpiralPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    for (int i = 0; i < 100; i++) {
      final radius = i * 10.0;
      final theta = value + i * 0.1;
      final x = center.dx + radius * cos(theta);
      final y = center.dy + radius * sin(theta);
      paint.color = Color.fromARGB(
        255,
        _random.nextInt(256),
        _random.nextInt(256),
        _random.nextInt(256),
      );
      canvas.drawCircle(Offset(x, y), 5.0, paint);
    }
  }

  @override
  bool shouldRepaint(SpiralPainter oldDelegate) {
    return value != oldDelegate.value;
  }
}
