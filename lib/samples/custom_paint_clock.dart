// Generated on: 2024-12-23
// Model: claude-v1.3
// Description: A custom analog clock widget with hour, minute, and second hands painted on a canvas.
// Complexity level: intermediate

import 'dart:math';
import 'package:flutter/material.dart';

class CustomPaintClock extends StatefulWidget {
  static final String generatedAt = '2024-12-23';
  static final String model = 'claude-v1.3';
  static final String description = 'A custom analog clock widget with hour, minute, and second hands painted on a canvas.';
  static final String complexityLevel = 'intermediate';


  const CustomPaintClock({super.key});

  @override
  State<CustomPaintClock> createState() => _CustomPaintClockState();
}

class _CustomPaintClockState extends State<CustomPaintClock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(
            painter: ClockPainter(),
          ),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final hourHandStyle = Paint()
    ..strokeWidth = 8
    ..color = Colors.white;

  final minuteHandStyle = Paint()
    ..strokeWidth = 4
    ..color = Colors.white70;

  final secondHandStyle = Paint()
    ..strokeWidth = 2
    ..color = Colors.redAccent;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2) - 20;
    final hourHandLength = radius * 0.5;
    final minuteHandLength = radius * 0.7;
    final secondHandLength = radius * 0.8;

    canvas.save();

    // Draw clock face
    canvas.drawCircle(center, radius, Paint()..color = Colors.white24);

    // Draw hour markers
    final hourMarkerPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;
    for (var i = 0; i < 12; i++) {
      final x1 = center.dx + radius * cos(i * 30 * pi / 180);
      final y1 = center.dy + radius * sin(i * 30 * pi / 180);
      final x2 = center.dx + (radius - 12) * cos(i * 30 * pi / 180);
      final y2 = center.dy + (radius - 12) * sin(i * 30 * pi / 180);
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), hourMarkerPaint);
    }

    // Get current time
    final now = DateTime.now();
    final hours = now.hour % 12;
    final minutes = now.minute;
    final seconds = now.second;

    // Calculate hand angles
    final hourAngle = (hours * 30 + minutes * 0.5) * pi / 180;
    final minuteAngle = (minutes * 6) * pi / 180;
    final secondAngle = (seconds * 6) * pi / 180;

    // Draw hour hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + hourHandLength * cos(hourAngle),
        center.dy + hourHandLength * sin(hourAngle),
      ),
      hourHandStyle,
    );

    // Draw minute hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + minuteHandLength * cos(minuteAngle),
        center.dy + minuteHandLength * sin(minuteAngle),
      ),
      minuteHandStyle,
    );

    // Draw second hand
    canvas.drawLine(
      center,
      Offset(
        center.dx + secondHandLength * cos(secondAngle),
        center.dy + secondHandLength * sin(secondAngle),
      ),
      secondHandStyle,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}