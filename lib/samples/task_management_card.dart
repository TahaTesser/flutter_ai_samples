// Generated on: 2025-01-01T00:06:04.426854
// Model: claude-3-sonnet-20240229
// Description: This sample demonstrates a task management card with a list view, form input, and animations. Users can view tasks, toggle their completion status, and add new tasks with an animated form. The sample showcases state management, animations, forms, and list views in a practical and interactive way.
// Complexity level: intermediate

import 'package:flutter/material.dart';

class TaskManagementCard extends StatefulWidget {
  static final String generatedAt = '2025-01-01T00:06:04.426854';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'This sample demonstrates a task management card with a list view, form input, and animations. Users can view tasks, toggle their completion status, and add new tasks with an animated form. The sample showcases state management, animations, forms, and list views in a practical and interactive way.';
  static final String complexityLevel = 'intermediate';


  const TaskManagementCard({super.key});

  @override
  State<TaskManagementCard> createState() => _TaskManagementCardState();
}

class _TaskManagementCardState extends State<TaskManagementCard>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> tasks = [
    {'title': 'Task 1', 'completed': false},
    {'title': 'Task 2', 'completed': true},
    {'title': 'Task 3', 'completed': false},
  ];
  bool showForm = false;
  final TextEditingController _taskController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _taskController.dispose();
    super.dispose();
  }

  void _toggleForm() {
    setState(() {
      showForm = !showForm;
      if (showForm) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        tasks.add({'title': _taskController.text, 'completed': false});
        _taskController.clear();
        showForm = false;
        _animationController.reverse();
      });
    }
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      tasks[index]['completed'] = !tasks[index]['completed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Management'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(tasks[index]['title']),
                    leading: GestureDetector(
                      onTap: () => _toggleTaskCompletion(index),
                      child: CircleAvatar(
                        backgroundColor: tasks[index]['completed']
                            ? Colors.green
                            : Colors.grey,
                        child: Icon(
                          tasks[index]['completed']
                              ? Icons.check
                              : Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) => Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
            child: showForm
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _taskController,
                          decoration: const InputDecoration(
                            hintText: 'Add a new task',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _addTask,
                          child: const Text('Add Task'),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _toggleForm,
              child: Text(showForm ? 'Close' : 'Add Task'),
            ),
          ),
        ],
      ),
    );
  }
}
