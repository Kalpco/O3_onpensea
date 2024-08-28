import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SchemeCalculator extends StatefulWidget {
  const SchemeCalculator({super.key});

  @override
  State<SchemeCalculator> createState() => _SchemeCalculatorState();
}

class _SchemeCalculatorState extends State<SchemeCalculator> {
  var totalInvested = 0;
  var valueAtRedemption = 0;
  static TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = "";
  }


  void calculate(String amount) {
    var months = 11;
    var newtotalInvested = int.parse(amount) * months;
    var newvalueAtRedemption = newtotalInvested + (int.parse(amount));
    setState(() {
      totalInvested = newtotalInvested;
      valueAtRedemption = newvalueAtRedemption;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "BENEFIT CALCULATOR",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xffEEEEEE), width: 1.2),
              ),
              child: schemeCalculator(
                  amountController, totalInvested, valueAtRedemption)),
        ],
      ),
    );
  }

  Widget schemeCalculator(TextEditingController amountController,
      var totalInvested, var valueAtRedemption) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.center,
          "Enter Monthly Payments",
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: "Enter amount",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black87,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.black87,
                  width: 1.5,
                )),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Colors.black87,
                width: 2,
              ),
            ),
          ),
          controller: amountController,
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: double.infinity,
          child: Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade200,
                side:
                const BorderSide(width: 1, color: const Color(0xffB80000)),
              ),
              onPressed: () => calculate(amountController.text),
              child: Text(
                'Calculate',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffB80000),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Total Invested",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: totalInvested.toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Value at redemption:",
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: valueAtRedemption.toString(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.black87,
                        width: 1.5,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.black87,
                      width: 2,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
