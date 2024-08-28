import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  //variables
  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;
  //update current index when page scrolls
  void updatePageIndicator(index) => currentPageIndex.value = index;
  //jump to selected dot
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  //update current index  and jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      Get.offAll(const LoginScreen());
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpTo(currentPageIndex.value + 1);
    }
  }

  //update current index and jump to last page
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpTo(2);
  }
}
