import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/scheme/Screens/digigold/screens/transactions_list_screen.dart';

import '../../../../../utils/constants/colors.dart';
import '../controller/digigold_controller.dart';
import '../widgets/digigold_custom_app_bar.dart';
import 'digigold_buy_sell_screen.dart';

class DigiGoldMain extends StatelessWidget {
  DigiGoldMain({super.key});

  final DigiGoldController controller = Get.put(DigiGoldController());
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Use a post-frame callback to refresh data after the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshData();
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: Obx(() {
          return DigiGoldCustomAppBar(
            goldPrice: controller.goldPrice.value.goldPrice,
            mgOfGoldUserHas: double.parse(controller.userDetails.value?.weightInMg ?? "0.0").toStringAsFixed(2) ?? '0',
            isTransactionDataAvailable: controller.transactions.isNotEmpty,
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.isUserNewDigigoldCustomer.value) {
          return Center(
            child: Text(
              'Start investment in DigiGold',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        if (controller.transactions.isEmpty) {
          return const Center(child: Text('No transactions available'));
        }

        // Scroll to the bottom of the list when transactions are loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });

        return ListView(
          controller: _scrollController,
          children: [
            const SizedBox(height: 30),
            TransactionsListScreen(
              isTransactionDataAvailable: controller.transactions.isNotEmpty,
            ),
            const SizedBox(height: 30),
          ],
        );
      }),
      bottomNavigationBar: Obx(() { // Wrap the bottom navigation bar with Obx
        return BottomAppBar(
          color: Colors.transparent,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.setTransactionType("buy");
                    Get.to(() => DigiGoldBuySellScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: U_Colors.yaleBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    minimumSize: const Size(75, 25),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    side: MaterialStateProperty.all(BorderSide.none), // Remove the border
                    overlayColor: MaterialStateProperty.all(Colors.transparent), // Remove splash effect
                    foregroundColor: MaterialStateProperty.all(Colors.white), // Text color
                  ),
                  child: const Text('Buy'),
                ),
                const SizedBox(width: 10),
                if (!controller.isUserNewDigigoldCustomer.value)
                  ElevatedButton(
                    onPressed: () {
                      controller.setTransactionType("sell");
                      Get.to(() => DigiGoldBuySellScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: U_Colors.yaleBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      minimumSize: const Size(75, 25),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ).copyWith(
                      side: MaterialStateProperty.all(BorderSide.none), // Remove the border
                      overlayColor: MaterialStateProperty.all(Colors.transparent), // Remove splash effect
                      foregroundColor: MaterialStateProperty.all(Colors.white), // Text color
                    ),
                    child: const Text('Sell'),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
