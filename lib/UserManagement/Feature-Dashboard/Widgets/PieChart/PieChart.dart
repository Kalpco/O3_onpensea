import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyPieChart extends StatefulWidget {
  String totalBuyCount;
  String totalSellCount;
  String totalPropCount;
  String totalTokeHoldigs;
  String totalTokenPrice;
  final String userType;

  MyPieChart(
      {Key? key,
      required this.totalTokeHoldigs,
      required this.totalSellCount,
      required this.totalTokenPrice,
      required this.totalBuyCount,
      required this.totalPropCount,
      required this.userType})
      : super(key: key);

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  List<ChartData> getFilteredData() {
    var userType = widget.userType;
    var data = userType == "ADMIN"
        ? [
            ChartData("Txn Count", double.parse(widget.totalTokenPrice)),
            ChartData("Buy Count", double.parse(widget.totalBuyCount)),
            ChartData("Property Count", double.parse(widget.totalPropCount)),
            ChartData("Sell Count", double.parse(widget.totalSellCount)),
            ChartData("Token Count", double.parse(widget.totalTokeHoldigs)),
          ]
        : [
            //ChartData("totalTokenPrice", double.parse(widget.totalTokenPrice)),
            ChartData("totalBuyCount", double.parse(widget.totalBuyCount)),
            ChartData("totalPropCount", double.parse(widget.totalPropCount)),
            ChartData("totalSellCount", double.parse(widget.totalSellCount)),
            ChartData(
                "totalTokeHoldigs", double.parse(widget.totalTokeHoldigs)),
          ];

    // Filter data where y (value) is not zero
    return data.where((chartData) => chartData.y != 0).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: SfCircularChart(
        title: ChartTitle(
            text:   widget.userType == "ADMIN" ? "Admin Count Details" : "User Count Details",
            textStyle: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.normal,
            )),
        tooltipBehavior: _tooltipBehavior,
        legend: Legend(
          isVisible: true,
          isResponsive: false,
          textStyle: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 10,
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        series: <CircularSeries>[
          PieSeries<ChartData, String>(
            dataSource: getFilteredData(),
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            radius: "100%",
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              useSeriesColor: true,
              // Avoid labels intersection
              labelIntersectAction: LabelIntersectAction.shift,
              labelPosition: ChartDataLabelPosition.outside,
              connectorLineSettings: ConnectorLineSettings(
                  type: ConnectorType.curve, length: '15%'),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
