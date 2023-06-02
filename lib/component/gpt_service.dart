import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GptService {
  static String? apiKey = dotenv.env['apiKey'];
  static String apiUrl =
      'https://api.openai.com/v1/chat/completions'; // ChatGPT API 엔드포인트 URL

  Future<String> fetchChatGPTResponse(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': message}
        ]
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final completions = data['choices'][0]['message']['content'];
      return completions;
    } else {
      throw Exception('Failed to fetch response from ChatGPT API');
    }
  }
}
