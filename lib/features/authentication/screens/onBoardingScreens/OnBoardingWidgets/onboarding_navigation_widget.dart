import 'package:onpensea/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/onboarding_widget.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/skipbutton_widget.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/device/device_utility.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingNavigation extends StatelessWidget {
  const OnBoardingNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return Positioned(
        bottom: U_DeviceUtility.getBottomNavigationBarHeihgt() + 25,
        left: U_Sizes.defaultSpace,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          count: 3,
          onDotClicked: controller.dotNavigationClick,
          effect: const JumpingDotEffect(
              activeDotColor: Color(0x001D3D),
              dotHeight: 16,
              verticalOffset: 10),
        ));
  }
}
