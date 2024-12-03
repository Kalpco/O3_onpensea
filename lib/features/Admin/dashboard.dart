import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _selectedIndex = 0.obs;

  //static const List<String> _titles = [ 'Year','Month','Week',];
  static const List<Color> _colors = [
    Colors.white, // Day color
    Colors.greenAccent, // Week color
    Colors.white ,// Year color


  ];
  void onTappedFunction(int index) {
    setState(() {
      _selectedIndex.value = index;
    });
    print("index value is:$index");
  }

  Widget yearGraph() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Gold Rate Without GST", // Title for the graph
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              height: 350,
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
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        // Hardcoded sample date strings for x-axis labels
                        const List<String> months = [
                          'Jan\n2023',
                          'Feb\n2023',
                          'Mar\n2023',
                          'Apr\n2023',
                          'May\n2023',
                          'Jun\n2023',
                          'Jul\n2023',
                          'Aug\n2023',
                          'Sep\n2023',
                          'Oct\n2023',
                          'Nov\n2023',
                          'Dec\n2023'
                        ];
                        if (value.toInt() - 1 < months.length) {
                          return months[value.toInt() - 1];
                        }
                        return '';
                      },
                      reservedSize: 40,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      reservedSize: 30,
                      getTitles: (value) {
                        // Hardcoded y-axis labels
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
                  borderData: FlBorderData(show: true),
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
                    for (int i = 0; i < 12; i++)
                      BarChartGroupData(
                        x: i + 1,
                        barRods: [
                          BarChartRodData(
                            y: (i + 1) * 1000.0, // Hardcoded y-values for bars
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
          ],
        ),
      ),
    );
  }

  Widget yearGraphWithGST() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Gold Rate With GST", // Title for the graph
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              height: 350,
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
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        // Hardcoded sample date strings for x-axis labels
                        const List<String> months = [
                          'Jan\n2023',
                          'Feb\n2023',
                          'Mar\n2023',
                          'Apr\n2023',
                          'May\n2023',
                          'Jun\n2023',
                          'Jul\n2023',
                          'Aug\n2023',
                          'Sep\n2023',
                          'Oct\n2023',
                          'Nov\n2023',
                          'Dec\n2023'
                        ];
                        if (value.toInt() - 1 < months.length) {
                          return months[value.toInt() - 1];
                        }
                        return '';
                      },
                      reservedSize: 40,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                      reservedSize: 30,
                      getTitles: (value) {
                        // Hardcoded y-axis labels
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
                  borderData: FlBorderData(show: true),
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
                    for (int i = 0; i < 12; i++)
                      BarChartGroupData(
                        x: i + 1,
                        barRods: [
                          BarChartRodData(
                            y: (i + 1) * 1000.0, // Hardcoded y-values for bars
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
          ],
        ),
      ),
    );
  }

  Widget weekGraph() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Gold Rate Without GST", // Title for the graph
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              height: 350,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  maxY: 25000,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (int i = 0; i < 7; i++)
                          FlSpot(i.toDouble() + 1,
                              (i + 1) * 1000.0), // Hardcoded y-values
                      ],
                      isCurved: true,
                      colors: [Colors.greenAccent],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.greenAccent.withOpacity(0.3)],
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        const List<String> months = [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday',
                        ];
                        if (value.toInt() - 1 < months.length) {
                          return months[value.toInt() - 1];
                        }
                        return '';
                      },
                      reservedSize: 40,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
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
                  borderData: FlBorderData(show: true),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget weekGraphWithGST() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Gold Rate With GST", // Title for the graph
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              height: 350,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  maxY: 25000,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (int i = 0; i < 7; i++)
                          FlSpot(i.toDouble() + 1,
                              (i + 1) * 1000.0), // Hardcoded y-values
                      ],
                      isCurved: true,
                      colors: [Colors.greenAccent],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.greenAccent.withOpacity(0.3)],
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        const List<String> months = [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday',
                          'Saturday',
                          'Sunday',
                        ];
                        if (value.toInt() - 1 < months.length) {
                          return months[value.toInt() - 1];
                        }
                        return '';
                      },
                      reservedSize: 40,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
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
                  borderData: FlBorderData(show: true),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget monthGraph() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              "Golds Rate Without GST", // Title for the graph
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              height: 350,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  maxY: 25000,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots:  [
                        FlSpot(1, 2000),
                        FlSpot(2, 4000),
                        FlSpot(3, 6000),
                        FlSpot(4, 8000),
                      ],
                      isCurved: true,
                      colors: [Colors.greenAccent],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.greenAccent.withOpacity(0.3)],
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        const List<String> months = [
                          'Week1',
                          'Week2',
                          'Week3',
                          'Week4'
                        ];
                        if (value.toInt() - 1 < months.length) {
                          return months[value.toInt() - 1];
                        }
                        return '';
                      },
                      reservedSize: 40,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
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
                  borderData: FlBorderData(show: true),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget monthGraphWithGST() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text(
              "Gold Rate With GST", // Title for the graph
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(
              height: 350,
              width: double.infinity,
              child: LineChart(
                LineChartData(
                  maxY: 25000,
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        for (int i = 0; i < 4; i++)
                          FlSpot(i.toDouble() + 1,
                              (i + 1) * 2000.0), // Hardcoded y-values
                      ],
                      isCurved: true,
                      colors: [Colors.greenAccent],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.greenAccent.withOpacity(0.3)],
                      ),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 8,
                      ),
                      margin: 16,
                      getTitles: (double value) {
                        const List<String> months = [
                          'Week1',
                          'Week2',
                          'Week3',
                          'Week4'
                        ];
                        if (value.toInt() - 1 < months.length) {
                          return months[value.toInt() - 1];
                        }
                        return '';
                      },
                      reservedSize: 40,
                    ),
                    leftTitles: SideTitles(
                      showTitles: true,
                      getTextStyles: (context, value) => const TextStyle(
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
                  borderData: FlBorderData(show: true),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors[_selectedIndex.value],
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.blue[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navbarFunction('Year', 0),
                      _buildVerticalDivider(),
                     // navbarFunction('Month', 1),
                      navbarFunction('Week', 2),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  color: U_Colors.satinSheenGold,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(
                    child: Text(
                      "Todays Gold Rate: \$7000",
                      style: TextStyle(
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
              SizedBox(height: 20),
              SingleChildScrollView(
                child: tableFunction(),
              ),
              if (_selectedIndex.value == 0)
                SingleChildScrollView(
                  child: Column(
                    children: [yearGraph(), yearGraphWithGST()],
                  ),
                ),
              if (_selectedIndex.value == 1)
                SingleChildScrollView(
                  child: Column(
                    children: [
                      monthGraph(),
                      monthGraphWithGST(),
                    ]),
                ),
              if (_selectedIndex.value == 2)
                SingleChildScrollView(
                  child: Column(
                    children: [
                      weekGraph(),
                      weekGraphWithGST()
                    ],
                  ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
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

  Widget tableFunction() {
    return Container(
      child: Table(
        border: TableBorder.all(
          color: Colors.blueAccent, // Color of the border lines
          width: 1.0, // Thickness of the border lines
        ),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.green[300]),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Carat(K) ',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Todays Price',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Yesterdays Price',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('18K'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('₹ 6000'), // Sample image
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('₹ 6100 '),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('22K'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('₹ 6500'), // Sample image
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('₹ 6400'),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('24K'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('₹ 7500'), // Sample image
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('₹ 7400'),
              ),
            ],
          ),
          // Add more TableRow widgets here as needed
        ],
      ),
    );
  }
}
