// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Backend running on your Mac
  final String baseUrl = "http://127.0.0.1:8000";

  Future<String> sendMessage(String message) async {
    final url = Uri.parse("$baseUrl/chat");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      return decoded["reply"] ?? "No reply from server";
    } else {
      throw Exception(
        "API error: ${response.statusCode} ${response.reasonPhrase}",
      );
    }
  }
}

