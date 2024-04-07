import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";
import "package:onpensea/config/CustomTheme.dart";

class YesWidget extends StatelessWidget {
  final String totalTokenPrice;
  final String totalBuyCount;
  final String totalPropCount;
  final String totalSellCount;
  final String totalTokeHoldigs;
  final String userType;

  YesWidget({
    super.key,
    required this.totalTokenPrice,
    required this.totalBuyCount,
    required this.totalPropCount,
    required this.totalSellCount,
    required this.totalTokeHoldigs,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingSize =
        0.03 * MediaQuery.of(context).size.width; // 10% of screen width
    double innerPadding = 14.0; // 10 pixels of padding for the colored boxes

    String cdate = DateFormat("dd-MM-yyyy").format(DateTime.now());

    return Container(
      decoration: BoxDecoration(
        gradient: CustomTheme.customLinearGradient,
      ),
      alignment: Alignment.center,
      height: screenHeight / 1.9,
      child: Padding(
        padding: EdgeInsets.all(paddingSize),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        userType == "ADMIN"
                            ? "Token Request Received"
                            : "Token Price Balance ",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                      ),
                      Text(
                        totalTokenPrice!.isNotEmpty
                            ? userType == "ADMIN"
                                ? totalTokenPrice
                                : "\u{20B9} ${totalTokenPrice.substring(3, totalTokenPrice.length)}"
                            : "Loading..",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineSmall,
                          fontSize: 25,
                          color: Colors.black54,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.orangeAccent,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(innerPadding),
                    child: Container(
                      width: (MediaQuery.of(context).size.width -
                                  2 * paddingSize) /
                              2 -
                          2 * innerPadding,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Total Buy Request',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1, width: 10),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                userType == "ADMIN"
                                    ? "Until $cdate"
                                    : 'Until $cdate',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                totalBuyCount!.isNotEmpty
                                    ? totalBuyCount
                                    : "Loading...",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(innerPadding),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width -
                                  2 * paddingSize) /
                              2 -
                          2 * innerPadding,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Total Sell Request',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1, width: 10),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                userType == "ADMIN"
                                    ? "Until $cdate"
                                    : "Until $cdate",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 10,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                totalSellCount!.isNotEmpty
                                    ? totalSellCount
                                    : "Loading...",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(innerPadding),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width -
                                  2 * paddingSize) /
                              2 -
                          2 * innerPadding,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Total Property Request',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 11,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1, width: 10),
                          Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                userType == "ADMIN"
                                    ? "Until $cdate"
                                    : 'Until $cdate',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 10,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                totalPropCount!.isNotEmpty
                                    ? totalPropCount
                                    : "Loading...",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(innerPadding),
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width -
                                  2 * paddingSize) /
                              2 -
                          2 * innerPadding,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Processed Txn ',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1, width: 10),
                          Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                userType == "ADMIN"
                                    ? "Until $cdate"
                                    : 'Until $cdate',
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 10,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                totalTokeHoldigs!.isNotEmpty
                                    ? totalTokeHoldigs
                                    : "Loading...",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.labelLarge,
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
