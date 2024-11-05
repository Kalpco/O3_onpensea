// transaction_container.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/digigold_controller.dart';
import '../screens/digigold_transaction_sell_screen.dart';
import '../widgets/divider_date.dart';
import '../widgets/transaction_cards.dart';
import 'package:intl/intl.dart';

// String extension to capitalize the first letter
extension StringExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

class TransactionContainer extends StatelessWidget {
  const TransactionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final DigiGoldController controller = Get.find<DigiGoldController>();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.transactions.isEmpty) {
          return const Center(child: Text('No transactions available'));
        }

        // Group transactions by date
        Map<String, List> groupedTransactions = {};
        for (var transaction in controller.transactions) {
          String transactionDate = DateFormat('dd MMM, yyyy').format(transaction.createdAt);
          if (groupedTransactions[transactionDate] == null) {
            groupedTransactions[transactionDate] = [];
          }
          groupedTransactions[transactionDate]!.add(transaction);
        }

        // Render the grouped transactions
        return Column(
          children: groupedTransactions.entries.map((entry) {
            String date = entry.key;
            List transactions = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DividerDate(date: date), // Display the date as a divider
                const SizedBox(height: 20),
                Column(
                  children: transactions.map<Widget>((transaction) {
                    bool isBuy = transaction.vaultTransactionType.toLowerCase() == 'buy';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: isBuy ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          TransactionCards(
                            date: DateFormat('hh:mm a').format(transaction.createdAt),
                            amount: '₹${transaction.amount}',
                            title: '${transaction.vaultTransactionType} ${transaction.weightMg} mg of gold',
                            isPaid: isBuy, // For simplicity, marking "buy" as paid
                            onTap: () {
                              Get.to(() => DigigoldTransactionSellScreen());
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),
              ],
            );
          }).toList(),
        );
      }),
    );
  }
}
