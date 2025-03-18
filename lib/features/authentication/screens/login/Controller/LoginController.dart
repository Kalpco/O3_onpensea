import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../network/dio_client.dart';
import '../../../../../utils/jwt/services/jwt_service.dart';
import '../login.dart';

class LoginController extends GetxController {
  static final dio = DioClient.getInstance(); // Use singleton Dio client
  var userType = ''.obs;
  var userData = {}.obs; // Holds user data reactively

  /// **🔹 Login Function**
  static Future<bool> verifyUserCredentials(String email, String password) async {
    try {
      final url = ApiConstants.USER_LOGIN;

      print("🔹 Sending login request to: $url");
      print("email: " + email);
      print("password: " + password);
      print("url: " + url);
      final response = await dio.post(
        url,
        data: {'email': email, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Extract JWT from response body (if available)
        String? token = data['token'];

        // Extract JWT from headers (if API sends in header)
        String? headerToken = response.headers.value('Authorization');

        // Determine which token to use
        String? finalToken = headerToken ?? token;

        if (finalToken != null) {
          await JwtService.saveToken(finalToken); // Save JWT securely
          print("✅ JWT Token saved successfully!");
        } else {
          print("❌ No token found in response!");
          return false;
        }

        // Store user data in controller
        Get.find<LoginController>().userData.value = data['data'];
        Get.find<LoginController>().userType.value = data['data']['userType'];

        return true;
      } else {
        print("❌ Login failed: ${response.statusCode} - ${response.data}");
        return false;
      }
    } catch (e) {
      print('❌ Error during login: $e');
      return false;
    }
  }

  /// **🔹 Logout Function**
  Future<void> logout() async {
    try {
      // Clear JWT Token
      await JwtService.deleteToken();

      // Reset user-related data
      userType.value = '';
      userData.clear();

      // Redirect user to Login Screen
      Get.offAll(() => const LoginScreen());

      print("✅ User logged out successfully!");
    } catch (e) {
      print("⚠️ Error during logout: $e");
    }
  }

  // /// **🔹 Logout Function**
  // void logout() async {
  //   await JwtService.deleteToken(); // Clear JWT token
  //   userType.value = ''; // Reset user type
  //   userData.value = {}; // Clear user data
  //
  //   Get.offAll(() => const LoginScreen()); // Navigate to home screen
  //   print("✅ User logged out successfully!");
  // }

  /// **🔹 Guest Login**
  void guestLogin() {
    userType.value = 'G';
    userData.value = {"userId": 0}; // Guest user default data

    Get.offAll(() => const NavigationMenu());
    print("✅ Guest login activated!");
  }
}

class StatusConstants {
  static const String USER_MS_LOGIN_CODE = '2004';
  static const String USER_MS_LOGIN_UNSUCCESSFUL_CODE = '2005';
}
