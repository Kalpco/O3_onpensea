import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:onpensea/utils/constants/sizes.dart';

import 'package:onpensea/utils/helper/helper_functions.dart';

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(U_Sizes.defaultSpace),
      child: Column(
        children: [
          Image(
              width: U_Helper.getScreenWeight() * 0.8,
              height: U_Helper.getScreenHeight() * 0.6,
              image: AssetImage(image)),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: U_Sizes.spaceBtwItems),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
