import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class U_CircularIcon extends StatelessWidget {
  const U_CircularIcon({
    super.key,
    this.icon,
    this.imagePath,
    this.width,
    this.height,
    this.size = U_Sizes.lg,
    this.onPressed,
    this.color,
    this.backgroundColor,
  });

  final double? width, height, size;
  final IconData? icon;
  final String? imagePath;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : U_Helper.isDarkMode(context)
            ? U_Colors.black.withOpacity(0.9)
            : U_Colors.whiteColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: imagePath != null
            ? Image.asset(imagePath!)
            : IconButton(
          onPressed: onPressed,
          icon: Icon(icon, color: color, size: size),
        ),
      ),
    );
  }
}
