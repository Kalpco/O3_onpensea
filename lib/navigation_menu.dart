import 'dart:async';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/scheme/Screens/all_scheme_screen.dart';
import 'package:onpensea/utils/constants/colors.dart';

import 'features/Explore/ExploreScreen.dart';
import 'features/Home/Screens/HomeScreen.dart';
import 'features/authentication/screens/login/Controller/LoginController.dart';
import 'features/profile/Screen/profilePage.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  _NavigationMenuState createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  final navController = Get.put(NavigationController());
  final authController = Get.find<LoginController>();
  DateTime? lastBackPressed;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();
    if (lastBackPressed == null ||
        now.difference(lastBackPressed!) > Duration(seconds: 2)) {
      lastBackPressed = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Press back again to exit"),
          duration: Duration(seconds: 2),
        ),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: Obx(
              () {
            if (authController.userType.value == 'G') {
              // If user is a guest, show a simpler navigation bar with icons
              return CurvedNavigationBar(
                animationDuration: Duration(milliseconds: 400),
                backgroundColor: U_Colors.chataccentColor,
                color: U_Colors.chatprimaryColor,
                buttonBackgroundColor: U_Colors.chatprimaryColor,
                height: 48,
                index: navController.selectIndex.value,
                items: <Widget>[
                  Image.asset('assets/logos/home.png',
                      height: 20, width: 20, color: U_Colors.chataccentColor),
                  Image.asset('assets/logos/store.png',
                      height: 20, width: 20, color: U_Colors.chataccentColor),
                  Image.asset('assets/logos/offer.png',
                      height: 20, width: 20, color: U_Colors.chataccentColor),
                ],
                onTap: (index) {
                  navController.selectIndex.value = index;
                },
              );
            } else {
              // Regular user navigation bar with icons
              return CurvedNavigationBar(
                animationDuration: Duration(milliseconds: 400),
                backgroundColor: U_Colors.chataccentColor,
                color: U_Colors.chatprimaryColor,
                buttonBackgroundColor: U_Colors.chatprimaryColor,
                height: 50,
                index: navController.selectIndex.value,
                items: <Widget>[
                  Image.asset('assets/logos/home.png',
                      height: 20, width: 20, color: U_Colors.chataccentColor),
                  Image.asset('assets/logos/store.png',
                      height: 20, width: 20, color: U_Colors.chataccentColor),
                  Image.asset('assets/logos/offer.png',
                      height: 20, width: 20, color: U_Colors.chataccentColor),
                  Image.asset('assets/logos/user.png',
                      height: 20, width: 20, color: U_Colors.chataccentColor),
                ],
                onTap: (index) {
                  navController.selectIndex.value = index;
                },
              );
            }
          },
        ),
        body: Obx(() {
          if (authController.userType.value == 'G') {
            // Show only three screens for guest users
            return navController.guestScreens[navController.selectIndex.value];
          } else {
            // Show all screens for regular users
            return navController.screens[navController.selectIndex.value];
          }
        }),
      ),
    );
  }
}

class NavigationController extends GetxController {
  Rx<int> selectIndex = 0.obs;

  final screens = [
    HomeScreen(), // Custom Home screen widget
    ExploreScreen(),  // Shop screen
    AllSchemeScreen(), // Wishlist screen
    ProfilePage(),    // Profile screen
  ];

  final guestScreens = [
    HomeScreen(), // Custom Home screen widget for guest
    ExploreScreen(),  // Shop screen for guest
    AllSchemeScreen(), // Offers screen for guest
  ];
}
