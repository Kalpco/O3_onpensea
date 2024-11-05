import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/screen/productHome/products_home_screen.dart';
import 'package:onpensea/navigation_menu.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

import '../../../Home/Screens/HomeScreen.dart';

class BottomBar extends StatelessWidget {
    BottomBar({
    super.key,
  });
 

  @override
  Widget build(BuildContext context) {
     final dark = U_Helper.isDarkMode(context);
   return Container(
    padding: const EdgeInsets.symmetric(horizontal: U_Sizes.defaultSpace,vertical: U_Sizes.defaultSpace / 2),
    decoration: BoxDecoration(
      color: dark ? U_Colors.dark : U_Colors.light,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(U_Sizes.cardRadiusLg),
        topRight: Radius.circular(U_Sizes.cardRadiusLg)
      ),
      
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            ElevatedButton(onPressed: (){
              Get.offAll(() => NavigationMenu());
        },style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(U_Sizes.iconXs),
          backgroundColor: U_Colors.yaleBlue,
          side: const BorderSide( color: U_Colors.black)), child: const Text('Continue Shopping'))
      ],
    ),
   );
  }
}

  