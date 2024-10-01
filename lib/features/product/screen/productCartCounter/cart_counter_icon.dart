import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/product/screen/productCartCounter/product_cart_screen.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class CartCounterIcon extends StatelessWidget {
  const CartCounterIcon({
    super.key, required this.onPressed, required this.counterBgColor,required this.counterTextColor, required this.iconColor,
  });
  final VoidCallback onPressed;
  final Color iconColor,counterBgColor,counterTextColor;

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
            onPressed: () => Get.to(() => ProductCartScreen()),
            icon:  Image.asset(
              'assets/logos/shopcart.png',
              height: 24,
              width: 24,
              color: U_Colors.chataccentColor,
            ),),
            // Positioned(
            //   right: 0,
            //   child: Container(
            //     width: 18,
            //     height: 18,
            //     decoration: BoxDecoration(
            //       color: counterBgColor ?? (dark ? U_Colors.whiteColor : U_Colors.black),
            //       borderRadius: BorderRadius.circular(100),
            //
            //     ),
            //     child: Center(
            //       child: Text('2',style: Theme.of(context).textTheme.labelLarge!.apply(color: U_Colors.whiteColor,fontSizeFactor: 0.8),),
            //     ),
            //
            //   ),
            // )
      ],
    );
  }
}