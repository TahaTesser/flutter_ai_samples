// Generated on: 2024-12-23T22:06:25.126215
// Model: claude-v1
// Description: A simple Flutter widget that generates a random color when tapped.
// Complexity level: beginner

import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorBox extends StatefulWidget {
  static final String generatedAt = '2024-12-23T22:06:25.126215';
  static final String model = 'claude-v1';
  static final String description = 'A simple Flutter widget that generates a random color when tapped.';
  static final String complexityLevel = 'beginner';


  const RandomColorBox({super.key});

  @override
  State<RandomColorBox> createState() => _RandomColorBoxState();
}

class _RandomColorBoxState extends State<RandomColorBox> {
  Color _randomColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _randomColor = Color.fromRGBO(
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
              1.0,
            );
          });
        },
        child: Container(
          width: 300,
          height: 300,
          color: _randomColor,
        ),
      ),
    );
  }
}