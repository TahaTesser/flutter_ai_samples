// Generated on: 2024-12-23T20:50:23.125053
// Model: null
// Description: An animated spinning donut widget
// Complexity level: intermediate

import 'dart:math';
import 'package:flutter/material.dart';

class SpinningDonutWidget extends StatefulWidget {
  static final String generatedAt = '2024-12-23T20:50:23.125053';
  static final String model = 'null';
  static final String description = 'An animated spinning donut widget';
  static final String complexityLevel = 'intermediate';


  const SpinningDonutWidget({super.key});

  @override
  _SpinningDonutWidgetState createState() => _SpinningDonutWidgetState();
}

class _SpinningDonutWidgetState extends State<SpinningDonutWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * pi,
              child: child,
            );
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
