// Generated on: 2025-01-03T00:05:26.272952
// Model: claude-v1
// Description: A task management card that allows users to add, remove, and toggle completion of tasks. It demonstrates state management, animations, forms, and lists in a real-world scenario.
// Complexity level: intermediate

import 'package:flutter/material.dart';

class TaskManagementCard extends StatefulWidget {
  static final String generatedAt = '2025-01-03T00:05:26.272952';
  static final String model = 'claude-v1';
  static final String description = 'A task management card that allows users to add, remove, and toggle completion of tasks. It demonstrates state management, animations, forms, and lists in a real-world scenario.';
  static final String complexityLevel = 'intermediate';


  const TaskManagementCard({super.key});

  @override
  State<TaskManagementCard> createState() => _TaskManagementCardState();
}

class _TaskManagementCardState extends State<TaskManagementCard> with SingleTickerProviderStateMixin {
  final List<String> _tasks = [];
  final TextEditingController _taskController = TextEditingController();
  bool _showCompleted = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _taskController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.add(_taskController.text);
        _taskController.clear();
        _animationController.forward();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _animationController.reverse();
    });
  }

  void _toggleCompleted() {
    setState(() {
      _showCompleted = !_showCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Task Management'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _taskController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a task',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTask,
                  ),
                ],
              ),
            ),
            FadeTransition(
              opacity: _animation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Show Completed'),
                  Switch(
                    value: _showCompleted,
                    onChanged: (value) {
                      _toggleCompleted();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  if (_showCompleted || !_tasks[index].contains('â')) {
                    return Dismissible(
                      key: Key(_tasks[index]),
                      onDismissed: (_) {
                        _removeTask(index);
                      },
                      child: ListTile(
                        title: Text(_tasks[index]),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
