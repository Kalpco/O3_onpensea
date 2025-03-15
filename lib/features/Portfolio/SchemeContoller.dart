import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import '../../network/dio_client.dart';
import '../authentication/screens/login/Controller/LoginController.dart';

class SchemeController {
  static final Dio _dio = DioClient.getInstance(); // Get Dio instance with interceptor

  static Future<Map<dynamic, dynamic>?> getScheme(String investmentId) async {
    final loginController = Get.find<LoginController>(); // Access the LoginController
    int userId = loginController.userData['userId'];

    String url = "${ApiConstants.PORTFOLIO_URL}/users/$userId/investment/$investmentId";

    try {
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        print("✅ API Success: $url");
        print(response.data);
        return response.data;
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.statusMessage}");
        return null;
      }
    } on DioException catch (e) {
      print("❌ Dio Error: ${e.response?.statusCode} - ${e.message}");
      return null;
    } catch (e) {
      print("❌ Unexpected Error: $e");
      return null;
    }
  }
}
