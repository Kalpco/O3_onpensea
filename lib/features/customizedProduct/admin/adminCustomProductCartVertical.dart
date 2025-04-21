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

import '../../../navigation_menu.dart';
import '../../../network/dio_client.dart';
import '../models/customizedProductResponseDTO.dart';

class AdminCustomProductCartVertical extends StatelessWidget {
  AdminCustomProductCartVertical({super.key, required this.customProduct});

  CustomizedProductResponseDTO customProduct;

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);

    return GestureDetector(
      onTap: () {
        // Get.to(CustomProductDetail(customProduct: customProduct));
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
                      imageUrl:
                          "${ApiConstants.baseUrl}${customProduct.customizedImageUrl![0]}",
                      applyImageRadius: true),
                ],
              ),
            ),
            const SizedBox(
              height: U_Sizes.spaceBtwItems / 2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: U_Sizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProductTitleText(
                      title: customProduct.customizedImageCode!,
                      smallSize: true),
                  SizedBox(height: U_Sizes.spaceBtwItems / 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Confirm Deletion"),
                              content: const Text(
                                  "Are you sure you want to delete this product?"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context)
                                      .pop(), // Close dialog
                                  child: const Text("No"),
                                  style: ElevatedButton.styleFrom(backgroundColor: U_Colors.satinSheenGold),
                                ),
                                ElevatedButton(
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pop(); // Close dialog first
                                      await deleteProductApiCall(context);
                                    },
                                    child: const Text("Yes"),
                                  style: ElevatedButton.styleFrom(backgroundColor: U_Colors.yaleBlue),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: U_Colors.satinSheenGold,
                              borderRadius: BorderRadius.only(
                                  topLeft:
                                      Radius.circular(U_Sizes.cardRadiusMd),
                                  bottomRight: Radius.circular(
                                      U_Sizes.productImageRadius))),
                          child: const SizedBox(
                              width: U_Sizes.iconLg * 1.4,
                              height: U_Sizes.iconLg * 1.5,
                              child: Center(
                                  child: const Icon(
                                Icons.delete_forever_rounded,
                                color: U_Colors.whiteColor,
                              ))),
                        ),
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

  Future<void> deleteProductApiCall(BuildContext context) async {
    final dioClient = DioClient.getInstance();
    final String apiUrl =
        '${ApiConstants.baseUrl}/merchant/${customProduct.productOwnerId}/M/customized/${customProduct.id}';
    print('apiUrl:$apiUrl');

    try {
      final response = await dioClient.delete(apiUrl);
      print("Delete success: ${response.data}");
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Product has been deleted successfully'),
              backgroundColor: Colors.green),
        );
        Navigator.pop(context);
        Get.offAll(() => NavigationMenu());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete product')),
        );
      }
    } catch (e) {
      print("Delete failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
}
