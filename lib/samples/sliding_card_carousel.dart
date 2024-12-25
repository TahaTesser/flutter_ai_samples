// Generated on: 2024-12-25T00:05:19.547356
// Model: null
// Description: A sliding card carousel with interactive pagination via PageView and Slider
// Complexity level: intermediate

import 'package:flutter/material.dart';

class SlidingCardCarousel extends StatefulWidget {
  static final String generatedAt = '2024-12-25T00:05:19.547356';
  static final String model = 'null';
  static final String description = 'A sliding card carousel with interactive pagination via PageView and Slider';
  static final String complexityLevel = 'intermediate';


  const SlidingCardCarousel({super.key});

  @override
  State<SlidingCardCarousel> createState() => _SlidingCardCarouselState();
}

class _SlidingCardCarouselState extends State<SlidingCardCarousel> {
  final _pageController = PageController(viewportFraction: 0.8);
  double _currentPage = 0;

  final List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sliding Card Carousel')),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _colors.length,
              itemBuilder: (context, index) {
                final color = _colors[index % _colors.length];
                final scale = (_currentPage - index + 1).clamp(0.8, 1.0);
                return Transform.scale(
                  scale: scale,
                  child: Card(
                    color: color,
                    child: Center(child: Text('$index', style: const TextStyle(fontSize: 48))),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Slider(
            value: _currentPage,
            min: 0,
            max: _colors.length - 1,
            onChanged: (value) {
              setState(() {
                _currentPage = value;
                _pageController.animateToPage(
                  value.floor(),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              });
            },
          )
        ],
      ),
    );
  }
}
