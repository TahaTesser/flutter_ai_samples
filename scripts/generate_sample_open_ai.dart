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
            'content': '''Generate a Flutter showcase sample that demonstrates a real-world app use case. Create a rich, well-structured widget that combines multiple Flutter widgets and patterns into a cohesive user interface. The sample should be complex enough to be meaningful yet maintainable.

Requirements:
1. Respond ONLY with a single valid JSON object – no extra text, explanations, or code comments.
2. The JSON must include exactly these keys: "name", "code", and "metadata".
3. The "name" field should use snake_case for the widget's class name (e.g., "task_management_card").
4. The "code" field must:
   - Contain a fully self-contained Flutter code snippet in a properly escaped string.
   - Include ALL necessary imports (e.g., material.dart).
   - Use a constructor with no required parameters (e.g., `const TaskManagementCard({super.key});`).
   - MUST include an AppBar with the sample's title.
   - Feature multiple interactive or animated elements.
   - Demonstrate practical widget composition and real-world patterns.
   - Include meaningful state management.
   - Consider including common app patterns like lists, forms, cards, or data display.
5. The "metadata" field should include:
   - Detailed description of the sample's purpose and features
   - List of key Flutter concepts demonstrated
   - Complexity level (beginner/intermediate/advanced)
   - Categories (e.g., "real-world", "interactive", "animation", "forms")
6. Ensure all quotes and special characters are properly escaped for valid JSON.
7. Provide no additional commentary outside the JSON object.

Example response format (respond exactly like this format):
{
  "name": "widget_name",
  "code": "import 'package:flutter/material.dart';\\n\\n// Rest of the dart code here",
  "metadata": {
    "description": "A detailed description",
    "concepts": ["state management", "animations", "forms"],
    "generated_at": "$today",
    "model": "o1-preview-2024-09-12",
    "complexity_level": "intermediate"
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
