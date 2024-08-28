import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../utils/constants/colors.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import '../../../utils/constants/api_constants.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final loginController = Get.find<LoginController>();
  final Dio _dio = Dio();
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchOrderHistory();
  }

  Future<void> _fetchOrderHistory() async {
    try {
      final response = await _dio.get(
          'http://103.108.12.222:11001/kalpco/v1.0.0/transactions/users/${loginController.userData['userId']}');

      if (response.statusCode == 200) {
        final data = response.data['productTransactionDTOList'];
        setState(() {
          transactions = List<Map<String, dynamic>>.from(data);
        });
      } else {
        // Handle error response
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch order history'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${loginController.userData['name'] != null ? "${loginController.userData['name']}'s" : 'Guest'} Order History",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: transactions.isEmpty
          ? Center(
        child: Text(
          'Do more shopping!',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            final imageUrl = "${ApiConstants.baseUrl}${transaction['productPic']}";
            return _buildOrderCard(
              productName: transaction['productName'] ?? 'Unknown Product',
              price: '₹${transaction['totalAmount']?.toStringAsFixed(2)}',
              status: transaction['deliveryStatus'] ?? 'Pending',
              statusColor: transaction['deliveryStatus'] == 'Delivered'
                  ? Colors.green
                  : Colors.red,
              imageUrl: imageUrl,
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String productName,
    required String price,
    required String status,
    required Color statusColor,
    required String imageUrl,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 2.0,
            offset: Offset(2.0, 2.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.error, color: Colors.red, size: 50);
                },
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  price,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  status,
                  style: TextStyle(fontSize: 14, color: statusColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
