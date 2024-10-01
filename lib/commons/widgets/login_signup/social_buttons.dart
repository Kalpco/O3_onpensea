import 'package:onpensea/commons/styles/spacing_style.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class W_SocialButtons extends StatelessWidget {
  const W_SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: U_Colors.grey),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Image(
            image: AssetImage(U_ImagePath.google),
            width: U_Sizes.iconMd,
            height: U_Sizes.iconMd,
          ),
        ),
        const SizedBox(
          width: U_Sizes.spaceBtwItems,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Image(
            image: AssetImage(U_ImagePath.facebook),
            width: U_Sizes.iconMd,
            height: U_Sizes.iconMd,
          ),
        )
      ],
    );
  }
}
