import 'dart:io';
import 'dart:convert';

void main() async {
  // Read the JSON file
  final file = File('assets/data/samples.json');
  final jsonContent = await file.readAsString();
  
  // Parse JSON - handle both Map and List formats
  final dynamic jsonData = json.decode(jsonContent);
  final List<dynamic> samples;
  
  if (jsonData is Map) {
    samples = (jsonData['samples'] as List<dynamic>?) ?? [];
  } else if (jsonData is List) {
    samples = jsonData;
  } else {
    throw FormatException('Invalid JSON format: expected Map or List');
  }

  // Generate the Dart code
  final StringBuffer buffer = StringBuffer();
  
  // Write the header
  buffer.writeln('// This file is auto-generated. Do not edit manually.');
  buffer.writeln("import '../sample.dart';\n");

  // Import all sample widgets
  for (final sample in samples) {
    final String name = sample['name'];
    buffer.writeln("import '../samples/$name.dart';");
  }

  buffer.writeln('\nfinal samples = <Sample>[');

  // Generate the samples list
  for (final sample in samples) {
    final String name = sample['name'];
    final String title = sample['title'];
    final String description = sample['description'];
    final String generatedAt = sample['generatedAt'] ?? '';
    final String model = sample['model'] ?? '';
    final String complexityLevel = sample['complexityLevel'] ?? '';
    final String className = sample['widgetName'] ?? '';
    
    buffer.writeln('''
  Sample(
    name: '$name',
    title: '$title',
    description: '$description',
    generatedAt: '$generatedAt',
    model: '$model',
    complexityLevel: '$complexityLevel',
    widget: $className(),
  ),''');
  }

  buffer.writeln('];');

  // Write to samples.dart
  final outputFile = File('lib/samples.dart');
  await outputFile.writeAsString(buffer.toString());
  
  print('Successfully updated lib/samples.dart');
} 