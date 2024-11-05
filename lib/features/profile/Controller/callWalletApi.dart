import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';
import 'dart:convert';

import '../Model/wrapperTransactionResponseDTO.dart';

class WalletApiService {
  Future<void> postWalletData(int userId, int investmentId) async {
    final url = Uri.parse(
        '${ApiConstants.WALLET_BASE_URL}?userId=$userId&investmentId=$investmentId');
    print('test -> ${url}');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        // Success
        print('Response: ${response.body}');
      } else {
        // Error handling
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // Exception handling
      print('Error: $e');
    }
  }

  Future<WalletTransactionWrapperDTO?> fetchWalletTransactions(
      int userId) async {
    final url = Uri.parse(
        '${ApiConstants.WALLET_BASE_URL}?userId=$userId');
    print(url);
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });
      print('test -> ${response.body}');
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        print("Json Response Wallet $jsonResponse");
        return WalletTransactionWrapperDTO.fromJson(jsonResponse);
      } else {
        // Error handling
        print('Failed with status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Exception handling
      print('Wallet Error: $e');
      return null;
    }
  }
}
