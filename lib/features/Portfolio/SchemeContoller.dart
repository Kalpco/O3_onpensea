import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../authentication/screens/login/Controller/LoginController.dart';


class SchemeContoller {

  static Future<Map<dynamic,dynamic>?> getScheme(String investmentId) async {
    final loginController = Get.find<LoginController>(); // Access the LoginController
    int userId = loginController.userData['userId'];
    var client = http.Client();
    var uri = Uri.parse("http://103.108.12.222:11005/kalpco/v0.01/portfolio/users/$userId/investment/$investmentId");

    var response = await client.get(uri);
    if (response.statusCode == 200) {
      print(uri);
      print(response.body);
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }


}