// Generated on: 2024-12-30T00:05:24.248565
// Model: claude-3-sonnet-20240229
// Description: An expanding wave animation with a circular border
// Complexity level: intermediate

import 'package:flutter/material.dart';

class ExpandingWaveAnimation extends StatefulWidget {
  static final String generatedAt = '2024-12-30T00:05:24.248565';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'An expanding wave animation with a circular border';
  static final String complexityLevel = 'intermediate';


  const ExpandingWaveAnimation({super.key});

  @override
  _ExpandingWaveAnimationState createState() => _ExpandingWaveAnimationState();
}

class _ExpandingWaveAnimationState extends State<ExpandingWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue,
              width: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}
