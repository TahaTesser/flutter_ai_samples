// Generated on: 2025-01-02T00:05:30.577817
// Model: claude-3-sonnet-20240229
// Description: This sample demonstrates a task management app with a card-based UI. Users can view a list of tasks, mark them as completed or incomplete, delete tasks, and add new tasks. The app features animations, state management, interactive elements (checkboxes, text fields), and common UI patterns like cards and lists.
// Complexity level: intermediate

import 'package:flutter/material.dart';

class TaskManagementCard extends StatefulWidget {
  static final String generatedAt = '2025-01-02T00:05:30.577817';
  static final String model = 'claude-3-sonnet-20240229';
  static final String description = 'This sample demonstrates a task management app with a card-based UI. Users can view a list of tasks, mark them as completed or incomplete, delete tasks, and add new tasks. The app features animations, state management, interactive elements (checkboxes, text fields), and common UI patterns like cards and lists.';
  static final String complexityLevel = 'intermediate';


  const TaskManagementCard({super.key});

  @override
  State<TaskManagementCard> createState() => _TaskManagementCardState();
}

class _TaskManagementCardState extends State<TaskManagementCard> with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Buy Groceries', 'completed': false},
    {'title': 'Clean the House', 'completed': true},
    {'title': 'Finish Project Report', 'completed': false},
  ];

  bool _isEditing = false;
  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _addTask(String title) {
    setState(() {
      _tasks.add({'title': title, 'completed': false});
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
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: task['completed'],
                      onChanged: (value) {
                        _toggleTaskCompletion(index);
                      },
                    ),
                    title: Text(
                      task['title'],
                      style: TextStyle(
                        decoration: task['completed'] ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteTask(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (value) {
                  _addTask(value);
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                decoration: const InputDecoration(
                  hintText: 'Add a task',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleEditing,
        tooltip: _isEditing ? 'Save' : 'Add Task',
        child: Icon(_isEditing ? Icons.save : Icons.add),
      ),
    );
  }
}
