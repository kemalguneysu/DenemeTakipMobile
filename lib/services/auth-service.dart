import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class AuthService {
  
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal() {
    identityCheck();
  }
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool _isAdmin = false;
  String? _userId;
  String? _username;

  final BehaviorSubject<Map<String, dynamic>> _authStatusSubject =
      BehaviorSubject<Map<String, dynamic>>.seeded({
    'isAuthenticated': false,
    'isAdmin': false,
    'userId': null,
    'username': null,
  });


  // Secure Storage'dan token'ı alır
  Future<String?> getSecureStorage(String key) async {
    return await _secureStorage.read(key: key);
  }

  // Oturum kapatma işlemi
  Future<void> signOut() async {
    await _secureStorage.delete(
        key: 'accessToken'); // Token'ı secure storage'dan sil
    _isAuthenticated = false;
    _isAdmin = false;
    _userId = null;
    _username = null;

    // Güncellenen durumu yayınla
    _authStatusSubject.add({
      'isAuthenticated': _isAuthenticated,
      'isAdmin': _isAdmin,
      'userId': _userId,
      'username': _username,
    });
  }

  // Kullanıcıyı doğrulamak için kimlik kontrolü
  Future<void> identityCheck() async {
    String? token = await getSecureStorage('accessToken');

    if (token != null) {
      try {
        Map<String, dynamic> decoded = JwtDecoder.decode(token);

        _isAuthenticated = !isTokenExpired(token);
        _userId = decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ?? null;
        _isAdmin = decoded['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']?.contains('admin') ?? false;
        _username = decoded['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ?? null;
      } catch (error) {
        _isAuthenticated = false;
        _isAdmin = false;
        _userId = null;
        _username = null;
      }
    } else {
      _isAuthenticated = false;
      _isAdmin = false;
      _userId = null;
      _username = null;
    }

    // Durumu güncelle
    _authStatusSubject.add({
      'isAuthenticated': _isAuthenticated,
      'isAdmin': _isAdmin,
      'userId': _userId,
      'username': _username,
    });
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }
  Map<String, dynamic> get userStatus {
    return {
      'isAuthenticated': _isAuthenticated,
      'isAdmin': _isAdmin,
      'userId': _userId,
      'username': _username,
    };
  }
  
  bool get isAuthenticated => _isAuthenticated;
  bool get isAdmin => _isAdmin;
  String? get userId => _userId;
  String? get username => _username;

  // Auth durumu stream
  Stream<Map<String, dynamic>> get authStatusStream =>
      _authStatusSubject.stream;
}
