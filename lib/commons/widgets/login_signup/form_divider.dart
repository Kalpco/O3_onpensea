import 'package:onpensea/commons/styles/spacing_style.dart';
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

class W_Divider extends StatelessWidget {
  const W_Divider({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? U_Colors.darkgrey : U_Colors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(U_TextStrings.orSingInWith.capitalize!,
            style: Theme.of(context).textTheme.labelMedium),
        Flexible(
          child: Divider(
            color: dark ? U_Colors.darkgrey : U_Colors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        )
      ],
    );
  }
}
