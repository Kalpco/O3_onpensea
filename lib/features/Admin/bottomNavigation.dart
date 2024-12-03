import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:onpensea/features/Admin/adminHomeScreen.dart';
import 'package:onpensea/features/Admin/dashboard.dart';
import 'package:onpensea/features/Admin/misc.dart';
import 'package:onpensea/features/Admin/setting.dart';
import 'package:onpensea/features/Home/Screens/HomeScreen.dart';
import 'package:onpensea/features/product/screen/productHome/products_home_screen.dart';
import '../../utils/constants/colors.dart';
import '../Explore/ExploreScreen.dart';
import '../scheme/Screens/all_scheme_screen.dart';
import 'newDash.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<BottomNavigation> {
  int _currentIndex = 0; // To track the selected tab
  final navController = Get.put(BottomnavigationController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
            () {
            return CurvedNavigationBar(
              animationDuration: Duration(milliseconds: 400),
              backgroundColor: U_Colors.chataccentColor,
              color: U_Colors.satinSheenGold,
              buttonBackgroundColor: U_Colors.satinSheenGold,
              height: 48,
              index: navController.selectIndex.value,
              items:[
                Image.asset('assets/logos/dashboard.png', height: 20, width: 20, color: U_Colors.chataccentColor),
                Image.asset('assets/logos/store.png', height: 20, width: 20, color: U_Colors.chataccentColor),
                Image.asset('assets/logos/offer.png', height: 20, width: 20, color: U_Colors.chataccentColor),
                Image.asset('assets/logos/misc.png', height: 20, width: 20, color: U_Colors.chataccentColor),
                Image.asset('assets/logos/settings.png', height: 20, width: 20, color: U_Colors.chataccentColor),
              ],
              onTap: (index) {
                navController.selectIndex.value = index;
                print("index: $index");
              },
            );
        },
      ),
      body: Obx(()
        {
          return navController.screens[navController.selectIndex.value];

      }),
    );
  }
}



class BottomnavigationController extends GetxController {
  var selectIndex = 0.obs;

  final screens = [
    DashboardPage(),
   // Dashboard(),
    //ProductHomeScreen(),
    AdminHomeScreen(),
    AllSchemeScreen(),
    Misc(),
    Setting(),
  ];


}