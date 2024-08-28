import 'package:onpensea/commons/widgets/success_screen/success_screen.dart';
import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //remove the back arrow
        automaticallyImplyLeading: false,
        actions: [
          //this is for the cross button when the cross button is pressed user is re-directed to the login screen
          IconButton(
              onPressed: () => Get.offAll(const LoginScreen()),
              icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(U_Sizes.defaultSpace),
          child: Column(
            children: [
              //Image
              Image(
                image: AssetImage(U_ImagePath.verify_email),
                width: U_Helper.getScreenWeight() * 0.6,
              ),
              SizedBox(
                height: U_Sizes.spaceBwtSections,
              ),

              //Title & SubTitle
              Text(
                U_TextStrings.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: U_Sizes.spaceBtwItems,
              ),
              Text(
                U_TextStrings.confirmEmailSubtitle,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: U_Sizes.spaceBwtSections,
              ),

              //Buttons

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: U_Colors.satinSheenGold),
                        backgroundColor: U_Colors.satinSheenGold),
                    child: Text(U_TextStrings.continueText),
                    onPressed: () => Get.to(
                          () => SuccessScreen(),
                        )),
              ),

              SizedBox(
                height: U_Sizes.spaceBwtSections,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  //  style:
                  //TextButton.styleFrom(backgroundColor: U_Colors.darkGreen),
                  child: Text(U_TextStrings.resendEmail),
                  onPressed: () => Get.to(() => const VerifyEmailScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
