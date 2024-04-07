import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Admin/Feature-VerifyProperties/Controller/PropertyController.dart';
import 'package:onpensea/Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import 'package:onpensea/Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Screens/common_dashboard_screen.dart';

import '../../../config/CustomTheme.dart';
import '../Models/Properties.dart';
import '../Widgets/carousel_slider.dart';
import '../Widgets/page_wrapper.dart';

class ShowIndividualProperty extends StatelessWidget {
  final Properties prop;
  final String screenStatus;
  final String username;

  const ShowIndividualProperty(this.prop,
      {super.key, required this.screenStatus, required this.username});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> listImages = [];
    listImages.add(prop.propImage1Byte);
    listImages.add(prop.propImage2Byte);
    listImages.add(prop.propImage3Byte);

    return MaterialApp(
      builder: EasyLoading.init(),
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          bottomSheet: Container(
            padding: const EdgeInsets.all(8.0),
            height: 60,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                        onPressed: () {
                          var duration = Duration(seconds: 2);
                          var durationOne = Duration(seconds: 3);
                          EasyLoading.show(status: 'Rejecting...');
                          Timer(durationOne, () {
                            PropertyController.approveProperty(
                                    prop.id, "R", username)
                                .then((response) {
                              if (response == "success") {
                                EasyLoading.showSuccess(
                                    '${prop.id} request rejected!');
                                Timer(duration, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShowAllPendingProperties(
                                                screenStatus: screenStatus)),
                                  );
                                });
                              }
                            });
                          });
                        },
                        child: Text("Reject"),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomTheme.fifthColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        onPressed: () {
                          var duration = Duration(seconds: 2);
                          var durationOne = Duration(seconds: 3);
                          EasyLoading.show(status: 'Accepting...');
                          Timer(durationOne, () {
                            PropertyController.approveProperty(
                                    prop.id, "I", username)
                                .then((response) {
                              if (response == "success") {
                                EasyLoading.showSuccess(
                                    '${prop.id} request accepted!');
                                Timer(duration, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ShowAllPendingProperties(
                                                screenStatus: screenStatus)),
                                  );
                                });
                              }
                            });
                          });
                        },
                        child: Text(
                          "Approve",
                          style: GoogleFonts.poppins(
                            textStyle: Theme.of(context).textTheme.labelLarge,
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          extendBodyBehindAppBar: true,
          appBar: _appBar(context),
          body: SingleChildScrollView(
            child: PageWrapper(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productPageView(width, height, prop),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prop.propName,
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineLarge,
                            fontSize: 42,
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
                                  ? "\u{20B9} ${prop.propValue}"
                                  : "\u{20B9} ${prop.propValue}",
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineLarge,
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            const SizedBox(width: 1),
                            // Visibility(
                            //   visible: true != null ? true : false,
                            //   child: Text(
                            //     "\u{20B9}${prop.tokenBalance}",
                            //     style: const TextStyle(
                            //       decoration: TextDecoration.lineThrough,
                            //       color: Colors.grey,
                            //       fontWeight: FontWeight.w500,
                            //     ),
                            //   ),
                            // ),
                            const Spacer(),
                            // Text(
                            //   prop.tokenBalance != 0
                            //       ? "Available in stock"
                            //       : "Not available",
                            //   style: GoogleFonts.poppins(
                            //     textStyle:
                            //         Theme.of(context).textTheme.headlineMedium,
                            //     fontSize: 16,
                            //     color: Colors.lightGreen,
                            //     fontWeight: FontWeight.w500,
                            //     fontStyle: FontStyle.normal,
                            //   ),
                            // )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Token Name : ${prop.tokenName} ",
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Token Symbol : ${prop.tokenSymbol} ",
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Token Available : ${prop.tokenBalance} ",
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
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
                          'Owner Name : ${prop.ownerName}',
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Property Id : ${prop.id}',
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Property Registred Date: ${prop.propRegisteredDate.split("T")[0]}',
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Address: ${prop.address}',
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Token count: ${prop.tokenCap}',
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Token Price: ${prop.tokenPrice}',
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Remarks: NA',
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineMedium,
                            fontSize: 20,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  )
                ],
              ),
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

Widget productPageView(double width, double height, Properties prop) {
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
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(fontWeight: FontWeight.w300),
      )
    ],
  );
}
