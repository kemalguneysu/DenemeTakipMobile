import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class FetchWithAuth {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'accessToken');
  }

  Future<Map<String, String>> _getHeaders(
      Map<String, String>? additionalHeaders) async {
    final token = await _getToken();
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  Future<http.Response> fetchWithAuth(String url,
      {String method = 'GET',
      Map<String, String>? headers,
      dynamic body}) async {
    final requestHeaders = await _getHeaders(headers);
    final request = http.Request(method, Uri.parse(url))
      ..headers.addAll(requestHeaders);

    if (body != null) {
      request.body = jsonEncode(body);
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
