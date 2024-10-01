import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment Returns',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: InvestmentReturnsPage(),
    );
  }
}

class InvestmentReturnsPage extends StatefulWidget {
  @override
  _InvestmentReturnsPageState createState() => _InvestmentReturnsPageState();
}

class _InvestmentReturnsPageState extends State<InvestmentReturnsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Investment Returns',
          style: GoogleFonts.roboto(),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[200],
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'One Time'),
                Tab(text: 'Monthly'),
              ],
              labelColor: Colors.red,
              unselectedLabelColor: Colors.black,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                InvestmentTable(),
                InvestmentTable(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InvestmentTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            color: Colors.grey[200],
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              children: [
                InvestmentTableHeader(),
                InvestmentTableRow(
                  month: '1',
                  purchase: '95000',
                  gold: '13.571',
                  redeemable: '102294.17',
                ),
                // Add more rows as needed
                InvestmentTableRow(
                  month: '12',
                  purchase: '95000',
                  gold: '13.571',
                  redeemable: '112556.06',
                ),
                InvestmentTableRow(
                  month: '12',
                  purchase: '95000',
                  gold: '13.571',
                  redeemable: '112556.06',
                ),
                InvestmentTableRow(
                  month: '12',
                  purchase: '95000',
                  gold: '13.571',
                  redeemable: '112556.06',
                ),InvestmentTableRow(
                  month: '12',
                  purchase: '95000',
                  gold: '13.571',
                  redeemable: '112556.06',
                ),
                InvestmentTableRow(
                  month: '12',
                  purchase: '95000',
                  gold: '13.571',
                  redeemable: '112556.06',
                ),InvestmentTableRow(
                  month: '12',
                  purchase: '95000',
                  gold: '13.571',
                  redeemable: '112556.06',
                ),



                InvestmentTableFooter(
                  totalPurchase: '95000',
                  totalGold: '13.571',
                  totalRedeemable: '112556.06',
                ),

              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Handle back arrow click
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  // Handle forward arrow click
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InvestmentTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Months', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 10)),
        Text('Monthly Purchase', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 10)),
        Text('Gold Onetime', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 10)),
        Text('Redeemable Amount', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 10)),
      ],
    );
  }
}

class InvestmentTableRow extends StatelessWidget {
  final String month;
  final String purchase;
  final String gold;
  final String redeemable;

  InvestmentTableRow({
    required this.month,
    required this.purchase,
    required this.gold,
    required this.redeemable,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(month),
          Text(purchase),
          Text(gold),
          Text(redeemable),
        ],
      ),
    );
  }
}

class InvestmentTableFooter extends StatelessWidget {
  final String totalPurchase;
  final String totalGold;
  final String totalRedeemable;

  InvestmentTableFooter({
    required this.totalPurchase,
    required this.totalGold,
    required this.totalRedeemable,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Total', style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 11)),
          Text(totalPurchase),
          Text(totalGold),
          Text(totalRedeemable),
        ],
      ),
    );
  }
}
