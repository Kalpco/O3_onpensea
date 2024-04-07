import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../../../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart";
import "../../../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart";
import "../../../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart";
import "../../../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart";
import "../../../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart";
import "../../../Feature-ApplyForTokens/Screens/ShowAllPendingPropertiesToken.dart";
import "../../Screens/WidgetToDisplayAlltheCities.dart";

class DropDown extends StatefulWidget {
  String? userType;

  DropDown({super.key, required this.userType});

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {

  String? userType;
  final List<String> iconNamesUser = [
    'Select your options user',
    'Buy Request',
    'Sell Request',
    'Register Property',
  ];
  final List<String> iconNamesAdmin = [
    'Select your options admin',
    'Admin property',
    'Admin buy',
    'Admin sell',
    'Property Token',
  ];

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    String? selectedValue = widget.userType == "ADMIN"
        ? "Select your options admin"
        : "Select your options user";
    double linePosition = 0.0;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(50, 2, 50, 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.grey[200],
                ),
                child: DropdownButton<String>(
                  value: selectedValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  underline: Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
                  onChanged: (String? newValue) {
                    setState() {
                      selectedValue = newValue;
                    }

                    if (newValue == "Select your screen") {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) =>
                      //           ShowAllVerifiedProperties(screenStatus: "buy")),
                      // );
                    }
                    if (newValue == "Buy Request") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ScreenToDisplayAlltheCities(
                                  screenStatus: "buy",
                                )),
                      );
                    }
                    if (newValue == "Sell Request") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowAllVerifiedProperties(
                                screenStatus: "sell")),
                      );
                    }
                    if (newValue == "Register Property") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPropertyOne()),
                      );
                    }
                    if (newValue == "Admin property") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowAllPendingProperties(
                                  screenStatus: 'buy',
                                )),
                      );
                    }
                    if (newValue == "Admin buy") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShowAllVerifyBuy(
                                  screenStatus: 'buy',
                                )),
                      );
                    }
                    if (newValue == "Admin sell") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ShowAllVerifySell(
                                  screenStatus: 'sell',
                                )),
                      );
                    }
                    if (newValue == "Property Token") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowAllPendingPropertiesToken(
                                  screenStatus: 'buy',
                                )),
                      );
                    }
                    // setState(() {
                    //   selectedValue = newValue;
                    // });
                  },
                  items: (widget.userType == "ADMIN"
                          ? iconNamesAdmin
                          : iconNamesUser)
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 14,
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //   children: [
          //     InkWell(
          //       onTap: () {
          //         setState(() {
          //           linePosition = 0.0;
          //         });
          //         // Navigator.push(
          //         //     context,
          //         //     MaterialPageRoute(
          //         //         builder: (context) => RegisterInvestorScreen()));
          //       },
          //       child: Column(
          //         children: [
          //           Icon(
          //             Icons.event_busy_sharp,
          //             size: 30,
          //             color: linePosition == 0.0 ? Colors.blue : Colors.grey,
          //           ),
          //           Text('Buy'),
          //           Container(
          //             width: 30,
          //             height: 2,
          //             color:
          //                 linePosition == 0.0 ? Colors.blue : Colors.transparent,
          //           ),
          //         ],
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         setState(() {
          //           linePosition = 1.0;
          //         });
          //         // Navigator.push(
          //         //     context,
          //         //     MaterialPageRoute(
          //         //         builder: (context) => RegisterPropertyScreen()));
          //       },
          //       child: Column(
          //         children: [
          //           Icon(
          //             Icons.sell_outlined,
          //             size: 30,
          //             color: linePosition == 1.0 ? Colors.green : Colors.grey,
          //           ),
          //           Text('Sell'),
          //           Container(
          //             width: 30,
          //             height: 2,
          //             color:
          //                 linePosition == 1.0 ? Colors.green : Colors.transparent,
          //           ),
          //         ],
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         setState(() {
          //           linePosition = 2.0;
          //         });
          //         // Add navigation logic for Property here
          //         // Navigator.push(context,
          //         //     MaterialPageRoute(builder: (context) => AdminUser()));
          //       },
          //       child: Column(
          //         children: [
          //           Icon(
          //             Icons.house_outlined,
          //             size: 30,
          //             color: linePosition == 2.0 ? Colors.orange : Colors.grey,
          //           ),
          //           Text('House'),
          //           Container(
          //             width: 30,
          //             height: 2,
          //             color: linePosition == 2.0
          //                 ? Colors.orange
          //                 : Colors.transparent,
          //           ),
          //         ],
          //       ),
          //     ),
          //     InkWell(
          //       onTap: () {
          //         setState(() {
          //           linePosition = 3.0;
          //         });
          //         // Add navigation logic for Others here
          //       },
          //       child: Column(
          //         children: [
          //           Icon(
          //             Icons.devices_other,
          //             size: 30,
          //             color: linePosition == 3.0 ? Colors.red : Colors.grey,
          //           ),
          //           Text('Others'),
          //           Container(
          //             width: 30,
          //             height: 2,
          //             color:
          //                 linePosition == 3.0 ? Colors.red : Colors.transparent,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }


}
