import 'package:dio/dio.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../network/dio_client.dart';

class InvestmentController {

  /// **🔹 Fetch All Investments (GET Request with UTF-8 Decoding)**
  Future<InvestmentResponseModel?> getAllInvestments() async {
    try {
      final response = await DioClient.getInstance().get(
        ApiConstants.INVESTMENTMS_URL!,
        options: Options(responseType: ResponseType.bytes), // Ensure response as raw bytes
      );

      if (response.statusCode == 200) {
        print("✅ Investments Fetched Successfully");

        // Convert raw bytes to UTF-8 String safely
        String utf8DecodedBody = utf8.decode(response.data, allowMalformed: true);

        return investmentResponseModelFromJson(utf8DecodedBody);
      }
    } catch (e) {
      print('❌ Error fetching investments: $e');
    }
    return null;
  }


  // Future<InvestmentResponseModel?> getAllInvestments() async {
  //   var client = http.Client();
  //   var uri = Uri.parse(
  //       ApiConstants.INVESTMENTMS_URL!);
  //
  //   var response = await client.get(uri);
  //
  //   if (response.statusCode == 200) {
  //     print(response.body);
  //     return investmentResponseModelFromJson(
  //         const Utf8Decoder().convert(response.bodyBytes));
  //   }
  //   return null;
  // }

  static Future<http.Response> postInvestmentHistoryDetails(
      Map<String, dynamic> investmentHistoryDetails) async {
    final url = Uri.parse('${ApiConstants.INVESTMENTMS_URL!}/transaction-history');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(investmentHistoryDetails), // Encode the body as JSON
      );
      print(jsonEncode(investmentHistoryDetails));
      return response;
    } catch (e) {
      print('Error posting payment details: $e');
      rethrow; // Rethrow to handle it in the calling method
    }
  }
}
