import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/sample_generator_utils.dart';

// ignore_for_file: avoid_print

void main() async {
  final apiKey = Platform.environment['OPENAI_API_KEY'];
  if (apiKey == null || apiKey.trim().isEmpty) {
    print('Error: OPENAI_API_KEY environment variable is not set or empty');
    exit(1);
  }

  try {
    final response = await generateSample(apiKey);
    await updateFiles(response, apiKey);
  } catch (e) {
    print('Error during sample generation: $e');
    exit(1);
  }
}

Future<Map<String, dynamic>> generateSample(String apiKey) async {
  final url = Uri.parse('https://api.openai.com/v1/chat/completions');
  
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${apiKey.trim()}',
      },
      body: jsonEncode({
        'model': 'o1-preview-2024-09-12',
        'messages': [
          {
            'role': 'user',
            'content': '''
Generate a creative, self-contained Flutter widget sample that works as a standalone page or mini-app.
The widget name should be in snake_case format.

Requirements:
1. Respond only with valid JSON.
2. The JSON must include "name", "code", and "metadata".
3. Ensure proper escaping of special characters.

Example response format:
{
  "name": "widget_name",
  "code": "// dart code here",
  "metadata": {
    "description": "A brief description",
    "generated_at": "YYYY-MM-DD",
    "model": "o1-preview-2024-09-12",
    "key_features": ["feature1", "feature2"],
    "complexity_level": "beginner"
  }
}
'''
          }
        ],
        'max_completion_tokens': 4000
      }),
    );

    if (response.statusCode != 200) {
      print('API Error: ${response.body}');
      throw 'API request failed with status ${response.statusCode}: ${response.body}';
    }
    
    final responseBody = jsonDecode(response.body);
    if (responseBody['choices'] == null || responseBody['choices'].isEmpty) {
      throw 'Invalid API response format: No choices found';
    }
    
    final content = responseBody['choices'][0]['message']['content'];
    print('Raw content received: $content'); // Debug output
    
    if (content == null || content.trim().isEmpty) {
      throw 'API response content is empty or null.';
    }
    
    try {
      final parsed = jsonDecode(content);
      if (parsed['metadata'] != null && parsed['metadata']['generated_at'] == null) {
        parsed['metadata']['generated_at'] = DateTime.now().toIso8601String().split('T')[0];
      }
      return parsed;
    } catch (e) {
      print('Error parsing JSON. Raw response content: $content');
      throw 'Failed to parse sample JSON. Error: $e';
    }
  } catch (e) {
    throw 'Failed to generate sample: $e';
  }
}

Future<void> updateFiles(Map<String, dynamic> sample, String apiKey) async {
  await generateWithRetry(sample, () => generateSample(apiKey));
}
