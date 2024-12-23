import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/sample_generator_utils.dart';

void main() async {
  final apiKey = Platform.environment['ANTHROPIC_API_KEY'];
  if (apiKey == null || apiKey.trim().isEmpty) {
    print('Error: ANTHROPIC_API_KEY environment variable is not set or empty');
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
  final url = Uri.parse('https://api.anthropic.com/v1/messages');
  
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey.trim(),
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': 'claude-3-sonnet-20240229',
        'max_tokens': 4000,
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
    "model": "claude-3-sonnet-20240229",
    "key_features": ["feature1", "feature2"],
    "complexity_level": "beginner"
  }
}
'''
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      print('API Error: ${response.body}');
      throw 'API request failed with status ${response.statusCode}: ${response.body}';
    }
    
    final responseBody = jsonDecode(response.body);
    if (responseBody['content'] == null) {
      throw 'Invalid API response format: No content found';
    }
    
    final content = responseBody['content'][0]['text'];
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
