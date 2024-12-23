import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class UserService {
  // dotenv.env['API_BASE_URL'] ??
    final String apiBaseUrl = 'https://api.denemetakip.com/api';
    Future<Map<String, dynamic>> createUser(Map<String, dynamic> user,{VoidCallback? callBackFunction}) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/users/createUser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    if (response.statusCode == 200) {
      if (callBackFunction != null) {
        callBackFunction();
      }
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }

}