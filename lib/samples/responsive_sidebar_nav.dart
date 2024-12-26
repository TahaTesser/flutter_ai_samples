// Generated on: 2024-12-26T00:05:22.521643
// Model: claude-3-sonnet-20240229
// Description: A responsive sidebar navigation with animation
// Complexity level: null

import 'package:flutter/material.dart';

class ResponsiveSidebarNav extends StatefulWidget {
  static final String generatedAt = '2024-12-26T00:05:22.521643';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'A responsive sidebar navigation with animation';
  static final String complexityLevel = 'null';


  const ResponsiveSidebarNav({super.key});

  @override
  State<ResponsiveSidebarNav> createState() => _ResponsiveSidebarNavState();
}

class _ResponsiveSidebarNavState extends State<ResponsiveSidebarNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isExpanded = screenWidth > 600;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isExpanded ? 200 : 80,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                    _isExpanded
                        ? _animationController.forward()
                        : _animationController.reverse();
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  color: Colors.blue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 24,
                      ),
                      SizeTransition(
                        sizeFactor: _animation,
                        axis: Axis.horizontal,
                        child: const Text(
                          'Menu',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.horizontal,
                child: const NavItem(icon: Icons.home, label: 'Home'),
              ),
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.horizontal,
                child: const NavItem(icon: Icons.settings, label: 'Settings'),
              ),
              SizeTransition(
                sizeFactor: _animation,
                axis: Axis.horizontal,
                child: const NavItem(icon: Icons.help, label: 'Help'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const NavItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          SizedBox(width: 16),
          Text(label),
        ],
      ),
    );
  }
}
