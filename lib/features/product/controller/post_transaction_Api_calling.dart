import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';

import '../../../network/dio_client.dart';

class TranactionOrderAPI {
  static String _baseUrl = '${ApiConstants.TRANSACTION_BASE_URL}';

  static Future<Response> postTransactionDetails(Map<String, dynamic> transactionDetails) async {
    try {
      final dio = DioClient.getInstance();
      final response = await dio.post(
        _baseUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: transactionDetails,  // Encode the body as JSON
      );
      print(jsonEncode(transactionDetails));
      return response;
    } catch (e) {
      print('Error posting payment details: $e');
      rethrow; // Rethrow to handle it in the calling method
    }
  }
}
