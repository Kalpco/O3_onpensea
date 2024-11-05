import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import 'digigold_main.dart';

class DigigoldSuccessPage extends StatelessWidget {

  const DigigoldSuccessPage({Key? key}) : super(key: key);

  // A flag to prevent multiple navigations
  static bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    // Check if we have already navigated to prevent multiple redirects
    if (!_hasNavigated) {
      _hasNavigated = true;
      Future.delayed(const Duration(seconds: 2), () {
        Get.off(() => DigiGoldMain());
        _hasNavigated = false; // Reset the flag for future use
      });
    }

    return Scaffold(
      backgroundColor: U_Colors.yaleBlue, // Purple background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // Transparent to blend with the background
        elevation: 0,
        // No shadow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Get.off(() => DigiGoldMain()); // Navigate back to the main screen if needed
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200, // Adjust size as needed
              height: 200,
              decoration: const BoxDecoration(
                color: U_Colors.yaleBlue,
                // Slightly darker purple circle background
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/logos/success_.webp',
                  // Replace with your success image
                  width: 100, // Adjust as needed
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Transaction Successful!',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Redirecting to the main page...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
