import 'dart:async';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:onpensea/Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import 'package:onpensea/Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import 'package:onpensea/Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Controller/DashboardController.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Widgets/DropDown/DropDown.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Widgets/RecentTransaction/RecentTransactions.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Widgets/SlidingCard/SlidingCardWidgetState.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Widgets/YourNewLife/YourNewLife.dart';
import 'package:onpensea/config/CustomTheme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../../Property/show-alldetails/Screens/BoughtProperties.dart';
import '../../../Token/Screen/token_screen.dart';
import '../../../config/ApiUrl.dart';
import '../../../config/UserType.dart';
import '../Model/AllDetails.dart';
import '../Widgets/CarouselWithPictures/CarouselWithPictures.dart';
import '../Widgets/Drawer/DashboardDrawer.dart';
import '../Widgets/PieChart/PieChart.dart';
import '../Widgets/ScrollItem/ScrollItem.dart';
import '../Widgets/Tables/tables.dart';
import '../Widgets/YesWidget/YesWidget.dart';
import 'SearchScreen.dart';
import 'WidgetToDisplayAlltheCities.dart';

class DashboardScreen extends StatefulWidget {
  final String? email;

  const DashboardScreen({super.key, required this.email});

  @override
  State<DashboardScreen> createState() => _DashboardScreen();
}

class _DashboardScreen extends State<DashboardScreen> {
  ///String cdate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String searchText = '';
  List<dynamic>? transactionDetails;
  List<dynamic>? countDetails;
  AllDetails? ald;

  bool _showLoading = true;

  @override
  void initState() {
    super.initState();
    callApi();
  }

  void callApi() async {
    final prefs = await SharedPreferences.getInstance();

    Timer(const Duration(milliseconds: 5), () async {
      ald = await DashboardController.getUserDetailsBasedOnEmail(widget.email!);

      await prefs.setString('kycStatus', ald!.kycStatus.toString());

      await prefs.setString('username', ald!.name.toString());
      await prefs.setString('email', ald!.email.toString());
      await prefs.setString('photo', ald!.photo.toString());
      await prefs.setString('mobile', ald!.mobileNo.toString());
      await prefs.setString('userType', ald!.userType.toString());
      await prefs.setString('userId', ald!.id.toString());
      await prefs.setString('walletAddress', ald!.walletAddress.toString());

      print("phototssssssssssssssss");

      print(ald?.photo.toString());

      _fetchData(ald!.name, ald!.userType);
    });
  }

