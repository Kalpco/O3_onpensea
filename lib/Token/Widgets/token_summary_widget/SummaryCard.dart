import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../config/CustomTheme.dart';

class SummaryCard extends StatefulWidget {
  const SummaryCard({super.key});

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: CustomTheme.fifthColor,
          )),
      child: Container(
        alignment: Alignment.center,
        width: queryData.size.width * 0.85,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        "\u{20B9} 3,432.50",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Total returns",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        "+\u{20B9}525.25 (18.94%)",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invested",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        "\u{20B9} 2,907.25",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "1D returns",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      Text(
                        "+\u{20B9}130.15 (3.94%)",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 16,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
