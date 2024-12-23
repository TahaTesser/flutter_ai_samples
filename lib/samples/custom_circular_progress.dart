// Generated on: 2023-05-17
// Model: claude-3-sonnet-20240229
// Description: A custom circular progress indicator with animation
// Complexity level: intermediate

import 'dart:math';
import 'package:flutter/material.dart';

class CustomCircularProgress extends StatefulWidget {
  static final String generatedAt = '2023-05-17';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A custom circular progress indicator with animation';
  static final String complexityLevel = 'intermediate';


  final double value;

  const CustomCircularProgress({Key? key, required this.value}) : super(key: key);

  @override
  _CustomCircularProgressState createState() => _CustomCircularProgressState();
}

class _CustomCircularProgressState extends State<CustomCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: _CircularProgressPainter(
                value: widget.value,
                animation: _animation.value,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double value;
  final double animation;

  _CircularProgressPainter({required this.value, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final progressPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 10;

    canvas.drawCircle(center, radius, circlePaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      value * 2 * pi + animation,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return value != oldDelegate.value || animation != oldDelegate.animation;
  }
}
