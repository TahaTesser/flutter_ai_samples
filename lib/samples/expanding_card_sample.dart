// Generated on: 2024-12-27T00:05:19.948169
// Model: claude-3-sonnet-20240229
// Description: An expandable card with animation and interactive button.
// Complexity level: intermediate

import 'package:flutter/material.dart';

class ExpandingCardSample extends StatefulWidget {
  static final String generatedAt = '2024-12-27T00:05:19.948169';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'An expandable card with animation and interactive button.';
  static final String complexityLevel = 'intermediate';


  const ExpandingCardSample({super.key});

  @override
  State<ExpandingCardSample> createState() => _ExpandingCardSampleState();
}

class _ExpandingCardSampleState extends State<ExpandingCardSample> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedSize(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  _isExpanded ? _controller.forward() : _controller.reverse();
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Expanding Card'),
                    Icon(Icons.expand_more),
                  ],
                ),
              ),
            ),
            SizeTransition(
              axisAlignment: -1.0,
              sizeFactor: _animation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(_isExpanded
                    ? 'This is an expanded card with additional content.'
                    : ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
