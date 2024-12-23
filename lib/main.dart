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
              'Flutter Sample of the Day',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                    icon: Icons.code,
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
  final IconData icon;
  final Map<String, String> metadata;
  final VoidCallback onTap;

  const SampleCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
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
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 40, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
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
        ),
      ),
    );
  }
}
