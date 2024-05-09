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

  // static List<Buyer> propertyList = [
  //   Buyer(
  //     id: "O3-Prop-174",
  //     propName: "self House",
  //     address: "Ayodhya",
  //     city: "Ayodhya",
  //     pinCode: "224001",
  //     state: "Uttar Pradesh",
  //     propValue: 20000000,
  //     ownerName: "Shubham Kumar",
  //     ownerId: "Shubham Kumar",
  //     tokenRequested: 50,
  //     tokenName: "Ayodhya ",
  //     tokenSymbol: "Ayodhya ",
  //     tokenCap: 60,
  //     tokenSupply: 45,
  //     tokenBalance: 10000000,
  //     propRegisteredDate: "2024-05-02T06:30:22.822+00:00",
  //     propOnO3CreatedDate: "null",
  //     delFlg: "N",
  //     status: "V",
  //     verifiedBy: "Aditya Mall",
  //     verifiedDate: "2024-05-07T09:06:28.040+00:00",
  //     docSaleDeed: "Shub sign.pdf",
  //     propDoc1: "null",
  //     propDoc2: "null",
  //     propDoc3: "null",
  //     propDoc4: "null",
  //     propImage1: "1d0e1b1e-8198-41c4-88cc-dfc941fbc7dd606027970351857428.jpg",
  //     propImage2: "1877b66e-f3bf-4634-842c-…7689154359836172054.jpg",
  //     propImage3: "9387f89e-cb16-44c5-bd1f-…1646709200837049519.jpg",
  //     propImage4: "null",
  //     propImage5: "null",
  //     propImage1Byte: "assets/images/property/O3-Prop-174/one.jpg",
  //     propImage2Byte: "assets/images/property/O3-Prop-174/two.jpg",
  //     propImage3Byte: "assets/images/property/O3-Prop-174/three.jpg",
  //     propImage4Byte: "null",
  //     propImage5Byte: "null",
  //     remakrs: "",
  //     tokenPrice: 400000,
  //   ),
  //   Buyer(
  //     id: "O3-Prop-175",
  //     propName: "Amit Villa ",
  //     address: "Sarita vihar",
  //     city: "Delhi",
  //     pinCode: "110076",
  //     state: "Delhi",
  //     propValue: 16000000,
  //     ownerName: "Amitanshu verma",
  //     ownerId: "Amitanshu123",
  //     tokenRequested: 2500000,
  //     tokenName: "Sarita123",
  //     tokenSymbol: "Green Delhi",
  //     tokenCap: 50,
  //     tokenSupply: 50,
  //     tokenBalance: 50,
  //     propRegisteredDate: "2024-05-02T07:45:28.474+00:00",
  //     propOnO3CreatedDate: "null",
  //     delFlg: "N",
  //     status: "V",
  //     verifiedBy: "Aditya Mall ",
  //     verifiedDate: "2024-05-07T09:12:20.138+00:00",
  //     docSaleDeed: "kiran pal.pdf",
  //     propDoc1: "null",
  //     propDoc2: "null",
  //     propDoc3: "null",
  //     propDoc4: "null",
  //     propImage1: "953f2af8-845f-4170-8310-347a0ccda7617751557467200957193.jpg",
  //     propImage2: "1550960d-69a4-421b-ab28-b72aac97ac3c1514091172248568880.jpg",
  //     propImage3: "021a29ee-095a-4817-a635-72e45054ed2a6131110714054806690.jpg",
  //     propImage4: "null",
  //     propImage5: "null",
  //     propImage1Byte: "assets/images/property/O3-Prop-175/one.jpg",
  //     propImage2Byte: "assets/images/property/O3-Prop-175/two.jpg",
  //     propImage3Byte: "assets/images/property/O3-Prop-175/three.jpg",
  //     propImage4Byte: "",
  //     propImage5Byte: "",
  //     remakrs: "",
  //     tokenPrice: 10000,
  //
  //   ),
  //   Buyer(
  //     id: "O3-Prop-176",
  //     propName: "vila ",
  //     address: "ayodhya ",
  //     state: "Uttar Pradesh ",
  //     propValue: 5000000,
  //     buyerName: "Shubham Kumar",
  //     buyerId: "Ayodhya ",
  //     tokenRequested: 50,
  //     tokenName: "AYC001",
  //     delFlg: "N",
  //     status: "V",
  //     verifiedBy: "Aditya Mall ",
  //     verifiedDate: "2024-05-07T09:12:50.099+00:00",
  //     propImage1Byte: "assets/images/property/O3-Prop-176/one.jpg",
  //     propImage2Byte: "assets/images/property/O3-Prop-176/two.jpg",
  //     propImage3Byte: "assets/images/property/O3-Prop-176/three.jpg",
  //     tokenPrice: "100000",
  //   ),
  //   Buyer(
  //     id: "O3-Prop-177",
  //     propName: "VILA",
  //     address: "Ayodhya ",
  //     city: "Ayodhya ",
  //     pinCode: "224001",
  //     state: "Uttar Pradesh ",
  //     propValue: 50000000,
  //     ownerName: "Shubham Kumar",
  //     ownerId: "Ayc",
  //     tokenRequested: 100,
  //     tokenName: "AYC001",
  //     tokenSymbol: "AYC001",
  //     tokenCap: 300,
  //     tokenSupply: 100,
  //     tokenBalance: 300,
  //     propRegisteredDate: "2024-05-02T11:54:07.919+00:00",
  //     propOnO3CreatedDate: "null",
  //     delFlg: "N",
  //     status: "V",
  //     verifiedBy: "Aditya Mall ",
  //     verifiedDate: "2024-05-07T09:14:43.803+00:00",
  //     docSaleDeed: "Shub sign.pdf",
  //     propDoc1: "null",
  //     propDoc2: "null",
  //     propDoc3: "null",
  //     propDoc4: "null",
  //     propImage1: "5498c2f5-431e-4be6-9e08-8938f48ae4908727320127347571235.jpg",
  //     propImage2: "f11b2ec2-2be5-4c43-97c6-41ad823c14d29123893505260140716.jpg",
  //     propImage3: "5ed6d0af-93d2-43dd-9a24-…7314348406615427765.jpg",
  //     propImage4: "null",
  //     propImage5: "null",
  //     propImage1Byte: "assets/images/property/O3-Prop-177/one.jpg",
  //     propImage2Byte: "assets/images/property/O3-Prop-177/two.jpg",
  //     propImage3Byte: "assets/images/property/O3-Prop-177/three.jpg",
  //     propImage4Byte: "null",
  //     propImage5Byte: "null",
  //     remakrs: "",
  //     tokenPrice: 500000,
  //   ),
  //   Properties(
  //     id: "O3-Prop-180",
  //     propName: "MNO",
  //     address: "Versova ",
  //     city: "Mumbai ",
  //     pinCode: "400061",
  //     state: "Maharashtra ",
  //     propValue: 500000000,
  //     ownerName: "Abhishek ",
  //     ownerId: "MNO01",
  //     tokenRequested: 100,
  //     tokenName: "MNO",
  //     tokenSymbol: "MNO",
  //     tokenCap: 200,
  //     tokenSupply: 100,
  //     tokenBalance: 100,
  //     propRegisteredDate: "2024-05-07T07:02:13.944+00:00",
  //     propOnO3CreatedDate: "null",
  //     delFlg: "N",
  //     status: "V",
  //     verifiedBy: "Aditya Mall ",
  //     verifiedDate: "2024-05-07T09:15:08.311+00:00",
  //     docSaleDeed: " Bhagwan Lal Kamat.pdf",
  //     propDoc1: "null",
  //     propDoc2: "null",
  //     propDoc3: "null",
  //     propDoc4: "null",
  //     propImage1: "b3b4e06e-9821-4a87-9069-8d336b98f64a5036301633108918819.jpg",
  //     propImage2: "bd46e675-eb5e-464c-a133-f3c9221afee12173199786076673938.jpg",
  //     propImage3: "da14e061-5f8d-46c1-970e-1bf67635b0792345743154001093730.jpg",
  //     propImage4: "null",
  //     propImage5: "null",
  //     propImage1Byte: "assets/images/property/O3-Prop-180/one.jpg",
  //     propImage2Byte: "assets/images/property/O3-Prop-180/two.jpg",
  //     propImage3Byte: "assets/images/property/O3-Prop-180/one.jpg",
  //     propImage4Byte: "null",
  //     propImage5Byte: "null",
  //     remakrs: "",
  //     tokenPrice: 5000000,
  //   ),
  // ];

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
                            //props: propertyList,
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
