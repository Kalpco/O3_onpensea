import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';

import '../../../network/dio_client.dart';

Future<double> fetchWalletAmount(int userId) async {
  try {
    final dio = DioClient.getInstance();
    final response = await dio.get('${ApiConstants.WALLET_BASE_URL}?userId=$userId');

    if (response.statusCode == 200) {
      final data = response.data;
      print("Wallet Details -: $data");
      return data['totalAmount'].toDouble();
    } else {
      throw Exception('Failed to load wallet amount');
    }
  } catch (e) {
    print("❌ Error fetching wallet amount: $e");
    throw Exception('Failed to load wallet amount');
  }
}

