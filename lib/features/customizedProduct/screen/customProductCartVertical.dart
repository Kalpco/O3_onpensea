import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/screen/getProductScreen.dart';
import 'package:onpensea/features/product/screen/productWidget/product_shadow_style.dart';
import 'package:onpensea/utils/constants/api_constants.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/product_price.dart';
import 'package:onpensea/utils/constants/product_title.dart';
import 'package:onpensea/utils/constants/roundedImage.dart';
import 'package:onpensea/utils/constants/rounded_container.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

import '../models/customizedProductResponseDTO.dart';
import 'customProductDetail.dart';

class CustomProductCartVertical extends StatelessWidget {

  CustomProductCartVertical({super.key, required this.customProduct});

  CustomizedProductResponseDTO customProduct;


  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        Get.to(CustomProductDetail(customProduct: customProduct));
        //  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ProductDetail(product : product)))
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
            boxShadow: [ProductShadowStyle.verticalProductShadow],
            borderRadius: BorderRadius.circular(U_Sizes.productImageRadius),
            color: dark ? U_Colors.darkgrey : U_Colors.whiteColor),
        child: Column(
          children: [
            RoundedContainer(
              height: 180,
              padding: const EdgeInsets.all(U_Sizes.sm),
              backgroundColor: dark ? U_Colors.dark : U_Colors.whiteColor,
              child: Stack(
                children: [
                  //image
                  U_RoundedImage(
                      imageUrl: "${ApiConstants.baseUrl}${customProduct.customizedImageUrl![0]}", applyImageRadius: true),
                ],
              ),
            ),
            const SizedBox(
              height: U_Sizes.spaceBtwItems / 2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: U_Sizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductTitleText(
                      title: customProduct.customizedImageCode!, smallSize: true),
                  SizedBox(height: U_Sizes.spaceBtwItems / 2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
