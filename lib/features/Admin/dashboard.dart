import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _selectedIndex = 0.obs;

  static const List<String> _titles = ['Day', 'Week', 'Month', 'Year'];
  static const List<Color> _colors = [
    Colors.white,     // Day color
    Colors.greenAccent,   // Week color
    Colors.amber,    // Month color
    Colors.cyanAccent   // Year color
  ];
  void onTappedFunction(int index) {
    setState(() {
      _selectedIndex.value = index;
    });
    print("index value is:$index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors[_selectedIndex.value],
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child:SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.blue[700],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navbarFunction('Day', 0),
                      _buildVerticalDivider(),
                      navbarFunction('Week', 1),
                      _buildVerticalDivider(),
                      navbarFunction('Month', 2),
                      _buildVerticalDivider(),
                      navbarFunction('Year', 3),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  color: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Center(
                    child: Text(
                      "Total Amount: \$1234.56",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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
        child: Column(
          children: [
            totalTransactionFunction(),
           // SizedBox(height: 20),
            SingleChildScrollView(
              child:tableFunction() ,
            )
            ,
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          //padding: const EdgeInsets.all(0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                accountName: Text(
                  "Shubham Pawar",
                  style: TextStyle(fontSize: 15),
                ),
                accountEmail: Text("Admin@gmail.com"),
                currentAccountPictureSize: Size.square(47),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    "S",
                    style: TextStyle(fontSize: 28.0, color: Colors.green),
                  ), //Text
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ),
            SizedBox(height: 15.0),//DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(' My Profile '),
              onTap: () {
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(' Edit Profile '),
              onTap: () {
              },
            ),
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Back'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('LogOut'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ), //Drawer,
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
            color: _selectedIndex == index ? Colors.white : Colors.white70,
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
                child: Text('Received', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('10',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),), // Received value
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Accepted',style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('20',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),// Accepted value
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('In Transit',style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                  child: Text('30',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),), // In Transit value
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Delivered',style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('40',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),), // Delivered value
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
                child: Text(
                    'ID', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Image', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Name', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'View', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('1'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('png'), // Sample image
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Abcd'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    // View action
                  },
                  child: Text('View'),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('1'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('xyz'), // Sample image
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Item 1'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    // View action
                  },
                  child: Text('View'),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('1'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('xyz'), // Sample image
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Item 1'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    // View action
                  },
                  child: Text('View'),
                ),
              ),
            ],
          ),
          // Add more TableRow widgets here as needed
        ],
      ),
    );
  }

}
