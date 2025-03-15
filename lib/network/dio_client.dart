import 'package:dio/dio.dart';
import '../commons/config/api_constants.dart';
import '../utils/jwt/services/jwt_service.dart';

class DioClient {
  static final Dio _dio = Dio();
  static String? token; // Store the token globally

  static Dio getInstance() {
    _dio.interceptors.clear();
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        token = await JwtService.getToken();

        if (token == null) {
          await _fetchGuestToken(); // ✅ Fetch guest token if no user JWT is found
          token = await JwtService.getToken();
        }

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          print("✅ Using token: $token");
        } else {
          print("❌ No token found");
        }

        return handler.next(options);
      },
      onError: (DioException e, handler) async{
        if (e.response?.statusCode == 401) {

          print("❌ 401 Unauthorized. Fetching new guest token...");
          await _fetchGuestToken();  // ✅ Refresh guest token if unauthorized
          token = await JwtService.getToken();

          if (token != null) {
            print("🔄 Retrying request with new token...");

            // ✅ Clone the original request before retrying
            RequestOptions requestOptions = e.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $token';

            return handler.resolve(await _dio.fetch(requestOptions)); // ✅ Retry request
          }
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

  /// **🔹 Fetch Guest Token and Save it**
  static Future<void> _fetchGuestToken() async {
    try {
      final response =
          await _dio.post('${ApiConstants.AUTHENTICATION_URL}/guest-login');

      if (response.statusCode == 200) {
        String guestToken = response.data['token'];
        await JwtService.saveToken(guestToken);
        print("✅ Guest logged in with token: $guestToken");
      } else {
        print("❌ Failed to get guest token");
      }
    } catch (e) {
      print("❌ Error fetching guest token: $e");
    }
  }
}
