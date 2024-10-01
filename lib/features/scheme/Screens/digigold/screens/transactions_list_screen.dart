import 'package:flutter/material.dart';
import 'package:onpensea/features/scheme/Screens/digigold/widgets/transaction_container.dart';

import '../widgets/digi_gold_summary.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key, this.isTransactionDataAvailable});

  final bool? isTransactionDataAvailable;

  @override
  Widget build(BuildContext context) {
    return isTransactionDataAvailable!
        ? Column(
            children: [
              TransactionContainer(),
              TransactionContainer(),
              TransactionContainer(),
            ],
          )
        : DigiGoldSummary();
  }
}
