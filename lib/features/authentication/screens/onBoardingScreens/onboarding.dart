import 'package:onpensea/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/onboarding_navigation_widget.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/onboarding_next_widget.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/onboarding_widget.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/OnBoardingWidgets/skipbutton_widget.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/device/device_utility.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      body: Stack(
        children: [
          // horizontal scrollable page
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingWidget(
                image: U_ImagePath.screen1,
                title: U_TextStrings.onBoardScreenText1,
                subTitle: U_TextStrings.onBoardScreenSubTitile1,
              ),
              OnBoardingWidget(
                image: U_ImagePath.screen2,
                title: U_TextStrings.onBoardScreenText2,
                subTitle: U_TextStrings.onBoardScreenSubTitile2,
              ),
              OnBoardingWidget(
                image: U_ImagePath.screen3,
                title: U_TextStrings.onBoardScreenText3,
                subTitle: U_TextStrings.onBoardScreenSubTitile3,
              ),
            ],
          ),

          const SkipButtonWidget(),
          // skip button

          //dot navigator for smooth page indicator
          OnBoardingNavigation(),

          // circular button

          OnBoardingNextButton(),
        ],
      ),
    );
  }
}
