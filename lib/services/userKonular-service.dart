import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/services/fetchWithAuth.dart';

class CreateUserKonu {
  final List<String> konuIds;

  CreateUserKonu({
    required this.konuIds,
  });
  Map<String, dynamic> toJson() {
    return {
      'konuIds': konuIds,
    };
  }
}

class UserKonularService {
  // dotenv.env['API_BASE_URL'] ??
  final String apiBaseUrl = 'https://api.denemetakip.com/api';
  final fetchWithAuth = FetchWithAuth();
  Future<Map<String, dynamic>> getUserKonular({
    int? page,
    int? size,
    String? dersId,
    VoidCallback? successCallBack,
    Function(String)? errorCallBack,
  }) async {
    String queryString = "";

    if (dersId != null) {
      queryString += "&DersId=$dersId";
    }
    if (page != null && size != null) {
      queryString += "&page=$page&size=$size";
    }

    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/UserKonu/GetUserKonular?$queryString',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (successCallBack != null) {
          successCallBack();
        }
        return data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      if (errorCallBack != null) {
        errorCallBack(error.toString());
      }
      return {'totalCount': 0, 'userKonular': []};
    }
  }
  Future<void> createUserKonu(
      CreateUserKonu createUserKonu, VoidCallback? successCallback) async {
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/UserKonu/CreateUserKonu',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: createUserKonu.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (successCallback != null) {
          successCallback();
        }
      } else {
        throw Exception('Konu tamamlanırken bir hata oluştu: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Konu tamamlanırken bir hata oluştu: $error');
    }
  }
}
