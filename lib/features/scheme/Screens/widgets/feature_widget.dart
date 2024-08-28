import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String text;

  FeatureCard({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.amber,
            size: 22.0,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
