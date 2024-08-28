import 'package:flutter/material.dart';
import 'package:onpensea/features/scheme/Screens/digigold/widgets/divider_date.dart';
import 'package:onpensea/features/scheme/Screens/digigold/widgets/transaction_cards.dart';

class TransactionContainer extends StatelessWidget {
  const TransactionContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> transactions = [
      {
        'date': '9 Jul',
        'amount': '₹72.53',
        'title': 'Sold 10 mg of gold',
        'type': 'Sell',
      },
      {
        'date': '9 Jul',
        'amount': '₹21.03',
        'title': 'Sold 2.9 mg of gold',
        'type': 'Sell',
      },
      {
        'date': '30 Jul',
        'amount': '₹100.00',
        'title': 'Bought 12.9 mg of gold',
        'type': 'Buy',
      },
    ];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const DividerDate(
            date: "9 Jul, 12:21 pm",
          ),
          const SizedBox(
            height: 30,
          ),
          ...transactions.map((transaction) {
            bool isBuy = transaction['type'] == 'Buy';
            return Row(
              mainAxisAlignment:
              isBuy ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                TransactionCards(
                  date: transaction['date']!,
                  amount: transaction['amount']!,
                  title: transaction['title']!,
                  onTap: () {
                    // Handle the card tap here, e.g., navigate to a details page
                    print('Card tapped!');
                  },
                ),

              ],
            );
          }),
        ],
      ),
    );
  }
}
