import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_denemetakip/constants/index.dart';

class DenemeService {
  // dotenv.env['API_BASE_URL'] ??
  final String apiBaseUrl = 'https://api.denemetakip.com/api';

  Future<void> createTyt(CreateTyt tytDeneme) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/Tyts/CreateTyt'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tytDeneme),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create TYT');
    }
  }
}
