// Generated on: 2024-12-23T21:54:02.825690
// Model: claude-3-sonnet-20240229
// Description: A simple full-screen widget that generates a random color when tapped
// Complexity level: beginner

import 'dart:math';
import 'package:flutter/material.dart';

class ColorShifter extends StatefulWidget {
  static final String generatedAt = '2024-12-23T21:54:02.825690';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A simple full-screen widget that generates a random color when tapped';
  static final String complexityLevel = 'beginner';


  const ColorShifter({super.key});

  @override
  State<ColorShifter> createState() => _ColorShifterState();
}

class _ColorShifterState extends State<ColorShifter> {
  Color _currentColor = Colors.white;

  void _changeColor() {
    setState(() {
      _currentColor = Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeColor,
      child: Container(
        color: _currentColor,
        child: const Center(
          child: Text(
            'Tap to Change Color',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}