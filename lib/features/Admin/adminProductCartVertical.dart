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

import 'adminGetProductScreen.dart';

class AdminProductCartVertical extends StatelessWidget {

  AdminProductCartVertical({super.key, required this.product});

  ProductResponseDTO product;
  

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
   final String prodPrice = product.productPrice!.toStringAsFixed(2);
  
    return GestureDetector(
      onTap: () {
        Get.to(AdminProductDetail(product: product));
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
                      imageUrl: "${ApiConstants.baseUrl}${product.productImageUri![0]}", applyImageRadius: true),
                  //favourite icon
                  // Positioned(
                  //     top: 0,
                  //     right: 0,
                  //     child: const U_CircularIcon(
                  //       imagePath: 'assets/gold/wishlist.png',
                  //       width: 25.0,
                  //       height: 25.0,
                  //     )
                  // )
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
                      title: product.productName!, smallSize: true),
                  SizedBox(height: U_Sizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      Text(
                        "Purity: ${product.purity!.toString()} K",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(width: U_Sizes.xs),
                      const Icon(
                        Iconsax.verify5,
                        color: U_Colors.primaryColor,
                        size: U_Sizes.iconXs,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ProductPrice(price: prodPrice),
                      Container(
                        decoration: const BoxDecoration(
                            color: U_Colors.satinSheenGold,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(U_Sizes.cardRadiusMd),
                                bottomRight: Radius.circular(
                                    U_Sizes.productImageRadius))),
                        child: const SizedBox(
                            width: U_Sizes.iconLg * 1.2,
                            height: U_Sizes.iconLg * 1.2,
                            child: Center(
                                child: const Icon(
                              Iconsax.add,
                              color: U_Colors.whiteColor,
                            ))),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
