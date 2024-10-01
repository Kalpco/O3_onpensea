import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/device/device_utility.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class ProductSearchContainer extends StatelessWidget {
  const ProductSearchContainer({
    super.key, required this.text, this.icon = Iconsax.search_normal,  this.showBackground=true,  this.showBorder = true, this.onTap,
  });

  final String text;
  final IconData ? icon;
  final bool showBackground,showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: U_Sizes.buttonHeight),
        child: Container(
          width: U_DeviceUtility.getScreenWidth(context),
          padding: EdgeInsets.all(U_Sizes.cardRadiusMd),
          decoration: BoxDecoration(
            color:showBackground ? dark ? U_Colors.dark:U_Colors.light : Colors.transparent,
            borderRadius: BorderRadius.circular(U_Sizes.cardRadiusLg),
            border: showBorder ? Border.all(color: U_Colors.grey):null,
          ),
          child: Row(
            children: [
              Icon(icon,color: U_Colors.darkgrey,),
              const SizedBox(width: U_Sizes.spaceBtwItems,),
              Text(text,style: Theme.of(context).textTheme.bodySmall,)
            ],
          ),
        ),
      ),
    );
  }
}