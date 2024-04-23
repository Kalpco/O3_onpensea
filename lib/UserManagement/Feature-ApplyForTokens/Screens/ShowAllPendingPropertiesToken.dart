import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import 'package:onpensea/Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../../Property/Feature-ShowAllDetails/Screens/PropertyDetailsScreen.dart';
import '../../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../../Property/show-alldetails/Screens/BoughtProperties.dart';
import '../../../config/CustomTheme.dart';
import '../../Feature-Dashboard/Screens/common_dashboard_screen.dart';
import '../../Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../Controller/PropertyController.dart';
import '../Controller/TokenController.dart';
import '../Models/Product.dart';
import '../Models/Properties.dart';
import '../Models/product_category.dart';
import '../Utils/AppData.dart';
import '../Widgets/PropertyGridView.dart';
import '../Widgets/list_item_selector.dart';

enum AppbarActionType { leading, trailing }

class ShowAllPendingPropertiesToken extends StatefulWidget {
  final String screenStatus;

  const ShowAllPendingPropertiesToken({super.key, required this.screenStatus});

  @override
  State<StatefulWidget> createState() {
    return _ShowAllPendingPropertiesTokenViewState();
  }
}

class _ShowAllPendingPropertiesTokenViewState
    extends State<ShowAllPendingPropertiesToken> {
  late List<Properties> propList;

  Future<List<Properties>>? prop;
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? walletAddress;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  static List<ProductCategory> categories = [
    ProductCategory(
      ProductType.all,
      true,
      Icons.home,
    ),
    ProductCategory(
      ProductType.mobile,
      false,
      FontAwesomeIcons.building,
    ),
    ProductCategory(ProductType.watch, false, Icons.local_mall),
    ProductCategory(
      ProductType.tablet,
      false,
      FontAwesomeIcons.hospital,
    ),
    ProductCategory(
      ProductType.headphone,
      false,
      Icons.token,
    ),
    ProductCategory(
      ProductType.tv,
      false,
      Icons.apartment,
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prop = TokenController.fetchPropertiesToken();
    getUsername();
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
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
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
                      )),
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
      body: FutureBuilder<List<Properties>>(
        future: prop,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final propList = snapshot.data!;
            return SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CustomTheme.primaryColor,
                        CustomTheme.secondaryColor,
                        CustomTheme.ternaryColor,
                        CustomTheme.fonaryColor,
                        CustomTheme.fifthColor,
                        Colors.white,
                        Colors.white70,
                        Colors.white60,
                        Colors.white54,
                        Colors.white54,
                        Colors.white38,
                        Colors.white30,
                        Colors.white24,
                        Colors.white30,
                        Colors.white24,
                        Colors.white30,
                        Colors.white38,
                        Colors.white70
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Hello ${username!.split(" ")[0]}',
                        //   style: Theme.of(context).textTheme.displayMedium,
                        // ),
                        widget.screenStatus == 'buy'
                            ? Text(
                                "Token Initiation Request...",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.headlineLarge,
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              )
                            : Text(
                                "Token Initiation Request..?",
                                style: GoogleFonts.poppins(
                                  textStyle:
                                      Theme.of(context).textTheme.headlineLarge,
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                        const SizedBox(height: 20),
                        _recommendedProductListView(context),
                        // const SizedBox(height: 30),
                        // _topCategoriesHeader(context),
                        // const SizedBox(height: 15),
                        // _topCategoriesListView(context),
                        const SizedBox(height: 50),
                        PropertyGridView(
                          props: propList,
                          // likeButtonPressed: (index) => controller.isFavorite(index),
                          //isPriceOff: (product) => true,
                          screenStatus: widget.screenStatus,
                          likeButtonPressed: (int index) {},
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error} '));
          } else {
            print('at circular ${prop}');
            return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orangeAccent,
                      Colors.purpleAccent,
                      Colors.white24,
                      Colors.white30,
                      Colors.white38,
                      Colors.white70
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: const Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }

  Widget appBarActionButton(AppbarActionType type, String email) {

    IconData icon = Icons.chevron_left;
    String emailP = email;
    if (type == AppbarActionType.trailing) {
      icon = Icons.search;
    }
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        onPressed: () {
          String email = emailP;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen(email: "singhhpulkit@gmail.com",)),
          );
        },
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }

  PreferredSize get _appBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.orangeAccent,
                Colors.orangeAccent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                appBarActionButton(AppbarActionType.leading, email!),
                // appBarActionButton(AppbarActionType.trailing),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topCategoriesListView(BuildContext context) {
    return ListItemSelector(
      categories: categories,
      onItemPressed: (index) {
        controller.filterItemsByCategory(index);
        /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropertyDetailsScreen()),
        );
*/
      },
    );
  }

  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Top categories",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
            child: Text(
              "SEE ALL",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.deepOrange.withOpacity(0.7)),
            ),
          )
        ],
      ),
    );
  }

  Widget _recommendedProductListView(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: AppData.recommendedProducts.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppData.recommendedProducts[index].cardBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.screenStatus == 'sell'
                              ? Text(
                                  'New Property avail..',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                )
                              : Text(
                                  'New Property avail.. ',
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppData
                                    .recommendedProducts[index]
                                    .buttonBackgroundColor,
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: widget.screenStatus == 'buy'
                                  ? Text(
                                      "Buy tokens",
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                        fontSize: 12,
                                        color: AppData
                                            .recommendedProducts[index]
                                            .buttonTextColor!,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    )
                                  : Text(
                                      "Sell Tokens",
                                      style: GoogleFonts.poppins(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .labelLarge,
                                        fontSize: 12,
                                        color: AppData
                                            .recommendedProducts[index]
                                            .buttonTextColor!,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ))
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Spacer(),
                    const Spacer(),
                    Image.asset(
                      'assets/images/Bitcoin.svg.png',
                      height: 125,
                      fit: BoxFit.cover,
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
