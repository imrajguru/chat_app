import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // 🔐 Replace with your API key
  static const String _apiKey = "PASTE_YOUR_API_KEY_HERE";

  // Example using OpenAI-compatible API
  static const String _endpoint =
      "https://api.openai.com/v1/chat/completions";

  Future<String> getAiResponse(String userMessage) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $_apiKey",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": userMessage}
        ],
        "temperature": 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception("AI response failed");
    }
  }
}
