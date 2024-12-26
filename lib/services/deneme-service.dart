import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/constants/toast.dart';
import 'package:mobil_denemetakip/services/fetchWithAuth.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class DenemeService {
  // dotenv.env['API_BASE_URL'] ??
  final String apiBaseUrl = 'https://api.denemetakip.com/api';
  final fetchWithAuth = FetchWithAuth();
  Future<void> createTyt(CreateTyt tytDeneme) async {
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/Tyts/CreateTyt',
        method: 'POST',
        body: tytDeneme.toJson(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      else {
       final errorBody = jsonDecode(response.body);
        final errorMessages = errorBody is List
            ? errorBody
                .map((e) =>
                    e['value'] is List ? e['value'].join('\n') : e['value'])
                .join('\n')
            : 'TYT denemesi eklenirken bir hata oluştu: ${response.reasonPhrase}';
        throw errorMessages;
      }
    } catch (error) {
      throw error.toString();
    }
  }
}
