import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/features/product/models/order_api_success.dart';
import 'package:onpensea/features/product/screen/productBottomBar/bottom_bar.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';

import '../../Home/widgets/DividerWithAvatar.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';


class OtherPaymentSuccessSummaryPage extends StatefulWidget {
  final String paymentId;
  final RazorpaySuccessResponseDTO order;

  const OtherPaymentSuccessSummaryPage({
    Key? key,
    required this.paymentId,
    required this.order,
  }) : super(key: key);

  @override
  _OtherPaymentSuccessSummaryPageState createState() =>
      _OtherPaymentSuccessSummaryPageState();
}

class _OtherPaymentSuccessSummaryPageState
    extends State<OtherPaymentSuccessSummaryPage> {
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    _sendOrderConfirmationMessage();
  }

  Future<void> _sendOrderConfirmationMessage() async {
    final userData = loginController.userData;
    final mobileNumber = userData['mobileNo'] ?? '';
    final orderId = widget.order.id;
    final paymentId = widget.paymentId;
    final totalAmount = widget.order.amount / 100;

    if (mobileNumber.isNotEmpty) {
      final userApiUrl =
          'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=Your%20payment%20with%20Kalpco%20has%20been%20received!%20Payment%20reference%20no%20is-$orderId.%20Thank%20you%20for%20your%20transaction.&sendername=KLPCOP&smstype=TRANS&numbers=$mobileNumber&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707171724181792368';
      final userResponse = await http.get(Uri.parse(userApiUrl));
      if (userResponse.statusCode == 200) {
        print('Confirmation SMS sent to user');
      }

      final adminApiUrl =
          'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=New%20payment%20received.%20Order%20ID:%20$orderId,%20Payment%20ID:%20$paymentId,%20Amount:%20Rs.%20$totalAmount.%20-Kalpco&sendername=KLPCOP&smstype=TRANS&numbers=9566234975&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707173753113649256';
      final adminResponse = await http.get(Uri.parse(adminApiUrl));
      if (adminResponse.statusCode == 200) {
        print('Confirmation SMS sent to admin');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = loginController.userData;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Payment Summary", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      bottomNavigationBar: BottomBar(),
      backgroundColor: U_Colors.whiteColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.2),
              padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(MediaQuery.of(context).size.width, 110.0),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
              child: Column(
                children: [
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2.4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Image.asset(U_ImagePath.productSuccess, height: 200, width: 200),
                          SizedBox(height: 10),
                          Text(
                            "Thank you for your payment \n        with Kalpco",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: U_Sizes.spaceBwtSections),
                  DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 400.0),
              child: Column(
                children: [
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 12),
                          Text("Order ID: ${widget.order.id}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("Payment ID: ${widget.paymentId}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("Name: ${userData['name'] ?? 'N/A'}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("Contact No: ${userData['mobileNo'] ?? 'N/A'}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text("Amount Paid: ₹${(widget.order.amount / 100).toStringAsFixed(2)}", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
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
