import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "../../Property/Feature-ShowAllDetails/Controller/PropertyController.dart";
import '../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import '../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../Property/Feature-registerNewProperty/Controller/RegisterPropertyController.dart';
import '../../Property/Feature-registerNewProperty/Model/RegisterPropertyModel.dart';
import '../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../UserManagement/Feature-Dashboard/Screens/common_dashboard_screen.dart';
import '../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../Property/Feature-ShowAllDetails/Models/Properties.dart';
import '../../config/CustomTheme.dart';

class InitiatingPaymentScreen extends StatefulWidget {
  final String? propName;
  final String? address;
  final String? city;
  final String? pincode;
  final String? state;
  final String? propValue;
  final String? ownerName;
  final String? ownerId;
  final String? tokenRequested;
  final String? tokenName;
  final String? tokenSymbol;
  final String? tokenCapacity;
  final String? tokenSupply;
  final String? tokenBalance;
  final XFile? image1;
  final XFile? image2;
  final XFile? image3;
  final File? saleDeed;
  final String? userName;
  final String? screenStatus;

  const InitiatingPaymentScreen({
    super.key,
    required this.propName,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.propValue,
    required this.ownerName,
    required this.ownerId,
    required this.tokenRequested,
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenCapacity,
    required this.tokenSupply,
    required this.tokenBalance,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.saleDeed,
    required this.userName,
    required this.screenStatus,
  });

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
      callApi();
    });
  }

  void callApi() {
    EasyLoading.show(status: "Registering...");
    final rpm = RegisterPropertyModel(
      propName: widget.propName!,
      address: widget.address!,
      city: widget.city!,
      pincode: widget.pincode!,
      state: widget.state!,
      propValue: widget.propValue!,
      ownerName: username!,
      ownerId: widget.ownerId!,
      tokenRequested: widget.tokenRequested!,
      tokenName: widget.tokenName!,
      tokenSymbol: widget.tokenSymbol!,
      tokenCapacity: widget.tokenCapacity!,
      tokenSupply: widget.tokenSupply!,
      tokenBalance: widget.tokenBalance!,
      image1: widget.image1,
      image2: widget.image2,
      image3: widget.image3,
      saleDeed: widget.saleDeed,
      userName: username,
    );
    print("++++++++++++++++++++++++++++++");
    print(rpm.toString());
    print("_______________-----------_-------");
    print(rpm);
    var duration = Duration(seconds: 3);

    Timer(duration, () async {

      final response = await RegisterPropertyController.registerProperty(rpm);

      if (response == "true") {
        EasyLoading.showSuccess("payment successfull");
        Timer(Duration(milliseconds: 1000), () {
          EasyLoading.showSuccess("${widget.propName} registered successfully");
        });

        Timer(Duration(seconds: 2), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DashboardScreen(
                        email: email!,
                      )));
        });
      } else {
        EasyLoading.showError("${widget.propName} registration failed");
        Timer(Duration(seconds: 2), () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DashboardScreen(
                        email: email!,
                      )));
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
                              builder: (context) =>
                              userType == "ADMIN"
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
                            height: 1,
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
                              builder: (context) =>
                              userType == "ADMIN"
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
                            height: 1,
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
                              builder: (context) =>
                              userType == "ADMIN"
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
                            height: 1,
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
                            height: 1,
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
