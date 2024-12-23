import 'dart:io';
import 'package:yaml/yaml.dart';

Future<void> updateMainDartFile(String sampleName, String importLine) async {
  final mainFile = File('lib/main.dart');
  var content = await mainFile.readAsString();

  // Find the last import statement
  final importRegex = RegExp(r'^import.*$', multiLine: true);
  final matches = importRegex.allMatches(content).toList();
  if (matches.isEmpty) {
    throw 'No import statements found in main.dart';
  }
  final lastImport = matches.last;

  // Insert new import after the last import
  content = content.replaceRange(lastImport.end, lastImport.end, '\n$importLine');

  // Capitalize the first letter of each word in the widget name
  final widgetName = sampleName
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join('');

  final listEntry = "    $widgetName(),";

  // Add the widget to the samples list
  content = content.replaceFirst(
      '  static final samples = [', '  static final samples = [\n$listEntry');

  await mainFile.writeAsString(content);
}

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
    
    // Reset to last commit when fixes fail
    print('\nResetting to last commit...');
    final resetResult = await Process.run('git', ['reset', '--hard']);
    if (resetResult.exitCode != 0) {
      print('Git reset failed:\n${resetResult.stderr}');
    }
    
    return false;
  }

  print('\nRunning Flutter analyze...');
  final analyzeResult = await Process.run('flutter', ['analyze']);
  if (analyzeResult.exitCode != 0) {
    print('Flutter analyze found issues:\n${analyzeResult.stdout}\n${analyzeResult.stderr}');
    
    // Reset to last commit when analysis fails
    print('\nResetting to last commit...');
    final resetResult = await Process.run('git', ['reset', '--hard']);
    if (resetResult.exitCode != 0) {
      print('Git reset failed:\n${resetResult.stderr}');
    }
    
    return false;
  }

  print('Code fixes completed successfully!');
  return true;
}

Future<void> generateWithRetry(
  Map<String, dynamic> sample,
  Future<Map<String, dynamic>> Function() generateSample,
) async {
  const maxRetries = 3;
  var attempts = 0;
  
  while (attempts < maxRetries) {
    attempts++;
    print('\nAttempt $attempts of $maxRetries');
    
    // Create new sample file
    final sampleFile = File('lib/samples/${sample['name']}.dart');
    final backupFile = File('lib/samples/${sample['name']}.dart.bak');
    
    // Backup existing file if it exists
    if (await sampleFile.exists()) {
      await sampleFile.copy(backupFile.path);
    }

    try {
      // Write the new sample
      final metadata = sample['metadata'];
      final metadataComment = '''
// Generated on: ${metadata['generated_at']}
// Model: ${metadata['model']}
// Description: ${metadata['description']}
// Key features: ${metadata['key_features'].join(', ')}
// Complexity level: ${metadata['complexity_level']}

''';

      // Add static metadata properties to the widget class
      final metadataProps = '''
  static final String generatedAt = '${metadata['generated_at']}';
  static final String model = '${metadata['model']}';
  static final String description = '${metadata['description']}';
  static final List<String> keyFeatures = ${metadata['key_features']};
  static final String complexityLevel = '${metadata['complexity_level']}';
''';

      // Insert the metadata properties after the class declaration
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

      // Update main.dart with the new sample
      final importLine = "import 'samples/${sample['name']}.dart';";
      await updateMainDartFile(sample['name'], importLine);

      // Run code fixes and analyze
      if (await runCodeFixes()) {
        // Success! Clean up backup and increment version
        if (await backupFile.exists()) {
          await backupFile.delete();
        }
        await incrementBuildNumber();
        return;
      }

      // If we get here, analysis failed
      print('\nAnalysis failed. Reverting changes...');
      
      // Restore from backup if it exists
      if (await backupFile.exists()) {
        await backupFile.copy(sampleFile.path);
        await backupFile.delete();
      } else {
        await sampleFile.delete();
      }

      // If this wasn't our last attempt, generate a new sample
      if (attempts < maxRetries) {
        sample = await generateSample();
      }

    } catch (e) {
      print('Error during attempt $attempts: $e');
      // Clean up on error
      if (await backupFile.exists()) {
        await backupFile.copy(sampleFile.path);
        await backupFile.delete();
      }
      if (attempts >= maxRetries) {
        rethrow;
      }
    }
  }

  throw 'Failed to generate valid sample after $maxRetries attempts';
} 