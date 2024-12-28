import 'dart:convert';
import 'dart:ui';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_denemetakip/constants/index.dart';
import 'package:mobil_denemetakip/services/fetchWithAuth.dart';

class DerslerService {
  // dotenv.env['API_BASE_URL'] ??
  final String apiBaseUrl = 'https://api.denemetakip.com/api';
  final fetchWithAuth = FetchWithAuth();
  Future<Map<String, dynamic>> getAllDers({
    bool? isTyt,
    String? dersAdi,
    int? page,
    int? size,
    Function? successCallBack,
    Function? errorCallBack,
  }) async {
    String queryString = '';

    // Query string oluşturma
    if (isTyt != null) {
      queryString += 'isTyt=$isTyt';
    }
    if (dersAdi != null) {
      queryString += '&DersAdi=$dersAdi';
    }
    if (page != null && size != null) {
      queryString += '&page=$page&size=$size';
    }

    try {
      // API'den veri çekme
      final response = await fetchWithAuth.fetchWithAuth(
        ('$apiBaseUrl/Ders/GetAllDersler?$queryString'),
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 && isTyt==true) {
        final data = jsonDecode(response.body);
         List<Ders> dersler = (data['dersler'] as List)
            .map((i) => Ders.fromJson(i))
            .toList()
          ..sort((a, b) {
            const order = ['Türkçe', 'Matematik', 'Fen', 'Sosyal'];
            return order.indexOf(a.dersAdi).compareTo(order.indexOf(b.dersAdi));
          });
        // Başarılıysa geri çağırma fonksiyonunu çağır
        if (successCallBack != null) {
          successCallBack();
        }
        return {
          'totalCount': data['totalCount'],
          'dersler': dersler,
        };
      }
      else  if (response.statusCode == 200 && isTyt == false) {
        final data = jsonDecode(response.body);
        List<Ders> dersler = (data['dersler'] as List)
            .map((i) => Ders.fromJson(i))
            .toList()
          ..sort((a, b) {
            const order = [
              "Matematik",
              "Fizik",
              "Kimya",
              "Biyoloji",
              "Edebiyat",
              "Tarih1",
              "Coğrafya1",
              "Tarih2",
              "Coğrafya2",
              "Felsefe",
              "Din",
              "Dil",
            ];
            return order.indexOf(a.dersAdi).compareTo(order.indexOf(b.dersAdi));
          });
        // Başarılıysa geri çağırma fonksiyonunu çağır
        if (successCallBack != null) {
          successCallBack();
        }
        return {
          'totalCount': data['totalCount'],
          'dersler': dersler,
        };
      } else {
        throw Exception('Failed to load dersler');
      }
    } catch (error) {
      // Hata durumunda geri çağırma fonksiyonunu çağır
      if (errorCallBack != null) {
        errorCallBack(error.toString());
      }

      // Varsayılan boş veri döndür
      return {'totalCount': 0, 'dersler': []};
    }
  }
}
