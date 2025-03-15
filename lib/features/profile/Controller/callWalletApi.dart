import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';
import 'dart:convert';

import '../../../network/dio_client.dart';
import '../Model/wrapperTransactionResponseDTO.dart';

class WalletApiService {
  final dio = DioClient.getInstance();

  Future<void> postWalletData(int userId, int investmentId) async {
    final String url = '${ApiConstants.WALLET_BASE_URL}?userId=$userId&investmentId=$investmentId';
    print('test -> ${url}');
    try {
      final response = await dio.post(
        url,
        options: Options(headers: {'Content-Type': 'application/json'}),
      );
      print('Response: ${response.data}');
      if (response.statusCode == 200) {
        // Success
        print('Response: ${response.data}');
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
    final String url = '${ApiConstants.WALLET_BASE_URL}?userId=$userId';
    print(url);
    try {
      final response = await dio.get(url, options: Options(headers: {'Content-Type': 'application/json'}),);
      print('test -> ${response.data}');
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> jsonResponse = response.data;

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
