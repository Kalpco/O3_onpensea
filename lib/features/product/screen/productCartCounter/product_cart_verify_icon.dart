import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/enums.dart';
// import 'package:onpensea/utils/constants/product_brand_title_text.dart';
import 'package:onpensea/utils/constants/product_title.dart';
import 'package:onpensea/utils/constants/sizes.dart';

import '../productContainer/product_brand_title_text.dart';

class ProductCartVerifiedIcon extends StatelessWidget {
  const ProductCartVerifiedIcon({
    super.key,
    this.textColor,
    this.maxLines = 1,
    required this.title,
    this.iconColor=U_Colors.primaryColor,
    this.textAlign = TextAlign.center,
    this.brandTextSize = textSizes.small,
  });

  final String title;
  final int maxLines;
  final Color ? textColor, iconColor;
  final TextAlign? textAlign;
  final textSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: ProductBrandTitleText(
          title: title,
          color: textColor,
          maxLines: maxLines,
          textAlign: textAlign,
          brandTextSize : brandTextSize,

        ),),
        const SizedBox(width: U_Sizes.xs,),
        Icon(Iconsax.verify5,color: iconColor,size: U_Sizes.iconXs),
      ],
    );
  }
}