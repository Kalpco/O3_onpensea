import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Property/show-alldetails/Screens/BoughtProperties.dart';
import '../Models/AppData.dart';
import '../../Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import '../Screens/PropertyDetailsScreen.dart';
import '../Widgets/list_item_selector.dart';
import '../Widgets/PropertyGridView.dart';
import '../../Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import '../../Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import '../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../Token/Screen/token_screen.dart';
import '../../UserManagement/Feature-Dashboard/Screens/WidgetToDisplayAlltheCities.dart';
import '../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../config/CustomTheme.dart';
import '../Controller/PropertyController.dart';
import '../Models/Product.dart';
import '../Models/product_category.dart';
import '../Models/Properties.dart';

enum AppbarActionType { leading, trailing }

class AllNftScreen extends StatefulWidget {
  final String screenStatus;
  final String? categoryType;

  const AllNftScreen(
      {super.key, required this.screenStatus, this.categoryType});

  @override
  State<StatefulWidget> createState() {
    return _AllNftScreenState();
  }
}

class _AllNftScreenState extends State<AllNftScreen> {
  //late List<Properties> propList;
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? walletAddress;

  Future<List<Properties>>? prop;
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

  static List<Properties> propertyList = [
    Properties(
        id: "MV88",
        nftType: "bat",
        propName: "Azuki",
        address: "MUMBAI",
        city: "MUMBAI",
        pinCode: "001",
        state: "MH",
        propValue: 1000000,
        ownerName: "Azuki productions",
        ownerId: "MVQ11",
        tokenRequested: 0,
        tokenName: "AZKI",
        tokenSymbol: "AZKI",
        tokenCap: 100,
        tokenSupply: 100,
        tokenBalance: 100,
        propRegisteredDate: "01-12-2023",
        propOnO3CreatedDate: "",
        delFlg: "",
        status: "",
        verifiedBy: "",
        verifiedDate: "",
        docSaleDeed: "",
        propDoc1: "",
        propDoc2: "",
        propDoc3: "",
        propDoc4: "",
        propImage1: "",
        propImage2: "",
        propImage3: "",
        propImage4: "",
        propImage5: "",
        propImage1Byte: "assets/images/nfts/azuki.jpg",
        propImage2Byte: "assets/images/nfts/azukiTwo.webp",
        propImage3Byte: "assets/images/nfts/azukiThree.jpg",
        propImage4Byte: "",
        propImage5Byte: "",
        remakrs: "",
        tokenPrice: 10000),
    Properties(
        nftType: "gods",
        id: "MV0221",
        propName: "Degods",
        address: "MUMBAI",
        city: "MUMBAI",
        pinCode: "001",
        state: "MH",
        propValue: 1000000,
        ownerName: "Degods",
        ownerId: "MVQ113",
        tokenRequested: 0,
        tokenName: "DGDS",
        tokenSymbol: "DGDS",
        tokenCap: 400,
        tokenSupply: 400,
        tokenBalance: 400,
        propRegisteredDate: "01-12-2023",
        propOnO3CreatedDate: "",
        delFlg: "",
        status: "",
        verifiedBy: "",
        verifiedDate: "",
        docSaleDeed: "",
        propDoc1: "",
        propDoc2: "",
        propDoc3: "",
        propDoc4: "",
        propImage1: "",
        propImage2: "",
        propImage3: "",
        propImage4: "",
        propImage5: "",
        propImage1Byte: "assets/images/nfts/degods.jpg",
        propImage2Byte: "assets/images/nfts/degodsTwo.jpg",
        propImage3Byte: "assets/images/nfts/degodsThree.jpg",
        propImage4Byte: "",
        propImage5Byte: "",
        remakrs: "",
        tokenPrice: 30000),
    Properties(
        nftType: "monkey",
        id: "MV0551",
        propName: "Monkey",
        address: "MUMBAI",
        city: "MUMBAI",
        pinCode: "001",
        state: "MH",
        propValue: 1000000,
        ownerName: "Monkeys Club",
        ownerId: "MVQ311",
        tokenRequested: 0,
        tokenName: "MKC",
        tokenSymbol: "MKC",
        tokenCap: 100,
        tokenSupply: 100,
        tokenBalance: 100,
        propRegisteredDate: "01-12-2023",
        propOnO3CreatedDate: "",
        delFlg: "",
        status: "",
        verifiedBy: "",
        verifiedDate: "",
        docSaleDeed: "",
        propDoc1: "",
        propDoc2: "",
        propDoc3: "",
        propDoc4: "",
        propImage1: "",
        propImage2: "",
        propImage3: "",
        propImage4: "",
        propImage5: "",
        propImage1Byte: "assets/images/nfts/monkey.webp",
        propImage2Byte: "assets/images/nfts/monkeyTwo.webp",
        propImage3Byte: "assets/images/nfts/monkeyThree.jpg",
        propImage4Byte: "",
        propImage5Byte: "",
        remakrs: "",
        tokenPrice: 40000),
    Properties(
        nftType: "penguen",
        id: "MV0031",
        propName: "Pudgi Penguen",
        address: "MUMBAI",
        city: "MUMBAI",
        pinCode: "001",
        state: "MH",
        propValue: 1000000,
        ownerName: "Pudgi Penguen",
        ownerId: "MVQ311",
        tokenRequested: 0,
        tokenName: "PP",
        tokenSymbol: "PP",
        tokenCap: 300,
        tokenSupply: 300,
        tokenBalance: 300,
        propRegisteredDate: "01-12-2023",
        propOnO3CreatedDate: "",
        delFlg: "",
        status: "",
        verifiedBy: "",
        verifiedDate: "",
        docSaleDeed: "",
        propDoc1: "",
        propDoc2: "",
        propDoc3: "",
        propDoc4: "",
        propImage1: "",
        propImage2: "",
        propImage3: "",
        propImage4: "",
        propImage5: "",
        propImage1Byte: "assets/images/nfts/pudgipenguen.jpg",
        propImage2Byte: "assets/images/nfts/pudgipenguenTwo.png",
        propImage3Byte: "assets/images/nfts/pudgipenguenthree.png",
        propImage4Byte: "",
        propImage5Byte: "",
        remakrs: "",
        tokenPrice: 40000),
    Properties(
        nftType: "mouse",
        id: "MV044",
        propName: "Steam Boat Willie",
        address: "MUMBAI",
        city: "MUMBAI",
        pinCode: "001",
        state: "MH",
        propValue: 1000000,
        ownerName: "Steam Boat Willie",
        ownerId: "MVQ131",
        tokenRequested: 0,
        tokenName: "SBW",
        tokenSymbol: "SBW",
        tokenCap: 400,
        tokenSupply: 400,
        tokenBalance: 400,
        propRegisteredDate: "01-12-2023",
        propOnO3CreatedDate: "",
        delFlg: "",
        status: "",
        verifiedBy: "",
        verifiedDate: "",
        docSaleDeed: "",
        propDoc1: "",
        propDoc2: "",
        propDoc3: "",
        propDoc4: "",
        propImage1: "",
        propImage2: "",
        propImage3: "",
        propImage4: "",
        propImage5: "",
        propImage1Byte: "assets/images/nfts/steamboatWille.jpg",
        propImage2Byte: "assets/images/nfts/steamboatWille.webp",
        propImage3Byte: "assets/images/nfts/steamboatWilletwo.png",
        propImage4Byte: "",
        propImage5Byte: "",
        remakrs: "",
        tokenPrice: 10000),
    // Properties(
    //     id: "MV001",
    //     propName: "Animal",
    //     address: "MUMBAI",
    //     city: "MUMBAI",
    //     pinCode: "001",
    //     state: "MH",
    //     propValue: 1000000,
    //     ownerName: "T-SERIES",
    //     ownerId: "MVQ11",
    //     tokenRequested: 0,
    //     tokenName: "ANML",
    //     tokenSymbol: "ANML",
    //     tokenCap: 100,
    //     tokenSupply: 100,
    //     tokenBalance: 100,
    //     propRegisteredDate: "01-12-2023",
    //     propOnO3CreatedDate: "",
    //     delFlg: "",
    //     status: "",
    //     verifiedBy: "",
    //     verifiedDate: "",
    //     docSaleDeed: "",
    //     propDoc1: "",
    //     propDoc2: "",
    //     propDoc3: "",
    //     propDoc4: "",
    //     propImage1: "",
    //     propImage2: "",
    //     propImage3: "",
    //     propImage4: "",
    //     propImage5: "",
    //     propImage1Byte: "assets/images/movies/animal.jpg",
    //     propImage2Byte: "assets/images/movies/animalTwo.jpg",
    //     propImage3Byte: "assets/images/movies/animalThree.jpg",
    //     propImage4Byte: "",
    //     propImage5Byte: "",
    //     remakrs: "",
    //     tokenPrice: 10000),
    Properties(
        nftType: "bat",
        id: "MV02801",
        propName: "Bat",
        address: "MUMBAI",
        city: "MUMBAI",
        pinCode: "001",
        state: "MH",
        propValue: 1000000,
        ownerName: "Batman",
        ownerId: "MVQ131",
        tokenRequested: 0,
        tokenName: "BT",
        tokenSymbol: "BT",
        tokenCap: 100,
        tokenSupply: 100,
        tokenBalance: 100,
        propRegisteredDate: "01-12-2023",
        propOnO3CreatedDate: "",
        delFlg: "",
        status: "",
        verifiedBy: "",
        verifiedDate: "",
        docSaleDeed: "",
        propDoc1: "",
        propDoc2: "",
        propDoc3: "",
        propDoc4: "",
        propImage1: "",
        propImage2: "",
        propImage3: "",
        propImage4: "",
        propImage5: "",
        propImage1Byte: "assets/images/nfts/bat.webp",
        propImage2Byte: "assets/images/nfts/batTwo.png",
        propImage3Byte: "assets/images/nfts/batThree.png",
        propImage4Byte: "",
        propImage5Byte: "",
        remakrs: "",
        tokenPrice: 10000),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    //prop = PropertyController.fetchProperties();
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
            gradient: CustomTheme.customLinearGradientForNft,
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
          categoryType: widget.categoryType,
          userType: userType,
          username: username,
          email: email,
          mobile: mobile,
          photo: photo),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.black87,
                  Colors.black54,
                  Colors.black38,
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
                            textStyle:
                                Theme.of(context).textTheme.headlineLarge,
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        )
                      : Text(
                          "Lets sell some tokens",
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
                  const SizedBox(height: 30),
                  _topCategoriesHeader(context),
                  const SizedBox(height: 15),
                  _topCategoriesListView(context),
                  const SizedBox(height: 50),
                  PropertyGridView(
                    props: propertyList,
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
      ),
    );
  }

  List<Properties> originalPropertyList = List.from(propertyList);

  Widget _topCategoriesListView(BuildContext context) {
    return ListItemSelector(
      categories: categories,
      onItemPressed: (index) {
        if (index == 0) {
          setState(() {
            propertyList = List.from(originalPropertyList);

            /// Reset karen k leye
          });
        } else if (index == 1) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "bat");
          });
        } else if (index == 2) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "mouse");
          });
        } else if (index == 3) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "penguen");
          });
        } else if (index == 4) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "gods");
          });
        } else if (index == 5) {
          setState(() {
            propertyList = filterPropertiesByActor(originalPropertyList, "monkey");
          });
        } else {
          // Handle other icon clicks or resetting the list if needed
        }
        controller.filterItemsByCategory(index);
      },
    );
  }

  // Function to filter properties by actorName
  List<Properties> filterPropertiesByActor(
      List<Properties> originalList, String nftType) {
    return originalList
        .where((property) => property.nftType == nftType)
        .toList();
  }

  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Nfts categories",
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
                                  'New Nfts avail..',
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
                                  'New Nfts avail.. ',
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
