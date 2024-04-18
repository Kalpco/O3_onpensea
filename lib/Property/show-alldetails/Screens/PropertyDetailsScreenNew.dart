// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_maps/maps.dart';
// import '../../../Checkout/Screens/CheckoutScreen.dart';
// import '../../../config/CustomTheme.dart';
// import '../Models/Properties.dart';
// import '../Widgets/carousel_slider.dart';
// import '../Widgets/page_wrapper.dart';
// import "../Controller/PropertyController.dart";
// import 'ShowAllVerifiedProperties.dart';

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Property/show-alldetails/Models/buyermodel.dart';
import 'package:onpensea/Property/show-alldetails/Screens/PaymentMetamask.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../Property/show-alldetails/Controller/PropertyController.dart';
import '../../../Property/show-alldetails/Models/Properties.dart';
import '../../../Property/show-alldetails/Widgets/carousel_slider.dart';
import '../../../Property/show-alldetails/Widgets/page_wrapper.dart';
import '../../../Checkout/Screens/CheckoutScreen.dart';
import '../../../RazorPay/RazerPay.dart';
import '../../../config/CustomTheme.dart';
import '../../Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';

class PropertyDetailsScreenNew extends StatefulWidget {
  final Buyer prop;
  final String screenStatus;

  const PropertyDetailsScreenNew(
      {super.key,
      required this.prop,
      required this.screenStatus,
      });

  @override
  State<PropertyDetailsScreenNew> createState() =>
      _PropertyDetailsScreenNewState();
}

