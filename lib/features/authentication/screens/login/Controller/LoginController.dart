import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onpensea/commons/config/api_constants.dart';

import '../../../../../navigation_menu.dart';

class LoginController extends GetxController {
  static final dio = Dio();
  var userType = ''.obs;
  var userData = {}.obs; // Reactive variable to hold user data

  static Future<bool> verifyUserCredentials(
      String email, String password) async {
    try {
      final url =
          '${ApiConstants.USERS_URL}/login';
      print(
          'Sending request to: $url with email: $email and password: $password');

      final response = await dio
          .get(url, queryParameters: {'email': email, 'password': password});

      print('Received response: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode! == 200 && response.statusCode! < 300) {
        final data = response.data;
        if (data['code'] == 2004) {
          Get.find<LoginController>().userData.value = data['data'];
          Get.find<LoginController>().userType.value =
              data['data']['userType']; // Update user data
          return Future.value(true);
        } else {
          return Future.value(false);
        }
      } else {
        print('Unexpected status code: ${response.statusCode}');
        return Future.value(false);
      }
    } catch (e) {
      print('Error during login: $e');
      return Future.value(false);
    }
  }

  void guestLogin() {
    userType.value = 'G';
    userData.value = {};
    Get.find<LoginController>().userType.value = 'G';
    Get.find<LoginController>().userData.value = {
      "userId": 0
    }; // Clear user data for guest
    //Get.find<LoginController>().userData.value = {"isDeliverable":"N"};// Clear user data for guest
    Get.offAll(() => NavigationMenu());
  }
}

class StatusConstants {
  static const String USER_MS_LOGIN_CODE = '2004';
  static const String USER_MS_LOGIN_UNSUCCESSFUL_CODE = '2005';
}
