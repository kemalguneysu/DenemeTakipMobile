import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants/index.dart';


final String apiBaseUrl = dotenv.env['API_BASE_URL'] ?? 'https://api.denemetakip.com/api';
final FlutterSecureStorage _storage = FlutterSecureStorage();

Future<void> login(String userNameOrEmail, String password,
    {VoidCallback? callBackFunction}) async {
  try {
    final response = await http.post(
      Uri.parse('https://api.denemetakip.com/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
          {'userNameOrEmail': userNameOrEmail, 'password': password}),
    );

    if (response.statusCode != 200) {
      throw Exception('Giriş işlemi başarısız');
    }

    final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));

    if (tokenResponse != null) {
      await _storage.write(key: 'accessToken', value: tokenResponse.token.accessToken);
      await _storage.write(key: 'refreshToken', value: tokenResponse.token.refreshToken);
      
      final Uri currentUri = Uri.base;
      final String? redirectTo = currentUri.queryParameters['redirectTo'];

      if (redirectTo != null) {
        // Yönlendirme işlemi
        // Flutter'da yönlendirme için Navigator kullanabilirsiniz
        // Örneğin: Navigator.pushNamed(context, redirectTo);
      } else {
        if (callBackFunction != null) {
          callBackFunction();
        }
      }
    }
  } catch (error) {
    // Hata mesajı
    // Flutter'da toast mesajları için uygun bir paket kullanmanız gerekebilir
    // Örneğin: fluttertoast
  }
}
