import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:onpensea/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //to remove the back arrow
        actions: [
          IconButton(
              onPressed: () => Get.back(), icon: Icon(CupertinoIcons.clear))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(U_Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image(
                image: AssetImage(U_ImagePath.delivered),
                width: U_Helper.getScreenWeight() * 0.6,
              ),
            ),
            SizedBox(
              height: U_Sizes.spaceBwtSections,
            ),

            //Title & SubTitle
            Center(
              child: Text(
                U_TextStrings.changeYourPasswordTitile,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: U_Sizes.spaceBtwItems,
            ),
            Text(
              U_TextStrings.changeYourPasswordSubTitile,
              style: Theme.of(context).textTheme.labelMedium,
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
                style: TextButton.styleFrom(backgroundColor: U_Colors.green),
                child: Text(U_TextStrings.done),
                onPressed: () => Get.to(() => const LoginScreen()),
              ),
            ),
            SizedBox(
              height: U_Sizes.spaceBtwItems,
            ),
            Center(
              child: TextButton(
                child: Text(U_TextStrings.resendEmail),
                onPressed: () => Get.to(() => const LoginScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
