import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvestmentController {

  Future<InvestmentResponseModel?> getAllInvestments() async {
    var client = http.Client();
    var uri = Uri.parse(
        ApiConstants.INVESTMENTMS_URL!);

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      print(response.body);
      return investmentResponseModelFromJson(
          const Utf8Decoder().convert(response.bodyBytes));
    }
    return null;
  }

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
