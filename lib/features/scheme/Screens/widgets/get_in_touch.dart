import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GetInTouch extends StatelessWidget {
  const GetInTouch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Get in Touch',
            style:
                GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8.0),
          Text(
            'If you have any queries, get in touch with us.\nWe\'re happy to help you.',
            style:
                GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 24.0),
          Row(
            children: [
              const Icon(Icons.phone, size: 20.0),
              const SizedBox(width: 16.0),
              Text(
                '+91 9987734001',
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              const Icon(Icons.email, size: 20.0),
              const SizedBox(width: 16.0),
              Text(
                ' support@kalpco.com',
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
