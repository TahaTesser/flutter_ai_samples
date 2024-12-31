// Generated on: 2024-12-31T16:24:25.929064
// Model: claude-3-sonnet-20240229
// Description: This Flutter sample demonstrates an app for finding restaurants. It includes an animated AppBar with a favorite icon, a search bar to filter the list of restaurants, and a list view displaying the restaurants. The favorite icon can be toggled to show or hide a favorite indicator next to each restaurant. The app utilizes state management to handle the search text, favorite status, and animation.
// Complexity level: intermediate

import 'package:flutter/material.dart';

class RestaurantFinderApp extends StatefulWidget {
  static final String generatedAt = '2024-12-31T16:24:25.929064';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'This Flutter sample demonstrates an app for finding restaurants. It includes an animated AppBar with a favorite icon, a search bar to filter the list of restaurants, and a list view displaying the restaurants. The favorite icon can be toggled to show or hide a favorite indicator next to each restaurant. The app utilizes state management to handle the search text, favorite status, and animation.';
  static final String complexityLevel = 'intermediate';


  const RestaurantFinderApp({super.key});

  @override
  _RestaurantFinderAppState createState() => _RestaurantFinderAppState();
}

class _RestaurantFinderAppState extends State<RestaurantFinderApp> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isFavorite = false;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _restaurants = [
    'Burger King',
    'McDonald\'s',
    'KFC',
    'Subway',
    'Domino\'s Pizza',
    'Taco Bell',
    'Pizza Hut'
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    _animationController.isCompleted ? _animationController.reverse() : _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Restaurant Finder'),
          actions: [
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.list_view,
                progress: _animation,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search restaurants...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = _restaurants[index];
                  final isMatching = restaurant
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
                  if (_searchController.text.isEmpty || isMatching) {
                    return ListTile(
                      title: Text(restaurant),
                      trailing: _isFavorite
                          ? const Icon(Icons.favorite, color: Colors.red)
                          : const Icon(Icons.favorite_border),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
