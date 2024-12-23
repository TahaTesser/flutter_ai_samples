// Generated on: 2024-12-23T21:36:49.481539
// Model: claude-3-sonnet-20240229
// Description: An animated list tile that expands/collapses to show multi-line content
// Complexity level: null

import 'package:flutter/material.dart';

class AnimatedMultiTileList extends StatefulWidget {
  static final String generatedAt = '2024-12-23T21:36:49.481539';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'An animated list tile that expands/collapses to show multi-line content';
  static final String complexityLevel = 'null';


  const AnimatedMultiTileList({super.key});

  @override
  _AnimatedMultiTileListState createState() => _AnimatedMultiTileListState();
}

class _AnimatedMultiTileListState extends State<AnimatedMultiTileList> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Multi Tile List')),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Title'),
                  onTap: _handleTap,
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  axis: Axis.vertical,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text('This is a multi-line content that expands and collapses.'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
