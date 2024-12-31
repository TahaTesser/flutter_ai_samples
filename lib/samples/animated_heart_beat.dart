// Generated on: 2024-12-31
// Model: claude-3-sonnet-20240229
// Description: An animated heart icon that beats on tap
// Complexity level: intermediate

import 'package:flutter/material.dart';

class AnimatedHeartBeat extends StatefulWidget {
  static final String generatedAt = '2024-12-31';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'An animated heart icon that beats on tap';
  static final String complexityLevel = 'intermediate';


  const AnimatedHeartBeat({super.key});

  @override
  State<AnimatedHeartBeat> createState() => _AnimatedHeartBeatState();
}

class _AnimatedHeartBeatState extends State<AnimatedHeartBeat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
        child: GestureDetector(
          onTap: () {
            _controller.reset();
            _controller.forward();
          },
          child: Icon(
            Icons.favorite,
            color: Colors.red,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
