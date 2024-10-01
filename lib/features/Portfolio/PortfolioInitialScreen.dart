import "package:fl_chart/fl_chart.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "package:onpensea/utils/constants/colors.dart";
import "../authentication/screens/login/Controller/LoginController.dart";
import "PortFolioController.dart";
import "PortfolioBarGraph.dart";

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  Map<String, dynamic>? portfolioResponseModel;
  int? totalInvestment;
  List<Map<String, dynamic>>? list;
  bool isLoading = true;
  final loginController = Get.find<LoginController>();


  @override
  void initState() {
    super.initState();
    loadPortfolio();
  }

  Future<void> loadPortfolio() async {
    portfolioResponseModel =
        (await PortFolioController.getPortfolio())?.cast<String, dynamic>();
    totalInvestment = portfolioResponseModel?["totalInvestment"];

    // Casting the 'object' to List<Map<String, dynamic>>
    list = (portfolioResponseModel?["object"] as List)
        ?.map((item) => item as Map<String, dynamic>)
        .toList();

    print("list: $list");
    print(portfolioResponseModel?["totalInvestment"]);
    setState(() {
      isLoading = false;
    });
  }

  final List<Color> colors = [
    Colors.green,
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.brown,
    Colors.cyan,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "${loginController.userData['name'] != null ? "${loginController.userData['name']}'s" : 'Guest'} Portfolio",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 70,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  gradient: LinearGradient(
                    colors: [
                      U_Colors.chatprimaryColor,
                      U_Colors.chatprimaryColor
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Total Investment : ₹ ${totalInvestment}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 25),
                  ),
                ),
              ),
              Container(
                width: 180,
                height: 350,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 350,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              startDegreeOffset: 200,
                              sectionsSpace: 5,
                              centerSpaceRadius: 85,
                              sections: [
                                if (list != null)
                                  for (var data in list!)
                                    PieChartSectionData(
                                        value: double.parse(
                                            data['totalInvestment']),
                                        color: colors[list!.indexOf(data) %
                                            colors.length],
                                        radius: 65,
                                        showTitle: true,
                                        //title: data["investmentName"],
                                        titleStyle: TextStyle(fontSize: 10)),
                              ],
                            ),
                          ),
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 130,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 20.0,
                                        spreadRadius: 10.0,
                                        offset: const Offset(3.0, 3.0),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${totalInvestment ?? "0"}',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Legend
              if (list != null)
                Container(
                 // height: 90,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Column(
                      children: [
                        for (var data in list!)
                          Row(
                            children: [
                              Container(
                                width: 18,
                                height: 15,
                                color:
                                    colors[list!.indexOf(data) % colors.length],
                              ),
                              SizedBox(width: 5),
                              Text(" ${data["investmentName"]}"),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 15,),
              Container(
                padding: const EdgeInsets.all(3),
                child: Table(
                  textDirection: TextDirection.ltr,
                  border: TableBorder.all(width: 1.0, color: Colors.grey),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Scheme Name",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Amount (₹)",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("View",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ]),
                    if (list != null)
                      for (var data in list!)
                        TableRow(children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BarChartSample(
                                      investmentId: "${data['investmentId']}",
                                      investmentName:
                                          "${data['investmentName']}"),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['investmentName']}"),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BarChartSample(
                                      investmentId: "${data['investmentId']}",
                                      investmentName:
                                          "${data['investmentName']}"),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${data['totalInvestment']}"),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BarChartSample(
                                      investmentId: "${data['investmentId']}",
                                      investmentName:
                                          "${data['investmentName']}"),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.view_agenda,
                                  color: Colors.blue,
                                  size: 14.0,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
