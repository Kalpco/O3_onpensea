import 'package:onpensea/commons/styles/spacing_style.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image(
            height: 100,
            image: AssetImage(U_ImagePath.kalpcoLogo),
          ),
        ),
        Center(
          heightFactor: 2,
          child: Text('KALPCO',
              style: TextStyle(color: U_Colors.yaleBlue,fontSize: 24,fontWeight: FontWeight.bold)),
        ),
        Center(
          child: Text(U_TextStrings.loginSubTitle,
              style: TextStyle(color: Colors.black)),
        )
      ],
    );
  }
}
