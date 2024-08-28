import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DividerDate extends StatelessWidget {
  const DividerDate({super.key, this.date});

  final String? date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1.0,
              color: Colors.grey[400],
              indent: 10.0,
              endIndent: 10.0,
            ),
          ),
          Text(
            date!,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1.0,
              color: Colors.grey[400],
              indent: 10.0,
              endIndent: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
