import 'package:onpensea/commons/widgets/login_signup/form_divider.dart';
import 'package:onpensea/commons/widgets/login_signup/social_buttons.dart';
import 'package:onpensea/features/authentication/screens/signUp/signupWidgets/signup_form.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Image(
                height: 100,
                image: AssetImage(U_ImagePath.kalpcoLogo),
                width: 150,
              ),
            ),
            SizedBox(height: 10,),

            /// Title

            Center(
              child: Text(
                U_TextStrings.signUpTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: U_Sizes.spaceBwtSections),

            ///form

            SignUpForm(dark: dark),

            const SizedBox(
              height: U_Sizes.spaceBtwItems,
            ),

            /// Divider
            // W_Divider(dark: dark),

            // const SizedBox(
            //   height: U_Sizes.spaceBwtSections,
            // ),

            /// social buttons
            // const W_SocialButtons()
          ],
        ),
      ),
    );
  }
}
