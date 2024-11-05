import 'dart:convert';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';
import '../../../../authentication/screens/login/Controller/LoginController.dart';
import '../model/gold_price_model.dart';
import '../model/transaction_model.dart';
import '../model/users_details_model.dart'; // Import the user details model
import 'package:onpensea/commons/config/api_constants.dart';

class DigiGoldService {

  final loginController = Get.put(LoginController());

  final baseUrl = ApiConstants.DIGIGOLD_BASE_URL;

  Future<bool> submitTransaction(Map<String, dynamic> dto) async {
    final url = Uri.parse('$baseUrl/vaults');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(dto),
      );
      if (response.statusCode == 201) {

        return true;
      } else {
        print('Failed to create transaction: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<GoldPriceModel?> fetchGoldPrice() async {
    final url = Uri.parse('$baseUrl/gold-price');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("data: ${data['payload']}");
        return GoldPriceModel.fromJson(data['payload']);
      } else {
        print('Failed to load gold price');
        return null;
      }
    } catch (e) {
      print('Error fetching gold price: $e');
      return null;
    }
  }


  Future<List<TransactionModel>> fetchTransactions() async {
    int userId = loginController.userData['userId'];

    final url = Uri.parse('$baseUrl/vaults/users/$userId');
    print("fetching transaction of: $userId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print("success");
        final data = json.decode(response.body);
        return (data['payload'] as List)
            .map((transaction) => TransactionModel.fromJson(transaction))
            .toList();
      } else {
        print('Failed to load transactions');
        return [];
      }
    } catch (e) {
      print('Error fetching transactions: $e');
      return [];
    }
  }

  Future<UserDetailsModel?> fetchUserDetails() async {
    String userId = loginController.userData['userId'].toString();
    final url = Uri.parse('$baseUrl/master-vaults/users/$userId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserDetailsModel.fromJson(data['payload']);
      } else {
        print('Failed to load user details');
        return null; // Return null if API response is not 200
      }
    } catch (e) {
      print('Error fetching users details: $e');
      return null; // Return null if an exception occurs
    }
  }

}
