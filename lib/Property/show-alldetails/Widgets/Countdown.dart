import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onpensea/Property/show-alldetails/Models/buyermodel.dart';
import '../../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../../config/CustomTheme.dart';
import '../../../widgets/CustomButton.dart';
import '../Screens/UploadScreenshot.dart';

class Countdown extends StatefulWidget {
  final Buyer prop;
  final String name;
  final String remarks;
  final String userId;
  final String username;
  final String screenstatus;
  final String tokenPrice;

  const Countdown(
      {super.key,
        required this.prop,
        required this.name,
        required this.remarks,
        required this.username,
        required this.userId,
        required this.screenstatus,
        required this.tokenPrice});
  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  int _minutes = 4;
  int _seconds = 0;
  late Timer _timer;
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? walletAddress;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    getUsername();
    startTimer();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_minutes > 0 || _seconds > 0) {
          if (_seconds == 0) {
            _minutes--;
            _seconds = 59;
          } else {
            _seconds--;
          }
        } else {
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _scaffoldKey.currentState?.dispose();
    super.dispose();
  }




  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();

    print("getrer: ${widget.tokenPrice}");

    setState(() {
      username = prefs.getString('username');
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
      userType = prefs.getString("userType");
      walletAddress = prefs.getString("walletAddress");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 8.0),
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => UploadScreenshot(
                        //           tokenPrice: widget.tokenPrice,
                        //           prop: widget.prop,
                        //           name: widget.name,
                        //           remarks: widget.remarks,
                        //           username: widget.username,
                        //           userId: widget.userId,
                        //           screenstatus: widget.screenstatus,
                        //         )));
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
                      child: Text(
                        "Next",
                        style: GoogleFonts.inter(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      key: _scaffoldKey,
      drawer: DashboardDrawer(
          walletAddress: walletAddress,
          userType: userType,
          username: username,
          email: email,
          mobile: mobile,
          photo: photo),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator(
                        value: 1 - (_minutes * 60 + _seconds) / 240,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$_minutes min $_seconds sec',
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.headline6,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Instructions:",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "1. Copy the private address.",
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context).textTheme.headlineMedium,
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "2. Open the metamask wallet app in you mobile.",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "3. Select the property which you want to sell.",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "4. Click on send and paste the private address.",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "5. Enter the total tokens you want to sell and click sell.",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "6. Upon Successfull token transfer take the screenshot and redirect back to the o3 application.",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "7. Press close button and continue to the next screen.",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                  ),
                ),
                SizedBox(height: 50),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
