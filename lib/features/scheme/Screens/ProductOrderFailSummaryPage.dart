import 'package:flutter/material.dart';
import 'package:onpensea/features/scheme/Screens/widgets/BottomBar.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';

import '../../Home/widgets/DividerWithAvatar.dart';
import '../../product/models/order_api_success.dart';




class ProductOrderFailSummaryPage extends StatelessWidget {
  String message;
  RazorpaySuccessResponseDTO order;

  ProductOrderFailSummaryPage(
      {super.key, required this.message, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(userType: 'scheme',),
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              // color: Color.fromRGBO(98, 40, 215, 1),
            )),
        centerTitle: true,
        title: Text("Order Summary",
            style: TextStyle(fontWeight: FontWeight.bold)),
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
                    top: MediaQuery.of(context).size.height / 2.2),
                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.white, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    borderRadius: BorderRadius.vertical(
                        top: Radius.elliptical(
                            MediaQuery.of(context).size.width, 110.0),
                        bottom: Radius.elliptical(
                            MediaQuery.of(context).size.width, 110.0))),
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
                        height: MediaQuery.of(context).size.height / 2.3,
                        decoration: BoxDecoration(
                          color: U_Colors.whiteColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 10.0, top: 5.0, bottom: 5.0),
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              // decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(150),
                              //     border: Border.all(
                              //         color: Colors.green)),
                              child: Image.asset(
                                U_ImagePath.productFail,
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
                                "Sorry, your transaction is failed Kalpco",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: U_Sizes.spaceBwtSections),
                    DividerWithAvatar(
                        imagePath: 'assets/logos/KALPCO_splash.png'),
                  ],
                )),
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
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Order Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Order Id :                        ${order.id}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Message :" + message,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Shipping Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Name  :                          Satyam",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Address :                       Kalamboli",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                                // Container(
                                //   padding: EdgeInsets.symmetric(vertical: 12.0),
                                //   margin:
                                //       EdgeInsets.symmetric(horizontal: 20.0),
                                //   width: MediaQuery.of(context).size.width,
                                //   child: Text(
                                //     "Contact no :                 9167731955",
                                //     style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 15),
                                //   ),
                                // ),
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
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Payment Details",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "Total Amount :     " +
                                        order.amount.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
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
