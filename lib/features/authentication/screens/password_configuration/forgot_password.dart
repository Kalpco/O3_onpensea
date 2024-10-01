import 'package:onpensea/features/authentication/screens/password_configuration/reset_password.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(U_Sizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///HEADINGS
            Text(
              U_TextStrings.forgotPasswordTitle,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: U_Sizes.spaceBtwItems,
            ),
            Text(
              U_TextStrings.forgotPasswordSubTitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(
              height: U_Sizes.spaceBtwItems * 2,
            ),

            ///TEXT FIELD
            TextFormField(
              decoration: InputDecoration(
                  labelText: U_TextStrings.email,
                  prefixIcon: Icon(Iconsax.direct_right)),
            ),
            SizedBox(
              height: U_Sizes.spaceBwtSections,
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.off(() => ResetPasswordScreen()),
                  child: Text(U_TextStrings.submit),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: U_Colors.green),
                ))

            ///BUTTONS
          ],
        ),
      ),
    );
  }
}
