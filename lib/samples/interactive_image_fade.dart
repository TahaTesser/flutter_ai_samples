// Generated on: 2024-12-24T00:05:30.936747
// Model: claude-v1.3
// Description: An interactive and animated image widget that fades on mouse hover
// Complexity level: intermediate

import 'package:flutter/material.dart';

class InteractiveImageFade extends StatefulWidget {
  static final String generatedAt = '2024-12-24T00:05:30.936747';
  static final String model = 'claude-v1.3';
  static final String description = 'An interactive and animated image widget that fades on mouse hover';
  static final String complexityLevel = 'intermediate';


  const InteractiveImageFade({super.key});

  @override
  State<InteractiveImageFade> createState() => _InteractiveImageFadeState();
}

class _InteractiveImageFadeState extends State<InteractiveImageFade>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.5).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Image Fade'),
      ),
      body: MouseRegion(
        onEnter: (_) {
          setState(() {
            _isHovered = true;
            _controller.forward();
          });
        },
        onExit: (_) {
          setState(() {
            _isHovered = false;
            _controller.reverse();
          });
        },
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Opacity(
              opacity: _animation.value,
              child: Image.network(
                'https://picsum.photos/400/300',
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
