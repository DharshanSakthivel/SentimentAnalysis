import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://192.168.56.1:8000";

  static Future<String> predictSentiment(String text, String model) async {
    final url = Uri.parse("$_baseUrl/predict");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "text": text,
          "model": model,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('sentiment')) {
          return data['sentiment'];
        } else if (data.containsKey('error')) {
          return "❌ Server error: ${data['error']}";
        } else {
          return "❌ Unexpected response format";
        }
      } else {
        return "❌ Server returned status: ${response.statusCode}";
      }
    } catch (e) {
      return "❌ Connection failed: $e";
    }
  }
}
