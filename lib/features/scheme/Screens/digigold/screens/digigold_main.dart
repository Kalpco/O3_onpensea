import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/scheme/Screens/digigold/screens/transactions_list_screen.dart';
import 'package:onpensea/features/scheme/Screens/digigold/widgets/digigold_custom_app_bar.dart';
import 'package:onpensea/features/scheme/Screens/digigold/widgets/transaction_container.dart';

import '../widgets/digi_gold_summary.dart';
import 'digigold_buy_sell_screen.dart';

class DigiGoldMain extends StatefulWidget {
  const DigiGoldMain({super.key});

  @override
  State<DigiGoldMain> createState() => _DigiGoldMainState();
}

class _DigiGoldMainState extends State<DigiGoldMain> {
  final bool? isTransactionDataAvailable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, // Set background color to transparent
        elevation: 0, // Set background color to white
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DigiGoldBuySellScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Customize button color
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none,
                      borderRadius:
                          BorderRadius.circular(30.0), // Rounded corners
                    ),
                    minimumSize: const Size(75, 25) // Padding inside the button
                    ),
                child: Text(
                  'Buy',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    side: BorderSide.none, // Customize button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Rounded corners
                    ),
                    minimumSize: const Size(75, 25) // Padding inside the button
                    ),
                child: Text(
                  'Sell',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    side: BorderSide.none,
                    // Customize button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Rounded corners
                    ),
                    minimumSize: const Size(75, 25) // Padding inside the button
                    ),
                child: Text(
                  'Delivery',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(200.0),
        child: DigiGoldCustomAppBar(
          isTransactionDataAvailable: isTransactionDataAvailable!,
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          TransactionsListScreen(
            isTransactionDataAvailable: isTransactionDataAvailable!,
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
