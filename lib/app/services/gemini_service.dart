import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiService {
  final apiKey = dotenv.get('API_KEY');

  Future<String> sendMessage(String message) async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message}
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null &&
            data['candidates'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'];
        }
        return 'No response from AI';
      }

      switch (response.statusCode) {
        case 400:
          return 'Bad request';

        case 401:
          return 'Unauthorized API key';

        case 403:
          return 'API access denied';

        case 404:
          return 'Model not found';

        case 429:
          return 'Quota exceeded. Try again later';

        case 500:
          return 'Server error';

        default:
          return 'Error: ${response.statusCode}';
      }
    } catch (e) {
      print("ERROR: $e");
      return 'Exception: $e';
    }
  }
}
