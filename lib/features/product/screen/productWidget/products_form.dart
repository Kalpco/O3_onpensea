import 'package:onpensea/commons/widgets/login_signup/form_divider.dart';
import 'package:onpensea/commons/widgets/login_signup/social_buttons.dart';
import 'package:onpensea/features/authentication/screens/signUp/verify_email.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProductsForm extends StatelessWidget {
  const ProductsForm({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Form(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: U_TextStrings.productName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              SizedBox(
                width: U_Sizes.inputFieldSpaceBtw,
              ),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: U_TextStrings.productDescription,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),

          //email
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: U_TextStrings.productOwnerName,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),

          //password
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: U_TextStrings.productCategory,
              prefixIcon: Icon(Iconsax.user),
              
            ),
          ),

          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),

          //phone
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: U_TextStrings.productWeight,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),

          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: U_TextStrings.productPrice,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: U_TextStrings.productQuantity,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),
          const SizedBox(
            height: U_Sizes.inputFieldSpaceBtw,
          ),
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: U_TextStrings.productOwnerType,
              prefixIcon: Icon(Iconsax.user),
            ),
          ),

          /// terms and condition
          
          const SizedBox(
            height: U_Sizes.spaceBwtSections,
          ),

          /// sign up button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style:
                  ElevatedButton.styleFrom(backgroundColor: U_Colors.yaleBlue),
              child: Text(U_TextStrings.upload),
              onPressed: () => Get.to(() => const VerifyEmailScreen()),
            ),
          )
        ],
      ),
    );
  }
}
