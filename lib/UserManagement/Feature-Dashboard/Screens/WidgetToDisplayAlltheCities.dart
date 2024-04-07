import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import '../../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../../Property/show-alldetails/Screens/BoughtProperties.dart';
import '../../../Token/Screen/token_screen.dart';
import '../../../config/CustomTheme.dart';
import '../../../widgets/CustomButton.dart';
import '../Widgets/Drawer/DashboardDrawer.dart';

class ScreenToDisplayAlltheCities extends StatefulWidget {
  final String screenStatus;

  const ScreenToDisplayAlltheCities({super.key, required this.screenStatus});

  @override
  _ScreenToDisplayAlltheCitiesState createState() =>
      _ScreenToDisplayAlltheCitiesState();
}

class _ScreenToDisplayAlltheCitiesState
    extends State<ScreenToDisplayAlltheCities> {
  final images = [
    'https://c.ndtvimg.com/2020-08/uhj0f4s8_noida-generic-noida-city-generic-istock_625x300_01_August_20.jpg',
    'https://cdn.britannica.com/26/84526-050-45452C37/Gateway-monument-India-entrance-Mumbai-Harbour-coast.jpg',
    'https://lp-cms-production.imgix.net/2019-06/9483508eeee2b78a7356a15ed9c337a1-bengaluru-bangalore.jpg',
    'https://www.thoughtco.com/thmb/8hRkNpA3eA7UU5VH9k63iDbU0OE=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/swaminarayan-akshardham-temple--the-biggest-hindu-temple-in-the-world--new-delhi--india-827546130-5a4e9693494ec90036e9373d.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Sheth_Hutheesinh_Temple.jpg/1200px-Sheth_Hutheesinh_Temple.jpg',
    'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Amanora_Skyline.jpg/288px-Amanora_Skyline.jpg',
    'https://img.etimg.com/thumb/width-640,height-480,imgsize-743860,resizemode-75,msid-65653857/wealth/real-estate/dlf-to-invest-over-rs-1400-crore-in-commercial-project-in-gurgaon/gurgaon-real-estate-bccl.jpg',
    'https://img.staticmb.com/mbcontent/images/uploads/2022/6/posh-societies-in-ghaziabad_1656004265200.jpg',
    'https://cdn.dnaindia.com/sites/default/files/styles/full/public/2023/02/12/2572309-untitled-design-2023-01-20t140152.355.png',
    'https://cdn.britannica.com/75/121075-050-CBF79FB6/Victoria-Statue-front-Memorial-Hall-Kolkata-West.jpg',
    'https://pbs.twimg.com/media/F_teDBwbQAA3l5d.jpg:large',
    'https://static.toiimg.com/thumb/104444282/Hyderabad.jpg?width=1200&height=900',
    // Replace with your image URLs
    // Add more image URLs as needed
  ];

  final cities = [
    'Noida',
    'Mumbai',
    'Bangalore',
    'New Delhi',
    'Ahmedabad',
    'Pune',
    'Gurgaon',
    'Ghaziabad',
    'Greater Noida',
    'Kolkata',
    'Chennai',
    'Hyderabad',
  ];

  List<String> filteredCities = [];

  @override
  void initState() {
    filteredCities = cities;
    super.initState();
    print("photo");
    print(photo);
    getUsername();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? walletAddress;

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
      userType = prefs.getString("userType");
      walletAddress  = prefs.getString("walletAddress");
    });
  }

  void filterCities(String query) {
    setState(() {
      filteredCities = cities
          .where(
              (city) => city.toLowerCase().contains(query.toLowerCase().trim()))
          .toList();
    });
  }

  @override
  void dispose() {
    _scaffoldKey.currentState?.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final columns = 3; // Number of avatars per row

    return Scaffold(
      key: _scaffoldKey,
      drawer: DashboardDrawer(
          walletAddress: walletAddress,
          userType: userType,
          username: username,
          email: email,
          mobile: mobile,
          photo: photo),
      bottomNavigationBar: BottomAppBar(
        height: 75,
        elevation: 22,
        color: Colors.white38,

        ///shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userType == "ADMIN"
                                ? const ShowAllVerifyBuy(
                                    screenStatus: "buy",
                                  )
                                : const ScreenToDisplayAlltheCities(
                                    screenStatus: "buy",
                                  )),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.bubble_chart),
                        SizedBox(
                          height: 3,
                        ),

                        /// icon
                        Text("Buy"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userType == "ADMIN"
                                ? const ShowAllVerifySell(
                                    screenStatus: "sell",
                                  )
                                : const BoughtProperties(
                                    screenStatus: "sell",
                                  )),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.sell),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Sell"),

                        /// text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userType == "ADMIN"
                                ? ShowAllPendingProperties(
                                    screenStatus: "buy",
                                  )
                                : const RegisterPropertyOne()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.house),
                        SizedBox(
                          height: 3,
                        ),

                        /// icon
                        Text("Property"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TokenScreen()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.devices_other),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Holdings"), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: CustomTheme.customLinearGradient,
          ),
        ),
        title: Text(
          username == "NA" ? "Welcome Dummy" : "Welcome ${username}",
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: photo == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.green,
                    )
                  : Container(
                      padding: const EdgeInsets.all(0), // Border width
                      decoration: const BoxDecoration(
                          color: Colors.transparent, shape: BoxShape.circle),
                      child: ClipOval(
                        child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child: photo == "NA"
                                ? const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                                  )
                                : CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        MemoryImage(base64Decode(photo!)),
                                  )),
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: MediaQuery(
        data: MediaQuery.of(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'You are looking to buy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    onChanged: (value) {
                      filterCities(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter a city or Project',
                      /*prefixIcon: Icon(Icons.search),*/
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Popular Cities:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 8.0, // Spacing between avatars
                    mainAxisSpacing: 8.0,
                  ),
                  itemCount: filteredCities.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(images[index]),
                          radius: 20, // Set the desired radius here
                        ),
                        SizedBox(height: 4), // Spacing between avatar and text
                        Text(
                          filteredCities[index],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Positioned(
                  bottom: 50,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              child: CustomButton(
                                text: "Back",
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              height: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ShowAllVerifiedProperties(
                                                screenStatus: 'buy')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  backgroundColor: Colors.purple.shade900,
                                  textStyle: GoogleFonts.inter(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                child: const Text(
                                  "Submit",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
