import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/Home/Screens/HomeScreen.dart';
import 'package:onpensea/features/product/screen/productCartCounter/product_cart_screen.dart';
import 'package:onpensea/navigation_menu.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class CartHomeAppBar extends StatelessWidget {
  const CartHomeAppBar({
    super.key, required this.onPressed, required this.counterTextColor, required this.iconColor,
  });
  final VoidCallback onPressed;
  final Color iconColor,counterTextColor;

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
          color: U_Colors.whiteColor,
          onPressed: () {
            Navigator.pop(context);
          },
          icon:  Row(
            children: [
              SizedBox(width: 5), // Add some space between the icon and the text
              Text(
                "back",
                style: TextStyle(
                  color: U_Colors.whiteColor,
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}