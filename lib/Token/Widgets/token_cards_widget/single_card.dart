import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/config/CustomTheme.dart';

class SingleCard extends StatefulWidget {
  String textHeading;
  String textDetails;
  String extraDetails;

  SingleCard(
      {super.key,
      required this.textHeading,
      required this.textDetails,
      required this.extraDetails});

  @override
  State<SingleCard> createState() => _SingleCardState();
}

class _SingleCardState extends State<SingleCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: CustomTheme.fifthColor,
          )),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.textHeading,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.headlineLarge,
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  widget.textDetails,
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineLarge,
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                Text(
                  " ${widget.extraDetails}",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineLarge,
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
