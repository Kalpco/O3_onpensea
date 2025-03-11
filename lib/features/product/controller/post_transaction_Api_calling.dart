import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/network/dio_client.dart';

class TranactionOrderAPI {

  static final String _baseUrl = ApiConstants.TRANSACTION_BASE_URL ?? '';

  /// **🔹 Post Transaction Details with JWT Authentication**
  static Future<Response> postTransactionDetails(Map<String, dynamic> transactionDetails) async {
    final String url = _baseUrl; // Ensure correct API endpoint

    print("transaction: $_baseUrl");

    try {
      Dio dio = DioClient.getInstance(); // Get Dio instance with Interceptor

      final response = await dio.post(
        url,
        data: jsonEncode(transactionDetails), // Encode the body as JSON
        options: Options(
          headers: {'Content-Type': 'application/json'}, // JSON headers
        ),
      );

      print("✅ Transaction Posted: ${response.data}");
      return response;
    } catch (e) {
      print("❌ Error posting transaction details: $e");
      rethrow; // Rethrow for handling in the calling method
    }
  }
}
