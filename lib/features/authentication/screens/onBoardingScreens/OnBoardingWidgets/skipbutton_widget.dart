import 'package:onpensea/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/device/device_utility.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class SkipButtonWidget extends StatelessWidget {
  const SkipButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: U_DeviceUtility.getAppBarHeight(),
      right: U_Sizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnboardingController.instance.skipPage(),
        child: const Text('Skip'),
      ),
    );
  }
}