  Future _fetchData(String name, String userType) async {
    setState(() {
      _showLoading = true;
    });

    if (ald!.userType == UserType.ADMIN_USER) {
      final results = await Future.wait([
        http.get(Uri.parse(
            '${ApiUrl.API_URL_USERMANAGEMENT}user/getAdminCountDetails')),
      ]);

      setState(() {
        countDetails = json.decode(results[0].body);
      });
    } else {
      //for user
      final results = await Future.wait([
        http.get(Uri.parse(
            '${ApiUrl.API_URL_USERMANAGEMENT}user/getTxnDetails?userId=$name')),
        http.get(Uri.parse(
            '${ApiUrl.API_URL_USERMANAGEMENT}user/getCountDetails?userId=$name&status=V')),
      ]);

      setState(() {
        if (results[0].body.contains("No")) {
          transactionDetails = null;
        } else {
          transactionDetails = json.decode(results[0].body);
        }
        countDetails = json.decode(results[1].body);
      });
    }

    setState(() {
      _showLoading = false;
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
    String? photo = ald?.photo;
    String? userType = ald?.userType;
    String? mobile = ald?.mobileNo;
    String? email = ald?.email;
    String? username = ald?.name;
    String? walletAddress = ald?.walletAddress;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 5,
        flexibleSpace: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: CustomTheme.customLinearGradient,
          ),
        ),
        title: Text(
          ald == null ? "Welcome Dummy" : "Welcome ${ald!.name}",
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.displayLarge,
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _openDrawer,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
                backgroundColor: Colors.white,
                child: ald == null
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
                      )),
          ),
        ],
      ),
      drawer: DashboardDrawer(
          walletAddress: walletAddress,
          userType: userType ?? "",
          username: username ?? "",
          email: email ?? "",
          mobile: mobile ?? "",
          photo: photo ?? ""),
      body: _showLoading != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const YourNewLife(),

                  const SizedBox(height: 20),
                  // const MetaMaskLoginScreen(),
                  const SizedBox(
                    height: 20,
                  ),
                  userType == "ADMIN"
                      ? DropDown(
                          userType: userType,
                        )
                      : searchBar(),
                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(
                    height: 80,
                  ),
                 YourTableWidget(),


                  const SizedBox(
                    height: 80,
                  ),
                  SlidingCardWidgetState(),
                  const SizedBox(
                    height: 60,
                  ),
                  // const YourNewLife(),
                  const SizedBox(
                    height: 60,
                  ),
                  CarouselWithPictures(),
                  const SizedBox(
                    height: 60,
                  ),
                  const ScrollItem(),
                  const SizedBox(
                    height: 70,
                  ),
                  countDetails == null
                      ? const SizedBox(
                    width: 100,
                    height: 300,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                      : YesWidget(
                    totalTokenPrice: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedTxnCount"
                        : "totalTokenPrice"]
                        .toString(),
                    totalBuyCount: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedBuyCount"
                        : "totalBuyCount"]
                        .toString(),
                    totalPropCount: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedPropertyCount"
                        : "totalPropCount"]
                        .toString(),
                    totalSellCount: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedSellCount"
                        : "totalSellCount"]
                        .toString(),
                    totalTokeHoldigs: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedTokenProcessedCount"
                        : "totalTokeHoldigs"]
                        .toString(),
                    userType: ald!.userType,
                  ),
                  transactionDetails == null
                      ? SizedBox()
                      : RecentTransactions(
                    transactionDetails: transactionDetails!,
                  ),
                  countDetails == null
                      ? SizedBox()
                      : MyPieChart(
                    totalTokenPrice: userType == "ADMIN"
                        ? countDetails!
                        .first["totalAdminProcessedTxnCount"]
                        .toString()
                        : "",
                    totalBuyCount: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedBuyCount"
                        : "totalBuyCount"]
                        .toString(),
                    totalPropCount: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedPropertyCount"
                        : "totalPropCount"]
                        .toString(),
                    totalSellCount: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedSellCount"
                        : "totalSellCount"]
                        .toString(),
                    totalTokeHoldigs: countDetails!.first[
                    ald!.userType == "ADMIN"
                        ? "totalAdminProcessedTokenProcessedCount"
                        : "totalTokeHoldigs"]
                        .toString(),
                    userType: ald!.userType,
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: BottomAppBar(
        height: 75,
        elevation: 22,
        color: Colors.white38,

        ///shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox.fromSize(
              size: const Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      if (userType == "ADMIN") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ShowAllVerifyBuy(
                                    screenStatus: 'buy',
                                  )),
                        );
                      } else {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           const ScreenToDisplayAlltheCities(
                        //             screenStatus: 'buy',
                        //           )),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ShowAllVerifiedProperties(
                                      screenStatus: 'buy')),
                        );
                      }
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.bubble_chart),
                        SizedBox(
                          height: 3,
                        ),

                        /// icon
                        Text("Buy",style: TextStyle(fontSize: 10),), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      if (userType == "ADMIN") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ShowAllVerifySell(
                                    screenStatus: 'sell',
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BoughtProperties(
                                    screenStatus: "sell",
                                  )),
                        );
                      }
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.sell),
                        SizedBox(
                          height: 3,
                        ), // icon
                        Text("Sell",style: TextStyle(fontSize: 10),),

                        /// text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(80, 80), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.transparent, // button color
                  child: InkWell(
                    // splashColor: Colors.green, // splash color
                    onTap: () {
                      if (userType == "ADMIN") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowAllPendingProperties(
                                    screenStatus: 'sell',
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const RegisterPropertyOne()),
                        );
                      }
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Icon(Icons.house),
                        SizedBox(
                          height: 3,
                        ),

                        /// icon
                        Text("Property",style: TextStyle(fontSize: 10),), // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox.fromSize(
              size: const Size(80, 80), // button width and height
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
                                ? const DashboardScreen(email: "contact.adityamall@gmail.com",)
                                : const TokenScreen()),
                      );
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.devices_other),
                        SizedBox(
                          height: 3,
                        ),
                        // icon
                        Text(userType == "ADMIN" ? "Others" : "Dashboard",style: TextStyle(fontSize: 10),),
                        // text
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Add your action for the floating action button here
      //   },
      //   child: Icon(Icons.add),
      // ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ...other widgets
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 300,
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    showCursor: true,
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    },
                    onChanged: (value) {
                      // setState(() {
                      //   searchText = value;
                      // });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
            // ...rest of your code
          ],
        ),
      ],
    );
  }
}
