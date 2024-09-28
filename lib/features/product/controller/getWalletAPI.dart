import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';

Future<double> fetchWalletAmount(int userId) async {
  final url = Uri.parse('${ApiConstants.WALLET_BASE_URL}?userId=${userId}');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print("Wallet Details -: $data");
    return data['totalAmount'].toDouble();
  } else {
    throw Exception('Failed to load wallet amount');
  }
}
