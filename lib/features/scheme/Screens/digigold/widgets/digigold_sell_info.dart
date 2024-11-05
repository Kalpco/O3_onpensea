import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DigigoldSellInfo extends StatelessWidget {
  DigigoldSellInfo(
      {super.key,
      this.amountToRecieveOnSellingMgOfGold,
      this.sellingPriceOfGoldPerMg,
      this.currentBalanceMgOfGold});

  String? amountToRecieveOnSellingMgOfGold;
  String? sellingPriceOfGoldPerMg;
  String? currentBalanceMgOfGold;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '₹ $amountToRecieveOnSellingMgOfGold',
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            'Selling Price ₹$sellingPriceOfGoldPerMg/mg',
            style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.bold),
          ),
          Text('Current balance: $currentBalanceMgOfGold mg',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
