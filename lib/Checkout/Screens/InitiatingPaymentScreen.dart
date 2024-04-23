import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../../Property/Feature-ShowAllDetails/Controller/PropertyController.dart";
import '../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import '../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../Property/Feature-ShowAllDetails/Models/Properties.dart';
import '../../config/CustomTheme.dart';

class InitiatingPaymentScreen extends StatefulWidget {
  final Properties? prop;
  final String? propertyName;
  final String? tokenName;
  final String? tokenCount;
  final String? tokenPrice;
  final String? remarks;
  final String? screenStatus;

  const InitiatingPaymentScreen(
      {super.key,
      required this.prop,
      required this.propertyName,
      required this.tokenName,
      required this.tokenCount,
      required this.tokenPrice,
      required this.remarks,
      required this.screenStatus});

  @override
  State<InitiatingPaymentScreen> createState() =>
      _InitiatingPaymentScreenState();
}

class _InitiatingPaymentScreenState extends State<InitiatingPaymentScreen> {
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    getUsername();
    Timer(Duration(milliseconds: 3000), () {
      callApi(
          username!, widget.tokenCount!, widget.remarks!, widget.screenStatus!);
    });
  }

  void callApi(String userId, String tokenRequested, String remarks,
      String screenStatus) {
    Timer(Duration(seconds: 3), () async {
      var response = null;
      if (screenStatus == "buy") {
        response = await PropertyController.postTheBuyerRequest(
            widget.prop!, username!, userId!, tokenRequested, remarks);
      } else if (screenStatus == "property") {
      } else {
        response = await PropertyController.postTheSellerRequest(
            widget.prop!, username!, userId!, tokenRequested, remarks);
      }

      print(response);

      if (response == "true") {
        EasyLoading.showSuccess("Payment Successfull");
        Timer(Duration(milliseconds: 1000), () {
          EasyLoading.showSuccess(
              "Token ${(screenStatus == "buy") ? "Buy" : "Sell"} Requested Submitted");
        });

        Timer(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowAllVerifiedProperties(
                      screenStatus: screenStatus,
                    )),
          );
        });
      } else {
        EasyLoading.showError("Token Buy Requested Failed");
        Timer(const Duration(seconds: 2), () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShowAllVerifiedProperties(
                      screenStatus: screenStatus,
                    )),
          );
        });
      }
    });
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
      userType = prefs.getString("userType");
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        drawer: DashboardDrawer(
            userType: userType,
            username: username,
            email: email,
            mobile: mobile,
            photo: photo),
        bottomNavigationBar: BottomAppBar(
          height: 70,
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
                                  : const ShowAllVerifiedProperties(
                                      screenStatus: "buy",
                                    )),
                        );
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.bubble_chart),
                          SizedBox(
                            height: 2,
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
                                  : const ShowAllVerifiedProperties(
                                      screenStatus: "sell",
                                    )),
                        );
                      }, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.sell),
                          SizedBox(
                            height: 2,
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
                            height: 2,
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
                      onTap: () {}, // button pressed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Icon(Icons.devices_other),
                          SizedBox(
                            height: 2,
                          ), // icon
                          Text("Others"), // text
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Initiating payment. Donot Click back button"),
              SizedBox(height: 50),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
