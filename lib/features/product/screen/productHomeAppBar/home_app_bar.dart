import 'package:flutter/material.dart';
import 'package:onpensea/features/product/screen/productCartCounter/cart_counter_icon.dart';
import 'package:onpensea/utils/constants/appBar.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/text_strings.dart';

class ProductHomeAppBar extends StatelessWidget {
  final String title;

  const ProductHomeAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return U_AppBar(

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   // title,
          //   // style: Theme.of(context).textTheme.labelMedium!.apply(color: U_Colors.light),
          // ),
          Text(
              title,
            // U_TextStrings.homeAppBarSubTitle,
            style: Theme.of(context).textTheme.headlineSmall!.apply(color: U_Colors.whiteColor),
          ),
        ],
      ),
      actions: [
        CartCounterIcon(
          onPressed: () {},
          iconColor: U_Colors.whiteColor,
          counterBgColor: U_Colors.black,
          counterTextColor: U_Colors.whiteColor,
        ),
      ],
    );
  }
}
