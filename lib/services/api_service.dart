import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<List<dynamic>> fetchNGOs() async {
    final response = await http.get(Uri.parse('$baseUrl/scrape-ngos'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['ngos'];
    } else {
      throw Exception('Failed to fetch NGOs');
    }
  }
}
