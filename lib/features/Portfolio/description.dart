import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/utils/constants/colors.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage(
      {super.key,
      required this.logo,
      required this.headline,
      required this.investmentName,
      required this.returns,
      required this.maturity});

  final String logo;
  final String headline;
  final String investmentName;
  final String returns;
  final String? maturity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffEEEEEE), width: 1.2),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xffB80000), width: 1.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/logos/KALPCO.png",
                fit: BoxFit.fill,
                width: 40,
                height: 40,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            investmentName,
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(headline,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade800,
              )),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // const Icon(
              //   Icons.check_circle_rounded,
              //   color: Colors.green,
              //   size: 16,
              // ),
              // const SizedBox(
              //   width: 5,
              // ),
              // Text(
              //   "Upto ${returns} returns",
              //   style: GoogleFonts.poppins(
              //       fontWeight: FontWeight.w500,
              //       fontSize: 12,
              //       color: Colors.green),
              // ),
              // const SizedBox(
              //   width: 15,
              // ),
              const Icon(
                Icons.timer,
                color: Colors.blueAccent,
                size: 16,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "Maturity: $maturity",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: U_Colors.yaleBlue),
              )
            ],
          ),
          // const SizedBox(
          //   height: 15,
          // ),
        ],
      ),
    );
  }
}
