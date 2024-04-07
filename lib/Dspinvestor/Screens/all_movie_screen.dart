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

class AllDSPInvestorScreen extends StatefulWidget {
  final String screenStatus;
  final String? categoryType;

  const AllDSPInvestorScreen(
      {super.key, required this.screenStatus, this.categoryType});

  @override
  State<StatefulWidget> createState() {
    return _AllDSPInvestorScreenState();
  }
}

class _AllDSPInvestorScreenState extends State<AllDSPInvestorScreen> {
  bool showFavorites = false;

  // late List<Properties> propList;

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
      id: "jayshahr@gamil.com",
      propName: "Kunal shah",
      address: "MUMBAI",
      city: "MUMBAI",
      pinCode: "001",
      state: "MH",
      propValue: 1000000,
      ownerName: "935751088",
      ownerId: "MVQ11",
      tokenRequested: 0,
      tokenName: "Idbi,Axis,Hdfc",
      tokenSymbol: "ANML",
      tokenCap: 100,
      tokenSupply: 100,
      tokenBalance: 100,
      propRegisteredDate: "01-12-2023",
      propExpiredDate: "12-12-2023",
      shootingStart: "01-12-2023",
      directorName: "Idbi,Axis,Hdfc",
      actorName: "Ranbir Kapoor",
      actressName: "parinito",
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
      propImage1Byte: "assets/images/Investors/ks.jpeg",
      propImage2Byte: "assets/images/Investors/kss.jpeg",
      propImage3Byte: "assets/images/Investors/ksss.jpeg",
      propImage4Byte: "",
      propImage5Byte: "",
      remakrs: "",
      tokenPrice: 10000,
      movieType: "Hindi",
    ),
    Properties(
      id: "SM@gmai.com",
      propName: "Sanjay Mehata",
      address: "MUMBAI",
      city: "MUMBAI",
      pinCode: "001",
      state: "MH",
      propValue: 2000000,
      ownerName: "8237827383",
      ownerId: "MVQ112",
      tokenRequested: 0,
      tokenName: "Idbi,Axis,Hdfc",
      tokenSymbol: "AND",
      tokenCap: 1000,
      tokenSupply: 1000,
      tokenBalance: 1000,
      propRegisteredDate: "04-11-2023",
      propExpiredDate: "04-11-2023",
      shootingStart: "04-11-2023",
      directorName: "Idbi,,SBI,Axis,Hdfc,",
      actorName: "Shahsi Kapoor",
      actressName: "kiran bala",
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
      propImage1Byte: "assets/images/Investors/sm.jpeg",
      propImage2Byte: "assets/images/Investors/smm.jpeg",
      propImage3Byte: "assets/images/Investors/smmm.jpeg",
      propImage4Byte: "",
      propImage5Byte: "",
      remakrs: "",
      tokenPrice: 10000,
      movieType: "Hindi",
    ),
    Properties(
      id: "AM@gmail.com",
      propName: "Anupam Mittal",
      address: "Banglore",
      city: "Banglore",
      pinCode: "001",
      state: "KA",
      propValue: 3000000,
      ownerName: "273872387",
      ownerId: "MVQ311",
      tokenRequested: 0,
      tokenName: "Idbi,Axis,Hdfc",
      tokenSymbol: "sa",
      tokenCap: 10000,
      tokenSupply: 10000,
      tokenBalance: 10000,
      propRegisteredDate: "24-08-2023",
      propExpiredDate: "01-12-20212",
      shootingStart: "01-12-2023",
      directorName: "Idbi,Axis,Hdfc,PNB,",
      actorName: "Prabhas",
      actressName: "Sai Pallavi",
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
      propImage1Byte: "assets/images/Investors/am.jpeg",
      propImage2Byte: "assets/images/Investors/amm.jpeg",
      propImage3Byte: "assets/images/Investors/amm.jpeg",
      propImage4Byte: "",
      propImage5Byte: "",
      remakrs: "",
      tokenPrice: 100,
      movieType: "Kanada",
    ),
    Properties(
      id: "RajanAnandan@gmail.com",
      propName: "Rajan Anandan",
      address: "MUMBAI",
      city: "MUMBAI",
      pinCode: "001",
      state: "MH",
      propValue: 10000000,
      ownerName: "324234234",
      ownerId: "MVQ121",
      tokenRequested: 0,
      tokenName: "Idbi,Axis,Hdfc",
      tokenSymbol: "MRZPR",
      tokenCap: 2000,
      tokenSupply: 2000,
      tokenBalance: 2000,
      propRegisteredDate: "21-12-2023",
      propExpiredDate: "01-12-2023",
      shootingStart: "01-12-2023",
      directorName: "Idbi,Axis,Hdfc,Canara BAnk",
      actorName: "Pankaj tripathi",
      actressName: "Rashika duggal",
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
      propImage1Byte: "assets/images/Investors/rj.jpeg",
      propImage2Byte: "assets/images/Investors/rjj.jpeg",
      propImage3Byte: "assets/images/Investors/rjjj.jpeg",
      propImage4Byte: "",
      propImage5Byte: "",
      remakrs: "",
      tokenPrice: 10,
      movieType: "japanese",
    ),
    Properties(
      id: "Sachin Bansal@gamil.com",
      propName: "Sachin Bansal",
      address: "MUMBAI",
      city: "MUMBAI",
      pinCode: "001",
      state: "MH",
      propValue: 9000,
      ownerName: "45242352",
      ownerId: "MVQ211",
      tokenRequested: 0,
      tokenName: "Idbi,Axis,Hdfc",
      tokenSymbol: "PTHN",
      tokenCap: 500,
      tokenSupply: 500,
      tokenBalance: 500,
      propRegisteredDate: "12-12-2023",
      propExpiredDate: "01-12-2023",
      shootingStart: "01-12-2023",
      directorName: "Siddharth Anand",
      actorName: "srk",
      actressName: "Deepika Padukon",
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
      propImage1Byte: "assets/images/Investors/sb.jpeg",
      propImage2Byte: "assets/images/Investors/sbb.jpeg",
      propImage3Byte: "assets/images/Investors/sbbb.jpeg",
      propImage4Byte: "",
      propImage5Byte: "",
      remakrs: "",
      tokenPrice: 100000,
      movieType: "korean",
    ),
    Properties(
      id: "KunalBahl@gmail.com",
      propName: "Kunal Bahl",
      address: "California",
      city: "Caliofornia",
      pinCode: "001",
      state: "CL",
      propValue: 1000000000,
      ownerName: "5636436",
      ownerId: "MVQ112",
      tokenRequested: 0,
      tokenName: "Idbi,Axis,Hdfc",
      tokenSymbol: "jr",
      tokenCap: 1000,
      tokenSupply: 1000,
      tokenBalance: 1000,
      propRegisteredDate: "01-12-2023",
      propExpiredDate: "01-12-2023",
      shootingStart: "01-12-2023",
      directorName: "Mark Anothony",
      actorName: "Silvertor",
      actressName: "Megan",
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
      propImage1Byte: "assets/images/Investors/kb.jpeg",
      propImage2Byte: "assets/images/Investors/kbb.jpeg",
      propImage3Byte: "assets/images/Investors/kbbb.jpeg",
      propImage4Byte: "",
      propImage5Byte: "",
      remakrs: "",
      tokenPrice: 10000,
      movieType: "English",
    ),
    Properties(
      id: "RamakantSharma@gmail.com",
      propName: "Ramakant Sharma",
      address: "California",
      city: "California",
      pinCode: "001",
      state: "CL",
      propValue: 1000000,
      ownerName: "253234234",
      ownerId: "MVQ1154",
      tokenRequested: 0,
      tokenName: "Idbi,Axis,Hdfc",
      tokenSymbol: "SHLY",
      tokenCap: 900,
      tokenSupply: 900,
      tokenBalance: 900,
      propRegisteredDate: "01-01-2023",
      propExpiredDate: "01-12-2023",
      shootingStart: "01-12-2023",
      directorName: "Mark Robert",
      actorName: "robert jr",
      actressName: "megan Fox",
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
      propImage1Byte: "assets/images/Investors/rks.jpeg",
      propImage2Byte: "assets/images/Investors/rkss.jpeg",
      propImage3Byte: "assets/images/Investors/rksss.jpeg",
      propImage4Byte: "",
      propImage5Byte: "",
      remakrs: "",
      tokenPrice: 900,
      movieType: "English",
    ),
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
            gradient: CustomTheme.customLinearGradientForMovies,
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
                  Colors.blue,
                  Colors.blueAccent,
                  Colors.white60,
                  Colors.lightBlueAccent,
                  Colors.lightBlue,
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
                          "Our DCP Investors",
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
                          "Our Investors",
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
                    props: propertyList, // Use the filtered propertyList here
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
                filterPropertiesByActor(originalPropertyList, "English");
          });
        } else if (index == 2) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "Hindi");
          });
        } else if (index == 3) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "Kanada");
          });
        } else if (index == 4) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "Korean");
          });
        } else if (index == 5) {
          setState(() {
            propertyList =
                filterPropertiesByActor(originalPropertyList, "kiran Bala");
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
      List<Properties> originalList, String movieType) {
    return originalList
        .where((property) => property.movieType == movieType)
        .toList();
  }

  Widget _topCategoriesHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Our Invertors List",
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
                                  'New Movies avail..',
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
                                  'New Movies avail.. ',
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
