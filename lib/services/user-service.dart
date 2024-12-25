import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class UserService {
  // dotenv.env['API_BASE_URL'] ??
    final String apiBaseUrl = 'https://api.denemetakip.com/api';

    Future<Map<String, dynamic>?> createUser(Map<String, dynamic> user,BuildContext context,{VoidCallback? callBackFunction}) async {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/users/createUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user),
      );
      final responseData = jsonDecode(response.body);
      if (responseData['succeeded'] == true) {
      if (callBackFunction != null) {
        callBackFunction();
      }
      return responseData;
      } 
    else {
      errorToast("Hata",
          responseData['message'] ?? 'Bilinmeyen bir hata oluştu', context);
      }
    }

}