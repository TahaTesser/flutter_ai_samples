// Generated on: 2024-12-23T23:00:53.302425
// Model: claude-v1.3
// Description: An expandable card with animation
// Complexity level: null

import 'package:flutter/material.dart';

class ExpandableCardSample extends StatefulWidget {
  static final String generatedAt = '2024-12-23T23:00:53.302425';
  static final String model = 'claude-v1.3';
  static final String description = 'An expandable card with animation';
  static final String complexityLevel = 'null';


  const ExpandableCardSample({super.key});

  @override
  State<ExpandableCardSample> createState() => _ExpandableCardSampleState();
}

class _ExpandableCardSampleState extends State<ExpandableCardSample> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          height: _isExpanded ? 300 : 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expandable Card',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: ConstrainedBox(
                  constraints: _isExpanded
                      ? const BoxConstraints(maxHeight: double.infinity)
                      : const BoxConstraints(maxHeight: 120),
                  child: const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec hendrerit nulla eget eros cursus, id auctor elit molestie. Suspendisse potenti. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
