import 'package:flutter/material.dart';

class DigigoldTransactionSellScreen extends StatefulWidget {
  const DigigoldTransactionSellScreen({Key? key}) : super(key: key);

  @override
  State<DigigoldTransactionSellScreen> createState() =>
      _TransactionScreenState();
}

class _TransactionScreenState extends State<DigigoldTransactionSellScreen> {
  // Variable to control the expansion state
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Image.asset(
              'assets/logos/gold_coin_one.webp', // Add a placeholder gold image
              height: 80,
            ),
            const SizedBox(height: 10),
            const Text(
              'Received from selling 0.5 mg of gold',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              '₹3.48',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '12 Aug 2024, 6:23 pm',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Card with ExpansionTile, expanded by default
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ExpansionTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.red,
                  child: Icon(Icons.account_balance, color: Colors.white),
                ),
                title: const Text('Central Bank of India 8302'),

                // Control the expanded state with 'isExpanded'
                initiallyExpanded: isExpanded,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text('Vendor transaction ID:', style: TextStyle(),),
                            SizedBox(width: 10),
                            Flexible(
                                child: Text('GPY17234671861830000000027',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500)))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("To:"),
                            SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                  'Mr ADITYA HARENDRA MALL (Central Bank of India)'),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text('Google transaction ID:'),
                            Text('CICAgLCJ4v-SUQ',
                                style: TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text('Invoice number:'),
                            Text('P2025000833679'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              'Payments may take up to 3 working days to be reflected in your account',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.help_outline),
                  label: const Text('Having issues?'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
