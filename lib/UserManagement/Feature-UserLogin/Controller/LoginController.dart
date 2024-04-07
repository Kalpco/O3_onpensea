import 'package:dio/dio.dart';

import '../../../config/ApiUrl.dart';

class LoginController {
  static final dio = Dio();

  static Future<bool> verifyUserCredentials(
      String email, String password) async {
    try {
      final url =
          '${ApiUrl.API_URL_USERMANAGEMENT}user/getLogin?email=$email&password=$password';
      final response = await dio.get(url);

      if (response.statusCode! >= 200 || response.statusCode! <= 300) {
        if (response.data == "Fail") {
          return Future.value(false);
        }
        return Future.value(true);
      }
    } catch (e) {
      throw Exception("error: $e");
    }
    return Future.value(false);
  }
}
