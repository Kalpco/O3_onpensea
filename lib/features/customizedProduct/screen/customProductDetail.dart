import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/Admin/adminEditProduct.dart';
import 'package:onpensea/features/product/apiService/paymentOrderAPI.dart';
import 'package:onpensea/features/product/controller/post_transaction_Api_calling.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/models/razorpay_failure_response.dart';

import 'package:onpensea/features/product/screen/bottom_add_to_cart.dart';

import 'package:onpensea/features/product/screen/product_image_slider.dart';

import 'package:onpensea/utils/helper/helper_functions.dart';


import '../../../utils/constants/api_constants.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import '../models/customizedProductResponseDTO.dart';
import 'bottomNavigationBarText.dart';
import 'customProductImageSlider.dart';


class CustomProductDetail extends StatefulWidget {
  CustomProductDetail({super.key, required this.customProduct});

  CustomizedProductResponseDTO customProduct;

  @override
  State<CustomProductDetail> createState() => _CustomProductDetailState();
}

class _CustomProductDetailState extends State<CustomProductDetail> {
  String? userType;
  final loginController = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();
    getUserType();
  }

  void getUserType() {
    userType = loginController.userData['userType'];
    print("userType:$userType");
  }



  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Scaffold(
        bottomNavigationBar: Bottomnavigationbartext("Ready to own pure elegance? Buy gold now and shine forever! Contact us for personalized assistance: +919987734001 "),
        body: SingleChildScrollView(
          child: Column(children: [
            // 1. product Image Slider
            CustomProductImageSlider(customProduct: widget.customProduct),
            // 2. product details

          ]),
        ));
  }
}
