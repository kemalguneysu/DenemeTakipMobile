import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_denemetakip/constants/index.dart';

class KonularService {
  // dotenv.env['API_BASE_URL'] ??
  final String apiBaseUrl = 'https://api.denemetakip.com/api';

  Future<Map<String, dynamic>> getAllKonular({
    bool? isTyt,
    String? konuOrDersAdi,
    int? page,
    int? size,
    List<String>? dersIds,
    Function? successCallBack,
    Function? errorCallBack,
  }) async {
    String queryString = '';

    // Query string oluşturma
    if (isTyt != null) {
      queryString += 'isTyt=$isTyt';
    }
    if (konuOrDersAdi != null) {
      queryString += '&KonuOrDersAdi=$konuOrDersAdi';
    }
    if (dersIds != null && dersIds.isNotEmpty) {
      queryString += '&dersId=${dersIds.join('&dersId=')}';
    }
    if (page != null && size != null) {
      queryString += '&page=$page&size=$size';
    }

    try {
      // API'den veri çekme
      final response = await http.get(
        Uri.parse('$apiBaseUrl/Konular/GetAllKonular?$queryString'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (successCallBack != null) {
          successCallBack();
        }

        return {
          'totalCount': data['totalCount'],
          'konular': (data['konular'] as List)
              .map((i) => ListKonu.fromJson(i))
              .toList(),
        };
      } else {
        throw Exception('Failed to load konular');
      }
    } catch (error) {
      // Hata durumunda geri çağırma fonksiyonunu çağır
      if (errorCallBack != null) {
        errorCallBack(error.toString());
      }

      // Varsayılan boş veri döndür
      return {'totalCount': 0, 'konular': []};
    }
  }
}
