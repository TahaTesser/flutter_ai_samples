// Generated on: 2024-12-29T00:06:03.779677
// Model: claude-3-sonnet-20240229
// Description: A live clock widget that updates every second with a smooth animation
// Complexity level: null

import 'dart:async';
import 'package:flutter/material.dart';

class LiveClockSample extends StatefulWidget {
  static final String generatedAt = '2024-12-29T00:06:03.779677';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A live clock widget that updates every second with a smooth animation';
  static final String complexityLevel = 'null';


  const LiveClockSample({super.key});

  @override
  _LiveClockSampleState createState() => _LiveClockSampleState();
}

class _LiveClockSampleState extends State<LiveClockSample> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), _updateTime);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime(Timer timer) {
    setState(() {
      _currentTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Clock Sample'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticOut,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
              child: Text(
                '${_currentTime.hour}:${_currentTime.minute}:${_currentTime.second}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Updated every second!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
