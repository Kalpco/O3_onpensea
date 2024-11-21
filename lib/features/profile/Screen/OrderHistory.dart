import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:onpensea/features/authentication/screens/login/widgets/login_form.dart';
import 'package:onpensea/features/profile/Screen/orderDetails.dart';
import '../../../utils/constants/colors.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import '../../../utils/constants/api_constants.dart';
import 'package:onpensea/commons/config/api_constants.dart' as API_CONSTANTS_1;

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
          '${API_CONSTANTS_1.ApiConstants.TRANSACTION_MASTER_BASE_URL}/users/${loginController.userData['userId']}');

      if (response.statusCode == 200) {
        final data = response.data['transactionList'];
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
          'Do more shopping with us!',
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
            final product = transaction['productTransactionDTOList'][0];
            int userId = transaction['userId'];
            int transactionId = transaction['transactionId'];
            int? addressId = transaction['userAddressId'];
            final productList = transaction['productTransactionDTOList'];
            final imageUrl = "${ApiConstants.baseUrl}${product['productPic']}";
            print("my image $imageUrl");
            return _buildOrderCard(
              productName: product['productName'] ?? 'Unknown Product',
              price: '₹${product['totalAmount']?.toStringAsFixed(2)}',
              status: product['deliveryStatus'] ?? 'Pending',
              statusColor: product['deliveryStatus'] == 'Delivered'
                  ? Colors.green
                  : Colors.red,
              imageUrl: imageUrl,
              onCardTap: () {
                // Navigate to the next page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsPage(
                      productList: productList,
                      userId:userId,
                      transactionId:transactionId,
                      addressId:addressId// Pass transaction details
                    ),
                  ),
                );
              },
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
    required VoidCallback onCardTap,
  }) {
    return GestureDetector(
      onTap: onCardTap, // Navigate when the card is tapped
      child: Container(
        margin: EdgeInsets.only(bottom: 16.0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              // blurRadius: 10.0,
              spreadRadius: 1.0,
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
                // border: Border.all(color: Colors.grey),
                // borderRadius: BorderRadius.circular(8),
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
      ),
    );
  }
}
