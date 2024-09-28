import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/product/apiService/paymentOrderAPI.dart';
import 'package:onpensea/features/product/controller/post_transaction_Api_calling.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/models/razorpay_failure_response.dart';

import 'package:onpensea/features/product/screen/bottom_add_to_cart.dart';
import 'package:onpensea/features/product/screen/curvedEdgesWidget.dart';
import 'package:onpensea/features/product/screen/productExpandTile/product_Dropdown_Size.dart';
import 'package:onpensea/features/product/screen/productExpandTile/product_Price_Expand_Tile.dart';
import 'package:onpensea/features/product/screen/productHome/product_Fail_Page.dart';
import 'package:onpensea/features/product/screen/productHome/product_Success_page.dart';
import 'package:onpensea/features/product/screen/product_expand-tile.dart';
import 'package:onpensea/features/product/screen/product_image_slider.dart';
import 'package:onpensea/features/product/screen/product_metadata.dart';
import 'package:onpensea/features/product/screen/product_specification.dart';
import 'package:onpensea/features/product/screen/rating_n_share.dart';
import 'package:onpensea/utils/constants/appBar.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/product_title.dart';
import 'package:onpensea/utils/constants/roundedImage.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:onpensea/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:readmore/readmore.dart';

import '../../../utils/constants/api_constants.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';

import '../apiService/capturePaymentAPI.dart';
import '../models/capture_payment_success.dart';
import '../models/order_api_success.dart';
import 'CheckoutScreen/CheckoutScreen.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail({super.key, required this.product});

  ProductResponseDTO product;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Scaffold(
        bottomNavigationBar: BottomAddToCart(product: widget.product),
        body: SingleChildScrollView(
          child: Column(children: [
            // 1. product Image Slider
            ProductImageSlider(product: widget.product),
            // 2. product details
            Padding(
              padding: const EdgeInsets.only(
                  right: U_Sizes.defaultSpace,
                  left: U_Sizes.defaultSpace,
                  bottom: U_Sizes.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //rating
                  const RatingnShare(),
                  //price title
                  ProductMetaData(product: widget.product),
                  // const SizedBox(height: U_Sizes.spaceBwtSections),
                  //product description
                  const SizedBox(height: U_Sizes.spaceBtwItems),
                  // const ProductSizeDropdown(),
                  const SizedBox(height: U_Sizes.spaceBtwItems),

                  // const ProductTitleText(title: 'Product Details',smallSize:false),
                  Text('Product Details',
                      style: Theme.of(context).textTheme.titleMedium),

                  ReadMoreText(
                    widget.product.productDescription!,
                    trimLines: 1,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  Divider(),
                  //  const ProductTitleText(title: 'Product Specifications',smallSize:false),
                  // Text('Product Specifications',style: Theme.of(context).textTheme.titleMedium),

                  //product detail
                  // const ProductSpecification(),

                  ProductExpandTile(product: widget.product),
                  Divider(),
                  ProductPriceExpandTile(product: widget.product),

// Inside the build method of ProductDetail
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   CheckoutScreen(product: widget.product)),
//                         );
//                       },
//                       child: const Text('Buy Now'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: U_Colors.satinSheenGold,
//                       ),
//                     ),
//                   ),
                ],
              ),
            )
          ]),
        ));
  }
}
