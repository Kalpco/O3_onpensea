import 'package:flutter/material.dart';
import 'package:onpensea/features/product/screen/productCartCounter/product_cart_verify_icon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
// import 'package:onpensea/utils/constants/product_cart_verified_icon.dart';
import 'package:onpensea/utils/constants/product_title.dart';
import 'package:onpensea/utils/constants/roundedImage.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class ProductCartItems extends StatelessWidget {
  const ProductCartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        U_RoundedImage(
          imageUrl: U_ImagePath.earings,
          width: 60,
          height: 60,
          padding: EdgeInsets.all(U_Sizes.sm),
          backgroundColor: U_Helper.isDarkMode(context) ? U_Colors.dark : U_Colors.light,
          ),
          const SizedBox(width: U_Sizes.spaceBtwItems),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              //title price
                ProductCartVerifiedIcon(title: 'Ring'),
                ProductTitleText(title: 'Ring for women',maxLines: 1,),
                //Attributes
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Size : ',style: Theme.of(context).textTheme.bodySmall),
                      TextSpan(text: '0.5',style: Theme.of(context).textTheme.bodyLarge)
            
                    ]
                  )
                )
              ],
            ),
          )
      ],
    );
  }
}