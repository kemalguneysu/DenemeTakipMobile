import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class UserService {
  // dotenv.env['API_BASE_URL'] ??
    final String apiBaseUrl = 'https://api.denemetakip.com/api';

    Future<Map<String, dynamic>?> createUser(
    Map<String, dynamic> user,
    BuildContext context, {
    VoidCallback? callBackFunction,
  }) async {
    final response = await http.post(
      Uri.parse('$apiBaseUrl/users/createUser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user),
    );

    final responseData = jsonDecode(response.body);

    if (responseData is List) {
      // Hataları işleme
      String errorMessage = '';
      for (var error in responseData) {
        if (error['key'] != null && error['value'] != null) {
          String key = error['key'];
          String values = (error['value'] as List).join("");
          errorMessage += "$values\n";
        }
      }
      errorToast("Hata", errorMessage.trim(), context);
      return null; // Başarısız durumda geriye bir şey döndürmüyoruz
    } else if (responseData is Map<String, dynamic> &&
        responseData['succeeded'] == true) {
      // Başarılı yanıt
      if (callBackFunction != null) {
        callBackFunction();
      }
      return responseData;
    } else if (responseData is Map<String, dynamic>) {
      // Beklenmeyen bir durum
      errorToast(
        "Hata",
        responseData['message'] ?? 'Bilinmeyen bir hata oluştu',
        context,
      );
      return null;
    } else {
      errorToast("Hata", "Beklenmeyen bir yanıt alındı", context);
      return null;
    }
  }

}