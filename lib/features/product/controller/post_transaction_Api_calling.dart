import 'dart:convert';
import 'package:http/http.dart' as http;

class TranactionOrderAPI {
  static const String _baseUrl = 'http://103.108.12.222:11001/kalpco/v1.0.0';

  static Future<http.Response> postTransactionDetails(Map<String, dynamic> transactionDetails) async {
    final url = Uri.parse('$_baseUrl/transactions');

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
