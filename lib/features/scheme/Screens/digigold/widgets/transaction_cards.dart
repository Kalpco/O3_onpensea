import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/app.dart';
import 'package:onpensea/features/scheme/Screens/digigold/screens/transactions_list_screen.dart';

class TransactionCards extends StatelessWidget {
  const TransactionCards({
    super.key,
    this.title,
    this.amount,
    this.date,
    this.isPaid = true,
    this.onTap,
  });

  final String? title;
  final String? amount;
  final String? date;
  final bool isPaid;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0), // Ensure the ripple effect follows the card's shape
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25), // Match the border radius
          child: Container(
            margin: const EdgeInsets.all(15), // Adjust the margin as needed
            padding: const EdgeInsets.all(14), // Padding inside the card
            decoration: BoxDecoration(
              color: Colors.white, // Card background color
              borderRadius: BorderRadius.circular(25), // Rounded corners
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12, // Shadow color
                  offset: Offset(-1, 2), // Shadow position
                  blurRadius: 5, // Shadow blur radius
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
              (title!.contains("buy")) ? title!.replaceFirst(RegExp(r'^buy', caseSensitive: false), 'Bought') : title!.capitalizeFirst!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount!,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      isPaid ? Icons.check_circle : Icons.error,
                      color: isPaid ? Colors.green : Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Paid • $date',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(
                      Icons.arrow_right_outlined,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
