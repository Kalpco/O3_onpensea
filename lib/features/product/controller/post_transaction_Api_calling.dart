import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/network/dio_client.dart';

class TranactionOrderAPI {

  static final String _baseUrl = ApiConstants.TRANSACTION_BASE_URL ?? '';

  /// **🔹 Post Transaction Details with JWT Authentication**
  static Future<Response> postTransactionDetails(Map<String, dynamic> transactionDetails) async {
    String url = _baseUrl; // Ensure correct API endpoint

    try {
      final dio = DioClient.getInstance(); // Get Dio instance with Interceptor

      final response = await dio.post(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'}, // JSON headers
        ),
        data: transactionDetails,
      );

      print("✅ Transaction Posted: ${response.data}");
      return response;
    } catch (e) {
      if (e is DioException) {
        print('Error posting payment details: ${e.response?.data}');
      } else {
        print('Unexpected error: $e');
      }
      rethrow; // Rethrow for handling in the calling method
    }
  }

  static Future<Response> postOtherPayment(Map<String, dynamic> transactionDetails, int userId) async {
    String url = "$_baseUrl/users/$userId/otherPayments"; // Ensure correct API endpoint
    print("api hitting: " + url);
    try {
      final dio = DioClient.getInstance(); // Get Dio instance with Interceptor

      final response = await dio.post(
        url,
        options: Options(
          headers: {'Content-Type': 'application/json'}, // JSON headers
        ),
        data: transactionDetails,
      );

      print("✅ Transaction Posted: ${response.data}");
      return response;
    } catch (e) {
      if (e is DioException) {
        print('Error posting payment details: ${e.response?.data}');
      } else {
        print('Unexpected error: $e');
      }
      rethrow; // Rethrow for handling in the calling method
    }
  }
}
