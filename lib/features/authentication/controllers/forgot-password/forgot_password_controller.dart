import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';

class ForgotPasswordController {
  // PUT request (for updating)
  static Future<bool?> putRequest(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('${ApiConstants.AUTHENTICATION_URL}/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else if (response.statusCode == 400) {
      print(response.body);
      return false;
    }
  }
}
