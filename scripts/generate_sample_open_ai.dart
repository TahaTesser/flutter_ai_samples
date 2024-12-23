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
  final today = DateTime.now().toIso8601String().split('T')[0];
  
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
            'content': '''Generate a creative, self-contained Flutter widget sample that works as a standalone page or mini-app.
The widget name should be in snake_case format.

Requirements:
1. Respond ONLY with a single valid JSON object - no additional text or explanations.
2. The JSON must include "name", "code", and "metadata" fields.
3. The "code" field should be a properly escaped string.
4. Include ALL necessary imports at the top of the code.
5. The code should be completely self-contained with no missing dependencies.
6. Ensure all quotes and special characters are properly escaped.
7. The widget should be self-contained and not require any parameters in its constructor.
   Example: `const MySample({super.key});` instead of `const MySample({super.key, required this.text});`

Example response format (respond exactly like this format):
{
  "name": "widget_name",
  "code": "import 'package:flutter/material.dart';\\n\\n// Rest of the dart code here",
  "metadata": {
    "description": "A brief description",
    "generated_at": "$today",
    "model": "o1-preview-2024-09-12",
    "complexity_level": "beginner"
  }
}'''
          }
        ],
        'max_completion_tokens': 4000
      }),
    );

    if (response.statusCode != 200) {
      throw 'API request failed with status ${response.statusCode}: ${response.body}';
    }
    
    final responseBody = jsonDecode(response.body);
    if (responseBody['choices'] == null || responseBody['choices'].isEmpty) {
      throw 'Invalid API response format: No choices found';
    }
    
    final content = responseBody['choices'][0]['message']['content'];
    
    if (content == null || content.trim().isEmpty) {
      throw 'API response content is empty or null.';
    }
    
    try {
      final parsed = jsonDecode(content);
      
      if (!parsed.containsKey('name') || !parsed.containsKey('code') || !parsed.containsKey('metadata')) {
        throw 'Missing required fields in JSON response';
      }
      
      final widgetName = parsed['name']
          .split('_')
          .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join('');
      
      if (parsed['metadata'] != null) {
        parsed['metadata']['generated_at'] = today;
        parsed['metadata']['widget_name'] = widgetName;
      }
      
      return parsed;
    } catch (e) {
      throw 'Failed to parse sample JSON. Error: $e';
    }
  } catch (e) {
    throw 'Failed to generate sample: $e';
  }
}

Future<void> updateFiles(Map<String, dynamic> sample, String apiKey) async {
  await generateWithRetry(sample, () => generateSample(apiKey));
}