class _PropertyDetailsScreenNewState extends State<PropertyDetailsScreenNew> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static TextEditingController nameController = TextEditingController();
  static TextEditingController remarksController = TextEditingController();
  bool isChecked = false;
  String? username;
  String? userId;
  String? kycStatus;
  int? tokenBalance;

  double? tokenPrice;

  bool showAllAmenities = false;
  int visibleContacts = 3; // Number of contacts initially visible
  bool showAllContacts = false;
  bool isAnswerShown = false;
  bool isAnswer2Shown = false;
  List<Contact> contacts = [
    Contact("Rosavault Industry", "Developer", "1-3cr", 'assets/images/3.png'),
    Contact("Gaur City", "Developer", "10-30cr", 'assets/images/7.png'),
    Contact("Loadha", "Developer", "5-10cr", 'assets/images/2.png'),
    Contact("Lambda", "Developer", "1-3cr", 'assets/images/5.png'),
    // Add more contacts here
  ];

  @override
  void initState() {
    super.initState();
    nameController.text = "";
    remarksController.text = "";
    callApi();
  }

  void callApi() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      username = prefs.getString('username');
      userId = prefs.getString('userId');
      kycStatus = prefs.getString('kycStatus');
      print("99999999999999999999999999999999");
      print(username);
      print(userId);
    });
  }

  @override
  void dispose() {
    _formKey.currentState!.dispose();
    nameController.dispose();
    remarksController.dispose;
    super.dispose();
  }

  Future<void> getUpdatedTokenCount(String tokenName) async {
    final dio = Dio();
    try {
      var response = await dio.get(
          "http://45.118.162.234:11007/token/tokenDetails?tokenName=$tokenName");

      if (response.statusCode! >= 200 || response.statusCode! <= 300) {
        setState(() {
          tokenPrice = response.data["tokenPrice"];
          tokenBalance = response.data["tokenBalance"];
          print(tokenPrice);
        });
      }
    } catch (e) {
      print("error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<String> listImages = [];
    listImages.add(widget.prop.propImage1Byte);
    listImages.add(widget.prop.propImage2Byte);
    listImages.add(widget.prop.propImage3Byte);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productPageView(width, height, widget.prop),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.prop.propName,
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineLarge,
                          fontSize: 34,
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _ratingBar(context),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            true != null
                                ? "\u{20B9}${widget.prop.tokenPrice}"
                                : "\u{20B9}${widget.prop.tokenPrice}",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 24,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(width: 1),
                          const Spacer(),
                          Text(
                            widget.prop.tokenPrice != 0
                                ? "Available in stock"
                                : "Not available",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 14,
                              color: Colors.lightGreen,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () async {
                                EasyLoading.showToast("Refreshing..");
                                getUpdatedTokenCount(widget.prop.tokenName);
                              },
                              icon: const Icon(
                                Icons.refresh,
                                size: 35,
                                color: Colors.grey,
                              ))
                        ],
                      ),
                      Text(
                        'Token Price: ${tokenPrice ?? widget.prop.tokenPrice}',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Token Balance : ${tokenBalance ?? widget.prop.tokenPrice}",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Token Name : ${widget.prop.tokenName} ",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Token Symbol : ${widget.prop.propName} ",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),

                      /* const SizedBox(height: 10),

                          Text(product.about),
                         */
                      const SizedBox(height: 20),
                      Text(
                        'Owner Name : ${widget.prop.buyerName}',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Property Id : ${widget.prop.propId}',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Property Registred Date: ${widget.prop.buyerRequestDate.split("T")[0]}',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Address: ${widget.prop.address}',
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      //shuru
                      const SizedBox(height: 40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              gradient: CustomTheme.customLinearGradient,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Why: ${widget.prop.propName}',
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.date_range,
                                          color: CustomTheme.ternaryColor),
                                      // Your icon here
                                      SizedBox(width: 20),
                                      // Adjust spacing between icon and text
                                      Text(
                                        'Launch and Posseion Date',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                      ),
                                      Text(
                                        "Started------------UnderConstruction",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                      ),
                                      Text(
                                        "Nov2022          ready to move by2022nov",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.apartment,
                                          color: CustomTheme.ternaryColor),
                                      // Your icon here
                                      SizedBox(width: 20),
                                      // Adjust spacing between icon and text
                                      Text(
                                        'Sizes unit and configuration',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                      ),
                                      Text(
                                        "401sq-ft-809sq-ft,1090Units",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                      ),
                                      Text(
                                        "1bhk,2bhk,3 bhk ready to move",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(Icons.architecture_rounded,
                                          color: CustomTheme.ternaryColor),
                                      // Your icon here
                                      SizedBox(width: 20),
                                      // Adjust spacing between icon and text
                                      Text(
                                        'Project Area',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                      ),
                                      Text(
                                        "500Acres",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 10,
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
                                      Icon(Icons.architecture_rounded,
                                          color: CustomTheme.ternaryColor),
                                      // Your icon here
                                      SizedBox(width: 20),
                                      // Adjust spacing between icon and text
                                      Text(
                                        'Rera ID',
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 12,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 45,
                                      ),
                                      Text(
                                        "50023123w",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            "Mumbai, city, capital of Maharashtra state, southwestern India. It is the country's financial and commercial centre and its principal port on the Arabian Sea. Located on Maharashtra's coast, Mumbai is India's most-populous city, and it is one of the largest and most densely populated urban areas in the world.",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 15,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CustomTheme.primaryColor,
                                ),
                                child: const Text(
                                  "Chat for details",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),

                      //khatam
                      //ek aur shur
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amenities',
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineMedium,
                                fontSize: 20,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            SizedBox(height: 10),
                            buildAmenityRow(
                              "Recreational Facilities",
                              Icons.check,
                            ),
                            buildAmenityRow("Multipurpose Hall",
                                Icons.room_preferences_outlined),
                            buildAmenityRow("Salon", Icons.schedule_send),
                            if (showAllAmenities)
                              Column(
                                children: [
                                  buildAmenityRow("Steam Room",
                                      Icons.restaurant_menu_sharp),
                                  buildAmenityRow("Party Lawn",
                                      Icons.accessibility_new_rounded),
                                  buildAmenityRow("Spa", Icons.spa),
                                  buildAmenityRow("Health", Icons.headphones),
                                ],
                              ),
                            if (showAllAmenities)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showAllAmenities = false;
                                  });
                                },
                                child: Text(
                                  'Show Less',
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    fontSize: 12,
                                    color: CustomTheme.ternaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            if (!showAllAmenities)
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showAllAmenities = true;
                                  });
                                },
                                child: Text(
                                  'Load More',
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    fontSize: 12,
                                    color: CustomTheme.ternaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      //ek aur khatam
                      //third Shuru
                      SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Contact details",
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: showAllContacts
                                    ? contacts.length
                                    : visibleContacts,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      buildContactItem(contacts[index]),
                                      const SizedBox(height: 15),
                                      // Height between each contact item
                                    ],
                                  );
                                },
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    showAllContacts = !showAllContacts;
                                  });
                                },
                                child: Text(
                                  showAllContacts ? "Show Less" : "Load More",
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                    fontSize: 12,
                                    color: CustomTheme.ternaryColor,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          //third khatam
                          //fourth shuru
                          SizedBox(height: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Question And Answer",
                                style: GoogleFonts.poppins(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  fontSize: 18,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              SizedBox(height: 30),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isAnswerShown = !isAnswerShown;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "What is this property?",
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        isAnswerShown
                                            ? Icons.remove
                                            : Icons.add,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              if (isAnswerShown)
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "It is my property.",
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isAnswer2Shown = !isAnswer2Shown;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "What is the carpet area?",
                                          style: GoogleFonts.poppins(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        isAnswer2Shown
                                            ? Icons.remove
                                            : Icons.add,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              if (isAnswer2Shown)
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "1500",
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 60),
                          Text(
                            "Location: ",
                            style: GoogleFonts.poppins(
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontSize: 18,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            height: 200,
                            // Add the line below
                            padding: const EdgeInsets.all(8),
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                border: Border.all(
                                    color: CustomTheme.fifthColor, width: 1.0)),
                            child: const SfMaps(
                              layers: [
                                MapTileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  initialFocalLatLng:
                                      MapLatLng(27.1751, 78.0421),
                                  initialZoomLevel: 5,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 60),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    Container(
                                      width: 250,
                                      child: Text(
                                        widget.screenStatus == "buy"
                                            ? "The purchase price will be determined within the range of -20 to"
                                                "20 rupees above the original buying price, and a refund will be issued if the "
                                                "buying price decreases."
                                            : "The selling price will be computed within a range of -20 to 20 rupees based on "
                                                "the original selling price, and an equivalent amount will be credited to the user's account",
                                        style: GoogleFonts.poppins(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headlineMedium,
                                          fontSize: 13,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 60),
                                TextFormField(
                                  controller: nameController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    print('====== $value');
                                    if (value != null && value.length == 0) {
                                      return 'Please Enter Token Count';
                                    }
                                    if (int.parse(value!) >
                                        widget.prop.tokenRequested) {
                                      EasyLoading.showToast(
                                          "Token count cannot be greater than token balance");
                                      return "Entered value greater than token balance.";
                                    }

                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0)),
                                      prefixIcon: Icon(Icons.token),
                                      hintText: '1234',
                                      labelText: 'TOKEN COUNT'),
                                ),
                                const SizedBox(height: 15),
                                TextFormField(
                                  controller: remarksController,
                                  keyboardType: TextInputType.multiline,
                                  validator: (value) {
                                    if (value != null && value.length == 0) {
                                      return 'Please Enter Remarks';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.0)),
                                          borderSide: BorderSide(
                                              color: Colors.black, width: 2.0)),
                                      prefixIcon: Icon(Icons.message),
                                      hintText: 'Any Remarks by Buyer',
                                      labelText: 'REMARKS'),
                                ),
                                const SizedBox(height: 35),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(16),
                                      backgroundColor: CustomTheme.fifthColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (isChecked == false) {
                                        print("false:  ");
                                        EasyLoading.showError(
                                            "Please accept the checkbox");
                                        return;
                                      }

                                      if (_formKey.currentState!.validate()) {
                                        if (kycStatus == "N") {
                                          EasyLoading.showError(
                                              "Please complete KYC");
                                          return;
                                        }

                                        print(
                                            "token sell price: ${widget.prop.tokenPrice}");

                                        // showModalBottomSheet(
                                        //   context: context,
                                        //   builder: (context) {
                                        //     return Wrap(
                                        //       children: [
                                        //         ListTile(
                                        //           leading: Icon(Icons.share),
                                        //           title: Text('Select option'),
                                        //
                                        //         ),
                                        //         ListTile(
                                        //           leading: Icon(Icons.r_mobiledata),
                                        //           title: Text('Razorpay'),
                                        //           onTap: () {
                                        //             print('select option');
                                        //             const RazorPaypage();
                                        //           },
                                        //         ),
                                        //         ListTile(
                                        //           leading: Icon(Icons.account_circle),
                                        //           title: Text('Metamask'),
                                        //           onTap: () {
                                        //             print('select option');
                                        //           },
                                        //         ),
                                        //       ],
                                        //     );
                                        //   },
                                        // );

                                        EasyLoading.show(
                                            status: "submitting request..");

                                        // print(
                                        //     "tokenprice in screenshot: ${image1!.path}");
                                        print(
                                            "sahi propid price: ${widget.prop.id}");
                                        print(
                                            "sahi propid price: ${widget.prop.propId}");

                                        Timer(Duration(seconds: 3), () async {
                                          var response = null;

                                          response = await PropertyController
                                              .postTheSellerRequest(
                                                  widget.prop,
                                                  username!,
                                                  userId!,
                                                  nameController.text!,
                                                  remarksController.text!,
                                                  "null",
                                                  "null",
                                                  widget.prop.tokenPrice,
                                          );
                                          if (response == "true") {
                                            EasyLoading.showSuccess(
                                                "Token Sell Request Successfull");
                                            Timer(Duration(seconds: 2), () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowAllVerifiedProperties(
                                                          screenStatus: widget.screenStatus,
                                                        )),
                                              );
                                            });
                                          } else {
                                            EasyLoading.showError(
                                                "Token Buy Requested Failed");
                                            Timer(Duration(seconds: 2), () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShowAllVerifiedProperties(
                                                          screenStatus: widget
                                                              .screenStatus,
                                                        )),
                                              );
                                            });
                                          }
                                        });

                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           PaymentMetamask(
                                        //             tokenPrice: widget.prop.tokenPrice,
                                        //             prop: widget.prop,
                                        //             name: nameController.text!,
                                        //             remarks:
                                        //                 remarksController.text,
                                        //             username: username!,
                                        //             userId: userId!,
                                        //             screenstatus:
                                        //                 widget.screenStatus,
                                        //           )),
                                        // );
                                      }
                                    },
                                    child: widget.screenStatus == 'sell'
                                        ? Text(
                                            "Sell",
                                            style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          )
                                        : Text(
                                            'Buy',
                                            style: GoogleFonts.poppins(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge,
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

PreferredSizeWidget _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back, color: Colors.black),
    ),
  );
}

