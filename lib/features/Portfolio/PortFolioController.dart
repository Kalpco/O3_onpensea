import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:onpensea/commons/config/api_constants.dart';

import '../../network/dio_client.dart';
import '../authentication/screens/login/Controller/LoginController.dart';


class PortFolioController {
  static final Dio dio = DioClient.getInstance(); // Using the configured Dio instance

  static Future<Map<String, dynamic>?> getPortfolio() async {
    final loginController = Get.find<LoginController>(); // Get LoginController instance
    int userId = loginController.userData['userId']; // Extract userId

    try {
      final response = await dio.get("${ApiConstants.PORTFOLIO_URL}/users/$userId");

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = response.data; // No need to decode
        print("Portfolio Data: $jsonResponse");
        return jsonResponse;
      } else {
        print("Failed to load portfolio: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.statusCode} - ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected Error: $e");
      return null;
    }
  }
}



// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:onpensea/commons/config/api_constants.dart';
// import 'dart:convert';
//
// import '../authentication/screens/login/Controller/LoginController.dart';
//
// class PortFolioController {
//   static Future<Map<dynamic, dynamic>?> getPortfolio() async {
//     final loginController = Get.find<LoginController>(); // Access the LoginController
//     int userId = loginController.userData['userId']; // Get the userId from the LoginController
//
//     var client = http.Client();
//     var uri = Uri.parse(
//         "${ApiConstants.PORTFOLIO_URL}/users/$userId");
//     try {
//       var response = await client.get(uri);
//       if (response.statusCode == 200) {
//         Map<dynamic, dynamic> jsonResponse = jsonDecode(response.body);
//         print("jsonResponse: $jsonResponse");
//         return jsonResponse;
//       } else {
//         print("Failed to load portfolio: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//       return null;
//     } finally {
//       client.close();
//     }
//   }
// }
