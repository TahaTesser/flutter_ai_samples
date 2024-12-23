// Generated on: 2023-05-25
// Model: claude-3-sonnet-20240229
// Description: A creative drawing canvas that allows users to draw freehand with random colors.
// Complexity level: intermediate

import 'package:flutter/material.dart';
import 'dart:math';

class CreativeCanvas extends StatefulWidget {
  final String generatedAt = '2023-05-25';
  final String model = 'claude-3-sonnet-20240229';
  final String description = 'A creative drawing canvas that allows users to draw freehand with random colors.';
  final String complexityLevel = 'intermediate';

  @override
  _CreativeCanvasState createState() => _CreativeCanvasState();
}

class _CreativeCanvasState extends State<CreativeCanvas> {
  final List<Offset> _points = [];
  final randomGenerator = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Creative Canvas'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _points.add(details.localPosition);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _points.clear();
          });
        },
        child: CustomPaint(
          painter: CanvasPainter(_points, randomGenerator),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class CanvasPainter extends CustomPainter {
  final List<Offset> points;
  final Random randomGenerator;

  CanvasPainter(this.points, this.randomGenerator);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.primaries[randomGenerator.nextInt(Colors.primaries.length)]
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(CanvasPainter oldDelegate) => true;
}
