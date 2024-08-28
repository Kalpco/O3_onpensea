import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordController {
  // PUT request (for updating)
  static Future<bool?> putRequest(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('http://103.108.12.222:11000/kalpco/version/v0.01/forgot-password'),
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
