// Generated on: 2024-12-23T22:13:48.551328
// Model: claude-v1
// Description: An animated waveform visualizer widget with a scrolling wave effect.
// Complexity level: null

import 'package:flutter/material.dart';
import 'dart:math';

class WaveformVisualizer extends StatefulWidget {
  static final String generatedAt = '2024-12-23T22:13:48.551328';
  static final String model = 'claude-v1';
  static final String description = 'An animated waveform visualizer widget with a scrolling wave effect.';
  static final String complexityLevel = 'null';


  const WaveformVisualizer({super.key});

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _amplitudes = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    for (int i = 0; i < 100; i++) {
      _amplitudes.add(Random().nextDouble() * 2 - 1);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waveform Visualizer'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: const Size(300, 150),
              painter: WaveformPainter(
                controller: _controller,
                amplitudes: _amplitudes,
              ),
            );
          },
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final AnimationController controller;
  final List<double> amplitudes;

  WaveformPainter({required this.controller, required this.amplitudes});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    final value = controller.value * amplitudes.length;
    final centerY = size.height / 2;
    final spacing = size.width / amplitudes.length;

    for (int i = 0; i < amplitudes.length; i++) {
      final x = spacing * i;
      final amplitude = amplitudes[(i + value.floor()) % amplitudes.length];
      final y = centerY - (amplitude * centerY);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
