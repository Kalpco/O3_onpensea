import 'package:flutter/material.dart';

import '../product/controller/post_transaction_Api_calling.dart';
import 'Widgets/page_exp_controller.dart';

class PageExp extends StatefulWidget {
  const PageExp({super.key});

  @override
  State<PageExp> createState() => _PageExp();
}

class _PageExp extends State<PageExp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Confirmation'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ElevatedButton(
            onPressed: _postTransactionDetails, // Pass the method reference here
            child: const Text('Post Transaction'), // Provide a child for the button
          ),
        ),
      ),
    );
  }

  void _postTransactionDetails() async {
    try {
      final transactionDetails = {
        'payementGatewayTransctionId': "987654323456",
        'productId': 23456765432,
        'isActive': 'YES',
        'transactionStatus': 'OK',
        'totalPrice': 121111111111,
        'weight': 766,
        'productPicFillePath': '/path',
        'merchantId': '2456543423143546565',
        'orderId': '23456352413'
      };
      print('Transaction Details: $transactionDetails');

      final response = await TranactionOrderAPI.postTransactionDetails(transactionDetails);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.data}');

      if (response.statusCode == 200) {
        print('Transaction posted successfully');
      } else {
        print('Failed to post transaction');
      }
    } catch (e) {
      print('Error posting payment details: $e');
    }
  }
}