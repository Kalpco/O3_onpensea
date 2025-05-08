import 'package:onpensea/commons/styles/spacing_style.dart';
import 'package:onpensea/commons/widgets/login_signup/form_divider.dart';
import 'package:onpensea/commons/widgets/login_signup/social_buttons.dart';
import 'package:onpensea/features/authentication/screens/login/widgets/login_form.dart';
import 'package:onpensea/features/authentication/screens/login/widgets/login_header.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white,
          elevation: 4,
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: Padding(
            padding: C_SpacingStyle.paddingWithAppBarHeight,
            child: Column(
              children: [
                const LoginHeader(),

                const LoginForm(),

                // W_Divider(dark: dark),
                // const SizedBox(
                //   height: U_Sizes.spaceBwtSections,
                // ),

                ///footer
              //  const W_SocialButtons()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
