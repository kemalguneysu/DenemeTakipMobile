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
  Future<void> createAyt(CreateAyt aytDeneme) async {
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/Ayts/CreateAyt',
        method: 'POST',
        body: aytDeneme.toJson(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessages = errorBody is List
            ? errorBody
                .map((e) =>
                    e['value'] is List ? e['value'].join('\n') : e['value'])
                .join('\n')
            : 'AYT denemesi eklenirken bir hata oluştu: ${response.reasonPhrase}';
        throw errorMessages;
      }
    } catch (error) {
      throw error.toString();
    }
  }
  Future<Map<String, dynamic>?> getLastTyt({
    Function()? successCallBack,
    Function(String errorMessage)? errorCallBack,
  }) async {
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/HomePage/GetLastTytDeneme',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (successCallBack != null) {
          successCallBack();
        }
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody is List
            ? errorBody.map((e) => e['value']).join('\n')
            : 'TYT denemesi alınırken bir hata oluştu: ${response.reasonPhrase}';
        throw errorMessage;
      }
    } catch (error) {
      if (errorCallBack != null) {
        errorCallBack(error.toString());
      }
            return null;

    }
  }
  Future<Map<String, dynamic>?> getLastAyt({
    Function()? successCallBack,
    Function(String errorMessage)? errorCallBack,
  }) async {
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/HomePage/GetLastAytDeneme',
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        if (successCallBack != null) {
          successCallBack();
        }
        return jsonDecode(response.body);
      } else {
        final errorBody = jsonDecode(response.body);
        final errorMessage = errorBody is List
            ? errorBody.map((e) => e['value']).join('\n')
            : 'AYT denemesi alınırken bir hata oluştu: ${response.reasonPhrase}';
        throw errorMessage;
      }
    } catch (error) {
      if (errorCallBack != null) {
        errorCallBack(error.toString());
      }
      return null;
    }
  }
  Future<List<DenemeAnaliz>?> getTytAnaliz({
    int denemeSayisi = 5,
    int konuSayisi = 5,
    required String dersId,
    required String type,
    Function()? successCallBack,
    Function(String errorMessage)? errorCallBack,
  }) async {
    try {
      final queryParams = {
        'DenemeSayisi': denemeSayisi.toString(),
        'KonuSayisi': konuSayisi.toString(),
        'DersId': dersId,
        'Type': type,
      };

      final uri = Uri.parse('$apiBaseUrl/Tyts/TytAnaliz').replace(queryParameters: queryParams);
      
      // HTTP isteği
      final response = await fetchWithAuth.fetchWithAuth(uri.toString(), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Success callback çağrısı
        successCallBack?.call();

        if (data['tytAnaliz'] != null) {
          List<dynamic> tytAnalizList = data['tytAnaliz'];
          return tytAnalizList.map((item) => DenemeAnaliz.fromJson(item)).toList();
        }
      } else {
        errorCallBack?.call('Error: ${response.statusCode}');
      }
    } catch (error) {
      errorCallBack?.call(error.toString());
    }
    return null;
  }
  Future<List<DenemeAnaliz>?> getAytAnaliz({
    int denemeSayisi = 5,
    int konuSayisi = 5,
    required String dersId,
    required String type,
    Function()? successCallBack,
    Function(String errorMessage)? errorCallBack,
  }) async {
    try {
      final queryParams = {
        'DenemeSayisi': denemeSayisi.toString(),
        'KonuSayisi': konuSayisi.toString(),
        'DersId': dersId,
        'Type': type,
      };

      final uri = Uri.parse('$apiBaseUrl/Ayts/AytAnaliz').replace(queryParameters: queryParams);
      
      // HTTP isteği
      final response = await fetchWithAuth.fetchWithAuth(uri.toString(), headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Success callback çağrısı
        successCallBack?.call();

        if (data['aytAnaliz'] != null) {
          List<dynamic> aytAnalizList = data['aytAnaliz'];
          return aytAnalizList.map((item) => DenemeAnaliz.fromJson(item)).toList();
        }
      } else {
        errorCallBack?.call('Error: ${response.statusCode}');
      }
    } catch (error) {
      errorCallBack?.call(error.toString());
    }
    return null;
  }
   Future<TytSingleList> getTytById(String id) async {
    final url = '$apiBaseUrl/Tyts/GetTytById?TytId=$id';
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        url,
        headers: {'Content-Type': 'application/json'},
      );

        return TytSingleList.fromJson(json.decode(response.body));
    } catch (e) {
      throw Exception("TYT denemesi bulunamadı.");
    }
  }

  Future<AytSingleList> getAytById(String id) async {
    final url = '$apiBaseUrl/Ayts/GetAytById?AytId=$id';
    try {
      final response = await fetchWithAuth.fetchWithAuth(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return AytSingleList.fromJson(json.decode(response.body));
      } else {
        throw Exception("AYT denemesi bulunamadı.");
      }
    } catch (e) {
      throw Exception("AYT denemesi bulunamadı.");
    }
  }
  Future<void> updateTyt(
    UpdateTyt tytDeneme, {
    Function? successCallback,
    Function(String errorMessage)? errorCallback,
  }) async {

    try {
      final response = await fetchWithAuth.fetchWithAuth(
        '$apiBaseUrl/Tyts/updateTyt',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: tytDeneme.toJson(), 
      );

      if (response.statusCode == 200) {
        if (successCallback != null) {
          successCallback();
        }
      } else {
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
      if (errorCallback != null) {
        errorCallback(error.toString());
      }
    }
  }

  

}