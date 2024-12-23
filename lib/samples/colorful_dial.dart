// Generated on: 2024-12-23T21:44:23.750939
// Model: claude-3-sonnet-20240229
// Description: A colorful dial widget that can be rotated by panning on the screen.
// Complexity level: intermediate

import 'dart:math';
import 'package:flutter/material.dart';

class ColorfulDial extends StatefulWidget {
  static final String generatedAt = '2024-12-23T21:44:23.750939';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A colorful dial widget that can be rotated by panning on the screen.';
  static final String complexityLevel = 'intermediate';


  const ColorfulDial({super.key});

  @override
  _ColorfulDialState createState() => _ColorfulDialState();
}

class _ColorfulDialState extends State<ColorfulDial> {
  double _angle = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colorful Dial'),
      ),
      body: Center(
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _angle += details.delta.dx / 100;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Transform.rotate(
              angle: _angle,
              child: const ColorfulDialWidget(),
            ),
          ),
        ),
      ),
    );
  }
}

class ColorfulDialWidget extends StatelessWidget {
  const ColorfulDialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.red,
            Colors.orange,
            Colors.yellow,
            Colors.green,
            Colors.blue,
            Colors.indigo,
            Colors.purple,
          ],
        ),
      ),
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: Transform.rotate(
              angle: pi / 4,
              child: Container(
                width: 100,
                height: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
