import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Property/show-alldetails/Models/AppData.dart';
import '../../../Property/show-alldetails/Models/Product.dart';
import '../../../Property/show-alldetails/Models/Properties.dart';
import '../../../Property/show-alldetails/Models/product_category.dart';
import '../../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../../../Property/show-alldetails/Widgets/PropertyGridView.dart';
import '../../../Property/show-alldetails/Widgets/list_item_selector.dart';
import '../../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import '../../../Token/Screen/token_screen.dart';
import '../../../UserManagement/Feature-Dashboard/Screens/WidgetToDisplayAlltheCities.dart';
import '../../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../../config/CustomTheme.dart';
import '../../Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../Controller/buyer_controller.dart';
import '../Models/buyermodel.dart';

enum AppbarActionType { leading, trailing }

class BoughtProperties extends StatefulWidget {
  final String screenStatus;

  const BoughtProperties({
    super.key,
    required this.screenStatus,
  });

  @override
  State<StatefulWidget> createState() {
    return _BoughtPropertiesState();
  }
}

class _BoughtPropertiesState extends State<BoughtProperties> {
  List<Buyer>? propList;
  List<Buyer>? modifiedPropList = [];
  List<Buyer>? originalPropList = [];
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? kycStatus;
  String? walletAddress;

  Future<List<Buyer>>? prop;
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

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      print("++++++++++++++++++++++");
      print(username);
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
      userType = prefs.getString("userType");
      kycStatus = prefs.getString('kycStatus');
      walletAddress = prefs.getString("walletAddress");
    });
  }

  @override
  void initState() {
    super.initState();
    getUsername().then((_) {
      prop = BuyerController.getAllboughtProperties(username!);
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
          height: 75,
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
                                  : const ShowAllVerifiedProperties(
                                      screenStatus: 'buy')),
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
                          Text("Buy",style: TextStyle(fontSize: 10),), // text
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
                          Text("Sell",style: TextStyle(fontSize: 10),),

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
                          Text("Property",style: TextStyle(fontSize: 10),), // text
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
                          Text("Dashboard",style: TextStyle(fontSize: 10),), // text
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
        drawer: DashboardDrawer(
            walletAddress: walletAddress,
            userType: userType,
            username: username,
            email: email,
            mobile: mobile,
            photo: photo),
        body: FutureBuilder<List<Buyer>>(
          future: prop,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              originalPropList = snapshot.data;
              propList = (modifiedPropList?.length == 0
                  ? originalPropList
                  : modifiedPropList)!;
              // final propList = snapshot.data!;
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
                                  "Lets buy some tokens?",
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                )
                              : Text(
                                  "Lets sell some tokens",
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineLarge,
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),

                          const SizedBox(height: 20),
                          _recommendedProductListView(context),
                          const SizedBox(height: 30),
                          _topCategoriesHeader(context),
                          const SizedBox(height: 15),
                          _topCategoriesListView(context),
                          const SizedBox(height: 50),
                          PropertyGridView(
                            props: propList!,
                            screenStatus: widget.screenStatus,
                            likeButtonPressed: (int index) {},
                            username: username!,
                          ),
                          // GetBuilder(builder: (BuyerController controller) {
                          //   print('Filtered list: $propList');
                          //   return PropertyGridView(
                          //     props: originalPropList!,
                          //     screenStatus: widget.screenStatus,
                          //     likeButtonPressed: (int index) {},
                          //     username: username!,
                          //   );
                          // }),
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
        ));
  }

  Widget _topCategoriesListView(BuildContext context) {
    return ListItemSelector(
      categories: categories,
      onItemPressed: (index) {
        if (index == 0) {
          // Show all properties
          print("Index 1");
          setState(() {
            modifiedPropList = originalPropList;
            // propList = List.from(originalPropList);
          });
        } else if (index == 1) {
          print("Index 1");
          setState(() {
            modifiedPropList =
                List.from(filterPropertiesByType(originalPropList!, "MALL"));
            print("thsi is it");
          });
        } else if (index == 2) {
          setState(() {
            modifiedPropList =
                List.from(filterPropertiesByType(originalPropList!, "HOUSE"));
            print("itiswhatitis");
            print(propList![0].propertyType);
          });
        } else {
          setState(() {
            // Pass a default propertyType or adjust the function accordingly
            // propList = List.from(filterPropertiesByType(originalPropList, "defaultType"));
          });
        }
      },
    );
  }

// Function to filter properties by propertyType
  List<Buyer> filterPropertiesByType(
      List<Buyer> originalList, String propertyType) {
    return originalList
        .where((property) => property.propertyType == propertyType)
        .toList();
  }

  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Top categories",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.labelLarge,
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
            child: Text(
              "SEE ALL",
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.labelLarge,
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
              ),
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
                  boxShadow: [
                    const BoxShadow(
                            color: Colors.white,
                            spreadRadius: 1,
                            blurRadius: 1,
                            blurStyle: BlurStyle.solid,
                            offset: Offset(4, 5))
                        .scale(1.1)
                  ],
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
                                      "Buy Now",
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
                                      "Sell Now",
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
