import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Admin/Feature-VerifyBuy/Widgets/carousel_slider.dart';
import 'package:onpensea/Token/Widgets/token_cards_widget/carousel_token_card.dart';
import 'package:onpensea/Token/Widgets/token_list_widget/token_watch_list.dart';
import 'package:onpensea/Token/Widgets/token_summary_widget/token_summary.dart';
import 'package:onpensea/Token/controller/TokenPriceController.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import '../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../Property/show-alldetails/Screens/BoughtProperties.dart';
import '../../UserManagement/Feature-Dashboard/Screens/WidgetToDisplayAlltheCities.dart';
import '../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../config/ApiUrl.dart';
import '../../config/CustomTheme.dart';
import '../Model/TokenPriceModel.dart';

class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? walletAddress;
  Future<List<TokenPriceModel>>? props;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    // getTokenPriceList();
    props = TokenPriceController.fetchAllTokens();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
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
  void dispose() {
    _scaffoldKey.currentState?.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      key: _scaffoldKey,
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
      drawer: DashboardDrawer(
          walletAddress: walletAddress,
          userType: userType,
          username: username,
          email: email,
          mobile: mobile,
          photo: photo),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        elevation: 22,
        color: Colors.white38,
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
                          height: 1,
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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            props = TokenPriceController.fetchAllTokens();
          });
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                CarouselTokenCard(
                  props: props!,
                ),
                const SizedBox(
                  height: 20,
                ),
                const TokenSummary(),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Text(
                            'Sort ',
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineLarge,
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const Icon(
                            Icons.sort,
                            color: Colors.green,
                            size: 16,
                          ),
                        ],
                      ),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        children: [
                          const Icon(
                            Icons.arrow_circle_down_rounded,
                            color: Colors.green,
                            size: 18,
                          ),
                          Text(
                            ' Current (invested) ',
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineLarge,
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                TokenWatchList(props: props!),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: Text(
                  "Verify holdings",
                  style: GoogleFonts.poppins(
                    textStyle: Theme.of(context).textTheme.headlineLarge,
                    fontSize: 14,
                    color: CustomTheme.fifthColor,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  ),
                )),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
