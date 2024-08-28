import 'package:onpensea/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/onboarding_navigation_widget.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/onboarding_widget.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/skipbutton_widget.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/device/device_utility.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: U_Sizes.defaultSpace - 10,
        bottom: U_DeviceUtility.getBottomNavigationBarHeihgt() + 25,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: U_Colors.yaleBlue, shape: CircleBorder()),
          onPressed: () => OnboardingController.instance.nextPage(),
          child: const Icon(
            Iconsax.arrow_right_4,
            color: Colors.white,
          ),
        ));
  }
}
