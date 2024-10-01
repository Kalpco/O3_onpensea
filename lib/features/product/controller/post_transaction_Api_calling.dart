import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';

class TranactionOrderAPI {
  static String _baseUrl = '${ApiConstants.TRANSACTION_BASE_URL}';

  static Future<http.Response> postTransactionDetails(Map<String, dynamic> transactionDetails) async {
    final url = Uri.parse('$_baseUrl');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(transactionDetails), // Encode the body as JSON
      );
      print(jsonEncode(transactionDetails));
      return response;
    } catch (e) {
      print('Error posting payment details: $e');
      rethrow; // Rethrow to handle it in the calling method
    }
  }
}
