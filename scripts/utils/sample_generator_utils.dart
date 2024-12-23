import 'dart:io';
import 'package:yaml/yaml.dart';
import 'dart:convert';

Future<void> incrementBuildNumber() async {
  final pubspecFile = File('pubspec.yaml');
  var pubspecContent = await pubspecFile.readAsString();
  final yaml = loadYaml(pubspecContent);
  final version = yaml['version'] as String;
  final parts = version.split('+');
  final buildNumber = int.parse(parts[1]) + 1;
  pubspecContent =
      pubspecContent.replaceFirst(version, '${parts[0]}+$buildNumber');
  await pubspecFile.writeAsString(pubspecContent);
}

Future<bool> runCodeFixes() async {
  print('\nRunning Dart fix...');
  final fixResult = await Process.run('dart', ['fix', '--apply']);
  if (fixResult.exitCode != 0) {
    print('Dart fix encountered issues:\n${fixResult.stdout}\n${fixResult.stderr}');
    await resetAndCleanup();
    await Process.run('dart', ['fix', '--apply']);
    return false;
  }

  print('\nRunning Flutter analyze...');
  final analyzeResult = await Process.run('flutter', ['analyze']);
  if (analyzeResult.exitCode != 0) {
    final output = analyzeResult.stdout.toString();
    final hasErrors = _checkForFatalErrors(output);
    
    if (hasErrors) {
      print('Flutter analyze found fatal issues:\n${analyzeResult.stdout}\n${analyzeResult.stderr}');
      await resetAndCleanup();
      await Process.run('dart', ['fix', '--apply']);
      return false;
    } else {
      print('Flutter analyze found non-fatal issues:\n${analyzeResult.stdout}');
      return true;
    }
  }

  print('Code fixes completed successfully!');
  return true;
}

bool _checkForFatalErrors(String output) {
  final fatalErrors = [
    'error •',
    'Error:',
    "URI doesn't exist",
    "isn't defined for the type",
    "argument_type_not_assignable"
  ];
  return fatalErrors.any((error) => output.contains(error));
}

Future<void> resetAndCleanup() async {
  print('\nResetting to last commit...');
  final resetResult = await Process.run('git', ['reset', '--hard']);
  if (resetResult.exitCode != 0) {
    print('Git reset failed:\n${resetResult.stderr}');
    return;
  }
}

Future<void> generateWithRetry(
  Map<String, dynamic> sample,
  Future<Map<String, dynamic>> Function() generateSample,
) async {
  sample['metadata']['generated_at'] = DateTime.now().toIso8601String();
  
  const maxRetries = 3;
  var attempts = 0;
  
  while (attempts < maxRetries) {
    attempts++;
    print('\nAttempt $attempts of $maxRetries');
    
    final sampleFile = File('lib/samples/${sample['name']}.dart');
    final backupFile = File('lib/samples/${sample['name']}.dart.bak');
    
    if (await sampleFile.exists()) {
      await sampleFile.copy(backupFile.path);
    }

    try {
      await _writeSampleFile(sampleFile, sample);

      if (await runCodeFixes()) {
        await _cleanupAndFinalize(backupFile, sample);
        return;
      }

      print('\nAnalysis failed. Reverting changes...');
      await _revertChanges(sampleFile, backupFile);

      if (attempts < maxRetries) {
        sample = await generateSample();
      }

    } catch (e) {
      print('Error during attempt $attempts: $e');
      await _revertChanges(sampleFile, backupFile);
      if (attempts >= maxRetries) {
        rethrow;
      }
    }
  }

  throw 'Failed to generate valid sample after $maxRetries attempts';
}

Future<void> generateWithoutRetry(Map<String, dynamic> sample) async {
  sample['metadata']['generated_at'] = DateTime.now().toIso8601String();
  
  final sampleFile = File('lib/samples/${sample['name']}.dart');
  await _writeSampleFile(sampleFile, sample);
  
  await incrementBuildNumber();
  await updateSamplesJson(sample);
}

Future<void> _writeSampleFile(File sampleFile, Map<String, dynamic> sample) async {
  final metadata = sample['metadata'];
  final metadataComment = _generateMetadataComment(metadata);
  final metadataProps = _generateMetadataProperties(metadata);

  final code = sample['code'];
  final classMatch = RegExp(r'class\s+\w+\s+extends\s+StatefulWidget\s*{').firstMatch(code);
  if (classMatch == null) {
    throw 'Could not find widget class declaration';
  }

  final modifiedCode = code.replaceRange(
    classMatch.end,
    classMatch.end,
    '\n$metadataProps\n'
  );

  await sampleFile.writeAsString(metadataComment + modifiedCode);
}

String _generateMetadataComment(Map<String, dynamic> metadata) {
  return '''
// Generated on: ${metadata['generated_at']}
// Model: ${metadata['model']}
// Description: ${metadata['description'].toString().replaceAll("'", "'")}
// Complexity level: ${metadata['complexity_level']}

''';
}

String _generateMetadataProperties(Map<String, dynamic> metadata) {
  return '''
  static final String generatedAt = '${metadata['generated_at']}';
  static final String model = '${metadata['model']}';
  static final String description = '${metadata['description'].toString().replaceAll("'", "'")}';
  static final String complexityLevel = '${metadata['complexity_level']}';
''';
}

Future<void> _cleanupAndFinalize(File backupFile, Map<String, dynamic> sample) async {
  if (await backupFile.exists()) {
    await backupFile.delete();
  }
  await incrementBuildNumber();
  await updateSamplesJson(sample);
}

Future<void> _revertChanges(File sampleFile, File backupFile) async {
  if (await backupFile.exists()) {
    await backupFile.copy(sampleFile.path);
    await backupFile.delete();
  } else {
    await sampleFile.delete();
  }
}

Future<void> updateSamplesJson(Map<String, dynamic> sample) async {
  final jsonFile = File('assets/data/samples.json');
  Map<String, dynamic> samplesData;
  
  if (await jsonFile.exists()) {
    final jsonString = await jsonFile.readAsString();
    samplesData = json.decode(jsonString);
  } else {
    samplesData = {'samples': []};
    await jsonFile.create(recursive: true);
  }

  final samples = samplesData['samples'] as List;
  final sampleData = _createSampleData(sample);
  
  final existingIndex = samples.indexWhere((s) => s['name'] == sample['name']);
  if (existingIndex != -1) {
    samples[existingIndex] = sampleData;
  } else {
    samples.add(sampleData);
  }

  await jsonFile.writeAsString(json.encode(samplesData));
}

Map<String, dynamic> _createSampleData(Map<String, dynamic> sample) {
  return {
    'name': sample['name'],
    'title': sample['metadata']['title'] ?? sample['name'],
    'description': sample['metadata']['description'],
    'generatedAt': sample['metadata']['generated_at'],
    'model': sample['metadata']['model'],
    'complexityLevel': sample['metadata']['complexity_level'],
    'widgetName': sample['metadata']['widget_name'],
  };
}
