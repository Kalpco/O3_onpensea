import 'package:dio/dio.dart';
import '../utils/jwt/services/jwt_service.dart';

class DioClient {
  static final Dio _dio = Dio();

  static Dio getInstance() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? token = await JwtService.getToken();

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
        }
        return handler.next(e);
      },
    ));
    return _dio;
  }
}
