import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:onpensea/features/Portfolio/portfolio_bottom_sheet.dart';
import 'package:onpensea/features/Portfolio/walletSuccessPage.dart';
import 'package:onpensea/features/Portfolio/widgets/scheme-status-summary-widget.dart';
import 'package:onpensea/features/profile/Controller/callWalletApi.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:shimmer/shimmer.dart';
import '../authentication/screens/login/Controller/LoginController.dart';
import 'SchemeContoller.dart';
import 'description.dart';
import 'dart:ui' as ui;

class BarChartSample extends StatefulWidget {
  final String investmentId;
  final String investmentName;

  const BarChartSample(
      {super.key, required this.investmentId, required this.investmentName});

  @override
  State<BarChartSample> createState() =>
      _BarChartSampleState(investmentId, investmentName);
}

class _BarChartSampleState extends State<BarChartSample> {
  final String investmentId;
  final String investmentName;
  bool isUserEligibleForRedemption = false;
  bool isUserEligibleForNextPayment = false;
  bool isLastPaymentDone = false;
  bool toggleIcon = false;

  final WalletApiService walletApiService = WalletApiService();

  _BarChartSampleState(this.investmentId, this.investmentName);

  toggleIconState(bool value) {
    setState(() {
      toggleIcon = value;
    });
  }

  List<String> date = [];
  List<dynamic>? listMonths;
  Map<dynamic, dynamic>? response;
  Map<int, double> monthAmountMap = {};
  int length = 0;
  int srNo = 0;
  bool isLoading = true;
  int totalNoOfInstallment = 0;
  var status;
  String finalStatus = "active";
  String? startDate;
  String? endDate;
  List<dynamic> ascendingListMonths = [];

  @override
  void initState() {
    super.initState();
    loadScheme();
  }

