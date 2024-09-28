import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/Home/Screens/HomeScreen.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/device/device_utility.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class U_AppBar extends StatelessWidget implements PreferredSizeWidget{
  const U_AppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = true,
  });
  final Widget?title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final List<Widget> ? actions;
  final VoidCallback? leadingOnPressed;

  @override
  Widget build(BuildContext context) {
   final dark = U_Helper.isDarkMode(context);
   return Padding(
    padding: const EdgeInsets.symmetric(horizontal:U_Sizes.md),
    child:AppBar(
      automaticallyImplyLeading:false,
      leading:showBackArrow 
      ? IconButton(onPressed:() => Get.to(() => HomeScreen()),icon: Icon(Iconsax.arrow_left, color: dark ? U_Colors.dark : U_Colors.whiteColor))
      :leadingIcon != null
      ?IconButton(onPressed: leadingOnPressed, icon: Icon(leadingIcon))
      :null,
    title: title,
    actions: actions,
    ),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(U_DeviceUtility.getAppBarHeight());
}