import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';

class FaqsWidget extends StatelessWidget {
  const FaqsWidget({super.key, required this.faqs});

  final List<Investment> faqs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Frequently asked questions",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xffEEEEEE), width: 1.2),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faqs[0].question,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  faqs[0].answer,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side:
                    const BorderSide(width: 1, color: const Color(0xffB80000)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        FAQWidget(faqs: faqs),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset(0.0, 0.0);
                      const curve = Curves.easeInOut;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Text(
                'View All FAQs',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xffB80000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQWidget extends StatelessWidget {
  const FAQWidget({super.key, required this.faqs});

  final List<Investment> faqs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FAQs"),
      ),
      body: ListView.builder(
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(faqs[index].question),
            children: <Widget>[
              ListTile(
                title: Text(faqs[index].answer),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ(this.question, this.answer);
}

final List<FAQ> faqs = [
  FAQ("What is daily savings?",
      "Daily savings is an automated way to save a custom amount for a custom duration, daily."),
  FAQ("Can I make a one-time/lump sum investment?",
      "Yes, you can make a one-time or lump sum investment."),
  FAQ("Is Plus safe?", "Yes, Plus is safe."),
  FAQ("Can I withdraw my money at anytime?",
      "Yes, you can withdraw at anytime. You can either cash-in at your registered account no. or redeem it at our partnered jeweller stores."),
  // Add more FAQs as needed
];
