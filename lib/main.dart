import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'samples.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sample of the Day',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSamples();
  }

  Future<void> _loadSamples() async {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Flutter AI Samples'),
        content: const Text(
          'This app showcases various Flutter UI samples generated using AI. '
          'Each sample demonstrates different Flutter widgets and patterns, '
          'created with the help of AI models to inspire and educate developers.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: const Text(
              'Flutter AI Samples',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: _showAboutDialog,
                tooltip: 'About',
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final sample = samples[index];
                  return SampleCard(
                    title: sample.title,
                    description: sample.description,
                    metadata: {
                      'Generated': sample.generatedAt,
                      'Model': sample.model,
                      'Complexity': sample.complexityLevel,
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Material(
                            child: sample.widget,
                          ),
                        ),
                      );
                    },
                  );
                },
                childCount: samples.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SampleCard extends StatelessWidget {
  final String title;
  final String description;
  final Map<String, String> metadata;
  final VoidCallback onTap;

  const SampleCard({
    super.key,
    required this.title,
    required this.description,
    required this.metadata,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final formattedMetadata = metadata.map((key, value) {
      if (key == 'Generated') {
        try {
          final timestamp = DateTime.parse(value);
          return MapEntry(key, DateFormat('MMM d, y').format(timestamp));
        } catch (e) {
          return MapEntry(key, value);
        }
      }
      return MapEntry(key, value);
    });

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: formattedMetadata.entries.map((entry) {
                    return Chip(
                      label: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
