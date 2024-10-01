import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/lservice/screens/widget/GetInTouchLoan.dart';
import 'package:onpensea/utils/constants/colors.dart';

import '../../scheme/Screens/widgets/get_in_touch.dart';

class LoansScreen extends StatelessWidget {
  final List<Map<String, dynamic>> schemes = [
    {
      "name": "Home Loan",
      "owner": "Kalpco Consulting Private Ltd",
      "image":
          "https://t3.ftcdn.net/jpg/04/32/16/40/360_F_432164000_CoXNI8lOf3HsNkGftjMyZqZdEun7kMqm.jpg",
      "details": {
        "description": "Make Your Dream Home a Reality",
        "howItWorks": [
          "Looking to purchase your first home or upgrade to a new one?",
          "Our flexible home loan options offer competitive rates and personalized solutions to fit your needs.",
          "With a simple application process and expert guidance every step of the way, turning the key to your new home has never been easier. ",
          "Apply today and take the first step towards homeownership!",
        ]
      }
    },
    {
      "name": "Loan against Property",
      "owner": "Kalpco Consulting Private Ltd",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIm-rHyQXKQDxKEKGOTyDnZW7mtKnDtcK1Qw&s",
      "details": {
        "description": "Unlock the Value of Your Property",
        "howItWorks": [
          "Need funds for personal or business needs?"
              "With our Loan Against Property, you can leverage the equity in your home to secure a high-value loan at competitive interest rates.",
          "Enjoy flexible repayment options and quick approvals.",
          "Whether it's for education, medical expenses, or business expansion, your property can help you achieve your financial goals.",
          "Apply now and make your property's value work for you!",
        ]
      }
    },
    // Add more schemes here
    {
      "name": "Personal Loan",
      "owner": "Kalpco Consulting Private Ltd",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTWtlA21FIraFCEjUmvVBGTWsM1tkAAW1w4TA&s",
      "details": {
        "description": "Turn Your Aspirations into Reality",
        "howItWorks": [
          "Whether you're planning a dream vacation, renovating your home, or covering unexpected expenses, our Personal Loans provide the financial boost you need.",
          "Enjoy quick approvals, competitive interest rates, and flexible repayment options tailored to your budget.",
          "With a hassle-free application process and no collateral required, achieving your goals has never been easier.",
          "Apply today and take the first step towards fulfilling your dreams!"
        ]
      }
    },
    {
      "name": "Business Loan",
      "owner": "Kalpco Consulting Private Ltd",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTIm-rHyQXKQDxKEKGOTyDnZW7mtKnDtcK1Qw&s",
      "details": {
        "description": "Empower Your Business Ambitions",
        "howItWorks": [
          "Looking to expand your operations, purchase new equipment, or boost working capital?",
          "Our Business Loans provide the financial support you need to achieve your goals.",
          "Enjoy competitive interest rates, flexible repayment options, and a straightforward application process.",
          "With our dedicated support, turning your business vision into reality has never been easier.",
          "Apply today and take the next big step for your business!"
        ]
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: ListView.builder(
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Column(
            children: [
              if (index == 0)
                SizedBox(height: 20), // Adds space above the first card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Rounded corners
                ),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                // More space between cards
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image that spans the full width of the screen
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                      child: Image.network(
                        scheme['image']!,
                        width: double.infinity,
                        height: 200, // You can adjust the height
                        fit: BoxFit
                            .cover, // Ensures the image covers the full width
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 5.0, top: 15.0, bottom: 5),
                      child: Text(
                        scheme['name']!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: const Color(0xff182C61),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Company: ${scheme['owner']}",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xff182C61),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: Text(
                        "More Info",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: U_Colors.yaleBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GetInTouchLoan(),
                              SizedBox(height: 10,),
                              Text(
                                scheme['details']['description'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: const Color(0xff182C61),
                                    fontWeight: FontWeight.bold,
                                  ),
                              ),
                              SizedBox(height: 10),
                              // Text(
                              //   "Make Your Dream Home a Reality",
                              //   style: GoogleFonts.poppins(
                              //     fontSize: 16,
                              //     color: const Color(0xff182C61),
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              SizedBox(height: 10),
                              for (var step in scheme['details']['howItWorks'])
                                Text(
                                  "• $step",
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: const Color(0xff182C61),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          );
        },
      ),
    );
  }
}

PreferredSizeWidget _appBar(BuildContext context) {
  return AppBar(
    title: Text("Loans", style: TextStyle(color: Colors.white)),
    backgroundColor: U_Colors.yaleBlue,
    elevation: 0,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, color: Colors.white),
    ),
  );
}
