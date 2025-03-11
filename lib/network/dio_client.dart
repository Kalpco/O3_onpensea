import 'package:dio/dio.dart';
import '../utils/jwt/services/jwt_service.dart';

class DioClient {
  static final Dio _dio = Dio();
  static String? token; // Store the token globally

  static Dio getInstance() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
       token = await JwtService.getToken();

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          print("✅ Added Authorization header: Bearer $token");
        } else {
          print("❌ No token found, request sent without Authorization header.");
        }

        return handler.next(options);
      },
      onError: (DioException e, handler) {
        if (e.response?.statusCode == 401) {
          // Handle Unauthorized (JWT expired)
          print("❌ Unauthorized request. Clearing token...");
          JwtService.deleteToken();
          token = null; // Reset token on 401
        }
        return handler.next(e);
      },
    ));
    return _dio;
  }
  /// **Fetch Token for CachedNetworkImage**
  static Future<String?> getAuthToken() async {
    token ??= await JwtService.getToken();
    return token;
  }
}
