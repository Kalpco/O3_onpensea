import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/models/order_api_success.dart';
import 'package:onpensea/features/product/screen/productBottomBar/bottom_bar.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import '../../../../utils/constants/images_path.dart';
import '../../../Home/widgets/DividerWithAvatar.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';

class ProductOrderSuccessSummaryPage extends StatefulWidget {
  final String paymentId;
  final ProductResponseDTO product;
  final RazorpaySuccessResponseDTO order;

  ProductOrderSuccessSummaryPage({
    Key? key,
    required this.paymentId,
    required this.order,
    required this.product,
  }) : super(key: key);

  @override
  _ProductOrderSuccessSummaryPageState createState() => _ProductOrderSuccessSummaryPageState();
}

class _ProductOrderSuccessSummaryPageState extends State<ProductOrderSuccessSummaryPage> {
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

    if (mobileNumber.isNotEmpty) {
      final apiUrl =
          'http://sms.messageindia.in/v2/sendSMS?username=kalpco&message=Your%20order%20with%20Kalpco%20has%20been%20confirmed!%20Payment%20reference%20no%20is-$orderId.%20Your%20order%20will%20be%20delivered%20within%205%20working%20days.%20You%20can%20reach%20out%20us%20at%20our%20support%20no.%209566234975&sendername=KLPCOP&smstype=TRANS&numbers=$mobileNumber&apikey=dd7511bb-77f8-4e3a-8a45-e1d35bd44c9a&peid=1701171705702775945&templateid=1707171724181792368';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        print('Order confirmation message sent successfully');
      } else {
        print('Failed to send order confirmation message');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = loginController.userData;

    return Scaffold(
      bottomNavigationBar: BottomBar(),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
          ),
        ),
        centerTitle: true,
        title: Text("Order Summary", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: U_Colors.whiteColor,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              SizedBox(height: U_Sizes.spaceBwtSections),
              DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.2,
                ),
                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(MediaQuery.of(context).size.width, 110.0),
                    bottom: Radius.elliptical(MediaQuery.of(context).size.width, 110.0),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                child: Form(
                  child: Column(
                    children: [
                      Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.4,
                          decoration: BoxDecoration(
                            color: U_Colors.whiteColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Image.asset(
                                  U_ImagePath.productSuccess,
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                margin: EdgeInsets.symmetric(horizontal: 20.0),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Thank you, for shopping with \n                   Kalpco",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
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
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 400.0),
                child: Column(
                  children: [
                    Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: U_Colors.whiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Order Details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Order Id :                        ${widget.order.id}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Payment Id :" + widget.paymentId,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Shipping Details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Name  :                          ${userData['name'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Address :                       ${userData['address'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Contact no :                 ${userData['mobileNo'] ?? 'N/A'}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 780.0),
                child: Column(
                  children: [
                    Material(
                      elevation: 3.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4.5,
                        decoration: BoxDecoration(
                          color: U_Colors.whiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Payment Details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Total Amount :     " + (widget.order.amount / 100).toStringAsFixed(2),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: U_Sizes.spaceBwtSections),
              DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
            ],
          ),
        ),
      ),
    );
  }
}
