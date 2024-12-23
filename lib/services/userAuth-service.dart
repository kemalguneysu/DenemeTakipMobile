import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import '../constants/index.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class UserAuthService{
  // dotenv.env['API_BASE_URL'] ??
  final String apiBaseUrl = 'https://api.denemetakip.com/api';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> login(
      String userNameOrEmail, String password, BuildContext context,
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

      final tokenResponse = TokenResponse.fromJson(jsonDecode(response.body));
      if (tokenResponse != null) {
        await _storage.write(
            key: 'accessToken', value: tokenResponse.token.accessToken);
        await _storage.write(
            key: 'refreshToken', value: tokenResponse.token.refreshToken);

        final Uri currentUri = Uri.base;
        final String? redirectTo = currentUri.queryParameters['redirectTo'];
        if (redirectTo != null) {
        } else {
          if (callBackFunction != null) {
            callBackFunction();
          }
        }
      }
    } catch (error) {
      errorToast(
          "Giriş Yapılamadı", 'Kullanıcı adı veya şifre hatalı.', context);
    }
  }

}
