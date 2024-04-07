import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Token/Widgets/token_summary_widget/SummaryCard.dart';

class TokenSummary extends StatefulWidget {
  const TokenSummary({super.key});

  @override
  State<TokenSummary> createState() => _TokenSummaryState();
}

class _TokenSummaryState extends State<TokenSummary> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Holdings (4)",
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SummaryCard(),
            ],
          ),
        ],
      ),
    );
  }
}
