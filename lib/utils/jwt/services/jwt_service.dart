import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _jwtKey = 'jwt_token';

  // Save JWT Token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtKey, value: token);
  }

  // Get JWT Token
  static Future<String?> getToken() async {
    return await _storage.read(key: _jwtKey);
  }

  // Remove JWT Token (Logout)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _jwtKey);
  }
}
