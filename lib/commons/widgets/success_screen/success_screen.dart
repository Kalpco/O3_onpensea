import 'package:onpensea/commons/styles/spacing_style.dart';
import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:onpensea/features/authentication/screens/signUp/verify_email.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SuccessScreen extends StatelessWidget {
  SuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: C_SpacingStyle.paddingWithAppBarHeight * 2,
        child: Column(
          children: [
            Image(
              image: AssetImage(U_ImagePath.success),
              width: U_Helper.getScreenWeight() * 0.6,
            ),
            SizedBox(
              height: U_Sizes.spaceBwtSections,
            ),

            //Title & SubTitle
            Text(
              U_TextStrings.yourAccountCreatedTitle,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: U_Sizes.spaceBtwItems,
            ),
            Text(
              U_TextStrings.yourAccountCreatedSubTitle,
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: U_Sizes.spaceBwtSections,
            ),

            //buttons
            SizedBox(
              height: U_Sizes.spaceBwtSections,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: TextButton.styleFrom(
                    side: BorderSide(color: U_Colors.yaleBlue),
                    backgroundColor: U_Colors.yaleBlue),
                child: Text(U_TextStrings.continueText),
                onPressed: () => Get.to(() => const LoginScreen()),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