Widget productPageView(double width, double height, Buyer prop) {
  List<String> listImages = [];
  listImages.add(prop.propImage1Byte);
  listImages.add(prop.propImage2Byte);
  listImages.add(prop.propImage3Byte);

  return Container(
    height: height * 0.42,
    width: width,
    decoration: const BoxDecoration(
      color: Color(0xFFE5E6E8),
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(200),
        bottomLeft: Radius.circular(200),
      ),
    ),
    child: CarouselSlider(items: listImages),
  );
}

Widget _ratingBar(BuildContext context) {
  return Wrap(
    spacing: 30,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      RatingBar.builder(
        initialRating: 3,
        direction: Axis.horizontal,
        itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
        onRatingUpdate: (_) {},
      ),
      Text(
        "(4500 Reviews)",
        style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.labelLarge,
          fontSize: 14,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
        ),
      )
    ],
  );
}

Widget buildContactItem(Contact contact) {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(contact.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                contact.role,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.normal,
                ),
              ),
              Text(
                contact.value,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.normal,
                ),
              )
            ],
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // Implement your contact button logic here
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: CustomTheme.primaryColor,
          ),
          child: Text(
            "Contact",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}

class Contact {
  final String name;
  final String role;
  final String value;
  final String imagePath;

  Contact(this.name, this.role, this.value, this.imagePath);
}

Widget buildAmenityRow(String text, IconData icon) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Icon(icon, color: CustomTheme.ternaryColor),
        const Spacer(),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    ),
  );
}

class Model {
  const Model(this.country, this.latitude, this.longitude);

  final String country;
  final double latitude;
  final double longitude;
}
