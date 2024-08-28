import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class ProductQuantityWithButton extends StatelessWidget {
  const ProductQuantityWithButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        U_CircularIcon(icon: Iconsax.minus,width: 32,height: 32,size: U_Sizes.md,color: U_Helper.isDarkMode(context) ? U_Colors.black : U_Colors.whiteColor,backgroundColor:  U_Colors.yaleBlue),
        SizedBox(width: U_Sizes.spaceBtwItems),
        Text('2',style: Theme.of(context).textTheme.titleSmall),
        SizedBox(width: U_Sizes.spaceBtwItems),
        U_CircularIcon(icon: Iconsax.add,width: 32,height: 32,size: U_Sizes.md,color:  U_Colors.whiteColor ,backgroundColor: U_Colors.satinSheenGold),
      ],
    );
  }
}