  Future<void> loadScheme() async {
    response = await SchemeContoller.getScheme(investmentId);
    listMonths = response?['list'];
    totalNoOfInstallment = response?['totalNoOfInstallment'];
    status = response?['status'];

    // Sort the listMonths in descending order based on the payment date
    listMonths?.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateB.compareTo(dateA); // Descending order
    });

    // Create a copy and sort in ascending order for the bar chart
    ascendingListMonths = List<dynamic>.from(listMonths!);
    ascendingListMonths.sort((a, b) {
      DateTime dateA = DateTime.parse(a['date']);
      DateTime dateB = DateTime.parse(b['date']);
      return dateA.compareTo(dateB); // Ascending order
    });

    length = listMonths?.length ?? 0;

    // Track the order of installments explicitly
    int paymentOrder = 0;

    for (dynamic d in listMonths!) {
      int monthInt = int.parse(d["month"]);
      double amount = double.parse(d["amount"]);
      if (d["date"] != null) {
        date.add(d["date"]);
      }
      if (monthAmountMap.containsKey(monthInt)) {
        monthAmountMap[monthInt] = monthAmountMap[monthInt]! + amount;
      } else {
        monthAmountMap[monthInt] = amount;
      }

      // Increment the payment order
      paymentOrder++;
      // Check if this is the 12th installment
      if (paymentOrder == 12) {
        setState(() {
          isUserEligibleForRedemption = true;
          isLastPaymentDone = true;
        });
      }
    }

    // Calculate the end date based on the start date
    startDate = listMonths
        ?.last['date']; // Assuming the start date is the earliest payment date
    if (startDate != null) {
      endDate = calculateEndDate(startDate!);
    }

    dynamic lastPaymentObject = listMonths?.first; // Most recent payment
    if (lastPaymentObject != null) {
      int lastPaymentMonth = int.parse(lastPaymentObject["month"]);
      int currentMonth = DateTime.now().month;

      int monthsDifference;
      if (currentMonth >= lastPaymentMonth) {
        monthsDifference = currentMonth - lastPaymentMonth;
      } else {
        monthsDifference = 12 - lastPaymentMonth + currentMonth;
      }

      print("month difference: $monthsDifference");

      setState(() {
        isLoading = false;
        if (status == "a" || status == "A") {
          finalStatus = "active";
        } else if (status == "c" || status == "C") {
          finalStatus = "completed";
        } else if (status == "r" || status == "R") {
          finalStatus = "redeemed";
        }

        if (monthsDifference == 1 && (status == 'a' || status == "A")) {
          isUserEligibleForNextPayment = true;
        }
      });
    }
  }

  void _openModal(int amount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => PortfolioBottomSheetModal(
        amount: amount,
        toggleIcon: toggleIcon,
        valueChanged: toggleIconState,
        investmentId: investmentId,
        investmentName: investmentName,
      ),
    );
  }

  String calculateEndDate(String startDate) {
    // Parse the start date string into a DateTime object
    DateTime startDateTime = DateTime.parse(startDate);

    // Calculate the end date by adding 10 months
    DateTime endDateTime = DateTime(
      startDateTime.year,
      startDateTime.month + 10,
      startDateTime.day,
    );

    // Format the end date as "MMMM yyyy"
    String formattedEndDate = DateFormat("MMMM yyyy").format(endDateTime);

    print("End date: $formattedEndDate");
    return formattedEndDate; // Output will be "August 2024"
  }

  void redeem() {
    final loginController = Get.find<LoginController>();
    int userId = loginController.userData['userId'];
    walletApiService.postWalletData(userId, int.parse(investmentId)).then((_) {
      // Assuming the API call is successful, reload the data
      loadScheme(); // Reload the data by calling the loadScheme method

      setState(() {
        // This will trigger the rebuild of the page
      });

      // Optionally navigate to the success page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WalletSuccessPage(investmentName: investmentName),
        ),
      );
    });
  }


  String getSummaryMessage() {
    dynamic lastPaymentObject = listMonths?.first; // Most recent payment
    if (isUserEligibleForRedemption && finalStatus == "completed") {
      return "You are eligible to redeem. 12th Payment was done by Kalpco Consulting Pvt Ltd.";
    } else if (isUserEligibleForNextPayment) {
      return "Payment for this month is active. \nAmount to pay: ₹ ${listMonths?.first["amount"]}";
    } else if (finalStatus == "redeemed") {
      return "This scheme is closed and money has been redeemed into the wallet.";
    } else {
      if (lastPaymentObject != null) {
        return "This month installment paid on ${lastPaymentObject['date']}.";
      } else {
        return "No payments have been made yet.";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: (isLastPaymentDone && finalStatus == "redeemed")
          ? null
          : (isUserEligibleForRedemption)
          ? BottomAppBar(
        height: 70,
        color: U_Colors.whiteColor,
        child: Row(
          children: [
            if (isUserEligibleForRedemption)
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: U_Colors.yaleBlue,
                    side:
                    const BorderSide(width: 0, color: Colors.red),
                  ),
                  onPressed: () {
                    redeem();
                  },
                  child: Text(
                    "Redeem",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      )
          : (isUserEligibleForNextPayment)
          ? BottomAppBar(
        height: 70,
        color: U_Colors.whiteColor,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: U_Colors.yaleBlue,
                  side: BorderSide.none,
                ),
                onPressed: () {
                  _openModal(
                      int.parse(listMonths?.first["amount"]));
                },
                child: Text(
                  "Make Payment",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : null,
      appBar: AppBar(
        title: const Text('Investment Details'),
      ),
      body: isLoading
          ? Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius:
                  BorderRadius.circular(15), // Border radius
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius:
                  BorderRadius.circular(20), // Border radius
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius:
                  BorderRadius.circular(20), // Border radius
                ),
              ),
              const SizedBox(height: 30),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius:
                  BorderRadius.circular(20), // Border radius
                ),
              )
            ],
          ),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 25000,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.blueGrey,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: SideTitles(
                        showTitles: false,
                      ),
                      topTitles: SideTitles(showTitles: false),
                      bottomTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) =>
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 8,
                        ),
                        margin: 16,
                        getTitles: (double value) {
                          if (value.toInt() - 1 <
                              ascendingListMonths.length) {
                            DateTime paymentDate = DateTime.parse(
                                ascendingListMonths[value.toInt() - 1]
                                ['date']);
                            String formattedMonth =
                            DateFormat("MMM").format(paymentDate);
                            String formattedYear =
                            DateFormat("yyyy").format(paymentDate);

                            // Return a string with the month and year separated by a newline
                            return '$formattedMonth\n$formattedYear';
                          }
                          return '';
                        },
                        reservedSize:
                        40, // Adjust this size based on your layout
                      ),
                      leftTitles: SideTitles(
                        showTitles: true,
                        getTextStyles: (context, value) =>
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                        reservedSize: 30,
                        getTitles: (value) {
                          switch (value.toInt()) {
                            case 0:
                              return '0';
                            case 5000:
                              return '5K';
                            case 10000:
                              return '10K';
                            case 15000:
                              return '15K';
                            case 20000:
                              return '20K';
                            case 25000:
                              return '25K';
                            default:
                              return '';
                          }
                        },
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: true,
                      drawHorizontalLine: true,
                      horizontalInterval: 5000,
                      verticalInterval: 1,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.blueGrey,
                          strokeWidth: 0.5,
                          dashArray: [5, 5],
                        );
                      },
                      getDrawingVerticalLine: (value) {
                        return FlLine(
                          color: Colors.red,
                          strokeWidth: 1,
                          dashArray: [5, 5],
                        );
                      },
                    ),
                    barGroups: [
                      for (int i = 0;
                      i < ascendingListMonths.length && i < 11;
                      i++)
                        BarChartGroupData(
                          x: i + 1, // Ensure x starts at 1
                          barRods: [
                            BarChartRodData(
                              y: monthAmountMap[int.parse(
                                  ascendingListMonths[i]['month'])] ??
                                  0,
                              colors: [Colors.greenAccent],
                              backDrawRodData:
                              BackgroundBarChartRodData(show: false),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              SummaryPage(
                headline:
                "Eligible to redeem after 11 monthly installments",
                investmentName: investmentName,
                logo: "",
                maturity: endDate,
                returns: "20%",
              ),
              const SizedBox(
                height: 30,
              ),
              SchemeStatusSummarWidget(
                message: getSummaryMessage(),
                status: finalStatus,
              ),
              const SizedBox(
                height: 30,
              ),
              ClipRRect(
                child: Table(
                  textDirection: ui.TextDirection.ltr,
                  border: TableBorder.all(width: 1.0, color: Colors.grey),
                  columnWidths: const {
                    0: FixedColumnWidth(60.0),
                    1: FlexColumnWidth(),
                    2: FlexColumnWidth(),
                  },
                  children: [
                    const TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("SIP.No",
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Payment Date ",
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Amount (₹)",
                            style:
                            TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ]),
                    if (listMonths != null)
                      for (int i = 0; i < listMonths!.length; i++)
                        TableRow(
                          decoration: BoxDecoration(
                            color: (listMonths!.length - i == 12)
                                ? Colors.green.withOpacity(
                                0.3) // Highlight 12th payment
                                : Colors.transparent,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${listMonths!.length - i}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${listMonths![i]['date']}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${listMonths![i]['amount']}"),
                            ),
                          ],
                        ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
