import 'package:flutter/material.dart';

// import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/investment_response_model.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({super.key, required this.termAndConditions});

  final List<Investment> termAndConditions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            "Terms & conditions",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        TermsAndConditionMapWidget(
          termsAndCondition: termAndConditions,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(width: 1, color: Color(0xffB80000)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsFullPage()),
              );
            },
            child: Text(
              'View All T&Cs',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xffB80000),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TermsAndConditionMapWidget extends StatelessWidget {
  const TermsAndConditionMapWidget(
      {super.key, required this.termsAndCondition});

  final List<Investment> termsAndCondition;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: termsAndCondition.asMap().entries.map((example) {
          int index = example.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xffEEEEEE), width: 1.2),
              ),
              padding: const EdgeInsets.only(left: 2.0, top: 2, bottom: 2),
              child: ListTile(
                title: Text(
                  termsAndCondition[index].question,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
                subtitle: Text(
                  termsAndCondition[index].answer,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TermsFullPage extends StatefulWidget {
  const TermsFullPage({super.key});

  @override
  TermsFullPageState createState() => TermsFullPageState();
}

class TermsFullPageState extends State<TermsFullPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms and Condition',
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: const Center(
        child: Text("hello"),
      ),
    );
  }
}

// class TermsFullPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return WebviewScaffold(
//       url: 'https://www.kalpco.com/terms-and-conditions.html',
//       appBar: AppBar(
//         title: Text('Full Terms & Conditions'),
//       ),
//     );
//   }
// }
