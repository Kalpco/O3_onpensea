import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:onpensea/commons/config/api_constants.dart';

import '../../network/dio_client.dart';
import '../../utils/constants/colors.dart';
import 'goldRateMonthCalender.dart';
import 'models/goldRateDTO.dart';
import 'models/last7DaysGoldRateDTO.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _selectedIndex = 1.obs;
  final dio = DioClient.getInstance();


  //static const List<String> _titles = [ 'Year','Month','Week',];
  static const List<Color> _colors = [
    Colors.white, // Day color
    Colors.white, // Week color
    Colors.white ,// Year color


  ];
  void onTappedFunction(int index) {
    setState(() {
      _selectedIndex.value = index;
    });
    print("index value is:$index");
  }


  Widget weekGraph(List<Last7DaysGoldRateDTO> last7Days) {
    if (last7Days.isEmpty) {
      return const Text("No data available");
    }

    // Sort dates
    last7Days.sort((a, b) => a.date.compareTo(b.date));
    // Prepare spots for each carat
    final spots24k = <FlSpot>[];
    final spots22k = <FlSpot>[];
    final spots18k = <FlSpot>[];

    for (int i = 0; i < last7Days.length; i++) {
      final data = last7Days[i];
      spots24k.add(FlSpot(i.toDouble(), data.priceGram24k));
      spots22k.add(FlSpot(i.toDouble(), data.priceGram22k));
      spots18k.add(FlSpot(i.toDouble(), data.priceGram18k));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "1 gm Gold Rate  (Last 7 Days)",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: U_Colors.yaleBlue,
              ),
            ),
            SizedBox(height: 10,),
            SizedBox(
              height: 300,
              width: double.maxFinite,
              child: LineChart(
                LineChartData(
                  minY: 5000,
                  maxY: 12000,
                  lineTouchData: LineTouchData(
                    handleBuiltInTouches: true,
                    touchTooltipData: LineTouchTooltipData(
                      tooltipBgColor: Colors.white, // Background color
                      tooltipRoundedRadius: 12,
                      tooltipPadding: const EdgeInsets.all(12),
                      tooltipMargin: 12,
                      fitInsideHorizontally: true,
                      fitInsideVertically: true,

                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((spot) {
                          String label;
                          TextStyle style;

                          if (spot.bar.colors.contains(U_Colors.yaleBlue)) {
                            label = '24K: ₹${spot.y.toStringAsFixed(2)}';
                            style = const TextStyle(
                              color: U_Colors.yaleBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            );
                          } else if (spot.bar.colors.contains(Colors.orange)) {
                            label = '22K: ₹${spot.y.toStringAsFixed(2)}';
                            style = const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            );
                          } else {
                            label = '18K: ₹${spot.y.toStringAsFixed(2)}';
                            style = const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            );
                          }

                          return LineTooltipItem(label, style);
                        }).toList();
                      },
                    ),
                  ),

                  lineBarsData: [
                    //24K
                    LineChartBarData(
                      spots: spots24k,
                      isCurved: true,
                      colors: [U_Colors.yaleBlue],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.white],
                      ),
                      dotData: FlDotData(show: true),
                    ),
                    // 22K
                    LineChartBarData(
                      spots: spots22k,
                      isCurved: true,
                      colors: [Colors.orange],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.white],
                      ),
                      dotData: FlDotData(show: true),
                    ),
                    // 18K
                    LineChartBarData(
                      spots: spots18k,
                      isCurved: true,
                      colors: [Colors.green],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.white],
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      interval: 1000, // 👈 Forces the Y-axis to label every 2000 units
                      getTitles: (value) {
                        if (value % 1000 == 0 && value <= 12000) {
                          return '${(value ~/ 1000)}K';
                        }
                        return '';
                      },
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      reservedSize: 35,
                    ),


                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTitles: (value) {
                        int index = value.toInt();
                        if (index >= 0 && index < last7Days.length) {
                          final date = last7Days[index].date;
                          return DateFormat('dd/MM').format(date); // e.g., 2 Jun
                        }
                        return '';
                      },
                      interval: 1,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      margin: 10,
                    ),
                    topTitles: SideTitles(showTitles: false),
                    rightTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(show: true),
                  gridData: FlGridData(show: true),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Legend row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _legendDot(U_Colors.yaleBlue, '24K'),
                const SizedBox(width: 10),
                _legendDot(Colors.orange, '22K'),
                const SizedBox(width: 10),
                _legendDot(Colors.green, '18K'),
              ],
            ),
          ],
        ),
      ),
    );
  }



  Future<List<GoldRateEntryDTO>> fetchGoldRates() async {
    final response = await dio.get('${ApiConstants.PRODUCTS_BASE_URL}/fetch/goldRate');
    if (response.statusCode == 200) {
      return parseGoldRates(response.data);
    } else {
      throw Exception('Failed to load gold rate data');
    }
  }

  List<GoldRateEntryDTO> parseGoldRates(Map<String, dynamic> json) {
    final today = json['today'];
    final yesterday = json['yesterday'];
    final last7Days = (json['last7Days'] as List)
        .map((e) => Last7DaysGoldRateDTO.fromJson(e))
        .toList();
    final monthList = (json['monthRates'] as List)
        .map((e) => Last7DaysGoldRateDTO.fromJson(e))
        .toList();

    return [
      GoldRateEntryDTO(
        carat: '24K',
        todayPrice: today['price_gram_24k'],
        yesterdayPrice: yesterday['price_gram_24k'],
        last7DaysList: last7Days,
        monthList: monthList
      ),
      GoldRateEntryDTO(
        carat: '22K',
        todayPrice: today['price_gram_22k'],
        yesterdayPrice: yesterday['price_gram_22k'],
        last7DaysList: last7Days,
          monthList: monthList

      ),
      GoldRateEntryDTO(
        carat: '18K',
        todayPrice: today['price_gram_18k'],
        yesterdayPrice: yesterday['price_gram_18k'],
        last7DaysList: last7Days,
          monthList: monthList

      ),

    ];
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GoldRateEntryDTO>>(
      future: fetchGoldRates(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: U_Colors.yaleBlue,));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          print("Available carats: ${data.map((d) => d.carat).toList()}");


          return Scaffold(
            backgroundColor: _colors[_selectedIndex.value],
            appBar: AppBar(
              backgroundColor: Colors.white60,
              title: const Text('Admin Dashboard'),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(100.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: U_Colors.yaleBlue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            navbarFunction('Month', 1),
                            _buildVerticalDivider(),
                            navbarFunction('Week', 2),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15.0),
                      Container(
                        color: U_Colors.satinSheenGold,
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Center(
                          child: Text(
                            "Today's Gold Rate: ₹${data.first.todayPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    tableFunction(data),
                    // if (_selectedIndex.value == 0)
                    //   Column(
                    //     children: [yearGraph(), yearGraphWithGST()],
                    //   ),
                    if (_selectedIndex.value == 1)
                      Column(
                        children: [GoldRateMonthCalendar(monthRates: data.firstWhere((d) => d.carat == '24K').monthList ?? [],)],
                      ),

                    // 📈 Week Graph (with last 7 days data)
                    if (_selectedIndex.value == 2) ...[
                      Builder(
                        builder: (context) {
                          try {
                            final gold24k = data.firstWhere((d) => d.carat == '24K');

                            final last7List = gold24k.last7DaysList ?? [];
                            if (last7List.isEmpty) {
                              return const Text('No weekly data available');
                            }
                            return Column(
                              children: [
                                weekGraph(last7List),
                                // weekGraphWithGST(), // Add similar logic if needed
                              ],
                            );
                          } catch (e) {
                            return const Text('24k data not available for week graph.');
                          }
                        },
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text("No data available"));
        }
      },
    );
  }

  Widget navbarFunction(String text, int index) {
    return InkWell(
      onTap: () => onTappedFunction(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11.0),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedIndex.value == index ? Colors.white : Colors.white70,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40.0,
      width: 1.0,
      color: Colors.white,
    );
  }

  Widget totalTransactionFunction() {
    return Container(
      height: 180,
      width: 500,
      child: Table(
        border: TableBorder.all(
          color: Colors.blueAccent, // Color of the border lines
          width: 1.0, // Thickness of the border lines
        ),
        // columnWidths: const {
        //   0: FlexColumnWidth(), // Distribute space equally among the columns
        //   1: FlexColumnWidth(),
        // },
        children: const [
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Received',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '10',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ), // Received value
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Accepted',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '20',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ), // Accepted value
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('In Transit',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '30',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ), // In Transit value
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Delivered',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '40',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ), // Delivered value
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tableFunction(List<GoldRateEntryDTO> rates) {
    return Container(
      child: Table(
        border: TableBorder.all(color: U_Colors.yaleBlue, width: 1.0),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: U_Colors.satinSheenGold),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('Carat(K)', style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('Today\'s Price', style: TextStyle(fontWeight: FontWeight.bold))),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('Yesterday\'s Price', style: TextStyle(fontWeight: FontWeight.bold))),
              ),
            ],
          ),
          ...rates.map((rate) => TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text(rate.carat)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('₹ ${rate.todayPrice.toStringAsFixed(2)}')),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: Text('₹ ${rate.yesterdayPrice.toStringAsFixed(2)}')),
              ),
            ],
          )),
        ],
      ),
    );
  }



}

Widget _legendDot(Color color, String text) {
  return Row(
    children: [
      Container(width: 12, height: 12, color: color),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}
