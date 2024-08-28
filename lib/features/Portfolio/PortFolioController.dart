import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../authentication/screens/login/Controller/LoginController.dart';

class PortFolioController {
  static Future<Map<dynamic, dynamic>?> getPortfolio() async {
    final loginController = Get.find<LoginController>(); // Access the LoginController
    int userId = loginController.userData['userId']; // Get the userId from the LoginController

    var client = http.Client();
    var uri = Uri.parse(
        "http://103.108.12.222:11005/kalpco/v0.01/portfolio/users/$userId");
    try {
      var response = await client.get(uri);
      if (response.statusCode == 200) {
        Map<dynamic, dynamic> jsonResponse = jsonDecode(response.body);
        print("jsonResponse: $jsonResponse");
        return jsonResponse;
      } else {
        print("Failed to load portfolio: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error occurred: $e");
      return null;
    } finally {
      client.close();
    }
  }
}
