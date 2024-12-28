// Generated on: 2024-12-28T00:05:23.903825
// Model: claude-v1
// Description: A sample showcasing color transition animation using AnimatedBuilder
// Complexity level: null

import 'package:flutter/material.dart';

class ColorTransitionSample extends StatefulWidget {
  static final String generatedAt = '2024-12-28T00:05:23.903825';
  static final String model = 'claude-v1';
  static final String description = 'A sample showcasing color transition animation using AnimatedBuilder';
  static final String complexityLevel = 'null';


  const ColorTransitionSample({super.key});

  @override
  State<ColorTransitionSample> createState() => _ColorTransitionSampleState();
}

class _ColorTransitionSampleState extends State<ColorTransitionSample> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _colorAnimation = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}
