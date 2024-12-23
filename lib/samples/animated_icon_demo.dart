// Generated on: 2024-12-23T21:03:06.467245
// Model: claude-3-sonnet-20240229
// Description: A demo showcasing the AnimatedIcon widget and its interactive animation capabilities.
// Complexity level: intermediate

import 'package:flutter/material.dart';

class AnimatedIconDemo extends StatefulWidget {
  static final String generatedAt = '2024-12-23T21:03:06.467245';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A demo showcasing the AnimatedIcon widget and its interactive animation capabilities.';
  static final String complexityLevel = 'intermediate';


  const AnimatedIconDemo({super.key});

  @override
  _AnimatedIconDemoState createState() => _AnimatedIconDemoState();
}

class _AnimatedIconDemoState extends State<AnimatedIconDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Icon Demo'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (_isAnimated) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            _isAnimated = !_isAnimated;
          },
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _animationController,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
