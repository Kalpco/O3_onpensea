import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Admin/Feature-VerifyBuy/Screens/ShowAllVerifyBuy.dart';
import 'package:onpensea/Admin/Feature-VerifyProperties/Screens/ShowAllPendingProperties.dart';
import 'package:onpensea/Admin/Feature-VerifySell/Screens/ShowAllVerifySell.dart';
import 'package:onpensea/Nfts/Screens/all_nfts_screen.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Screens/common_dashboard_screen.dart';
import 'package:onpensea/config/ApiUrl.dart';
import 'package:onpensea/config/CustomTheme.dart';
import 'package:onpensea/movies/Screens/all_movie_screen.dart';
import '../../../../Chatbot/Screen/chatbot_screen.dart';
import '../../../../GoldTokens/Screens/all_gold_screen.dart';
import '../../../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../../../../Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyOne.dart';
import '../../../../Property/show-alldetails/Screens/BoughtProperties.dart';
import '../../../../facevalue/Screens/all_Facevalue_screen.dart';
import '../../../../utils/utils.dart';
import '../../../Feature-UserLogin/Screens/login_screen.dart';
import '../../Model/AllDetails.dart';
import '../../Screens/WidgetToDisplayAlltheCities.dart';
import '../../Widgets/Drawer/DrawerItem.dart';
import '../../../../utils/utils.dart';

class DashboardDrawer extends StatefulWidget {
  final String? username;
  final String? email;
  final String? mobile;
  final String? photo;
  final String? userType;
  final String? categoryType;
  final String? walletAddress;

  const DashboardDrawer(
      {super.key,
      required this.username,
      required this.email,
      required this.mobile,
      required this.photo,
      required this.userType,
      this.categoryType,
      this.walletAddress});

  @override
  State<DashboardDrawer> createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  File? image;
  bool? isChangeProfilePhotoButtonClicked = false;

  void selectImage() async {
    image = await pickImage(context);
    updateProfilePic();
    Timer(const Duration(milliseconds: 3000), () {
      setState(() {
        isChangeProfilePhotoButtonClicked = true;
      });
    });
  }

  void updateProfilePic() async {
    print("updating profile picture");
    var dio = Dio();
    String fileName = image!.path.split('/').last;
    var formData = FormData.fromMap({
      "emailId": widget.email,
      "photo": await MultipartFile.fromFile(image!.path,
          filename: "${widget.username}. ${fileName.split(".").last}")
    });
    var response = await dio.post(
        "${ApiUrl.API_URL_USERMANAGEMENT}user/profilePicture",
        data: formData);
    print("response: ${response!.data}");
    EasyLoading.showSuccess(response.data.toString());
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient = CustomTheme.customLinearGradient;

    if (widget.categoryType == "gold") {
      gradient = CustomTheme.customLinearGradientForGold;
    } else if (widget.categoryType == "movies") {
      gradient = CustomTheme.customLinearGradientForMovies;
    } else if (widget.categoryType == "nfts") {
      gradient = CustomTheme.customLinearGradientForNft;
    }

    print("===============================================!!!!!!!!!!!!!");
    print("circularbutton presed: $isChangeProfilePhotoButtonClicked");
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.9,
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: gradient,
                  ),

                  // Set the background color for "Easy Access"
                  child: Column(
                    children: [
                      const SizedBox(height: 70),
                      Stack(children: [
                        InkWell(
                            onTap: () => selectImage(),
                            child: isChangeProfilePhotoButtonClicked == true
                                ? ((image != null)
                                    ? CircleAvatar(
                                        backgroundImage: FileImage(image!),
                                        radius: 50)
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: MemoryImage(
                                            base64Decode(widget.photo!)),
                                      ))
                                : ((widget.photo! == "NA")
                                    ? const CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(
                                            "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: MemoryImage(
                                            base64Decode(widget.photo!)),
                                      ))),
                        const Positioned(
                            bottom: 10,
                            right: 20,
                            child: Icon(Icons.camera_alt,
                                size: 18, color: Colors.black26))
                      ]),
                      // const SizedBox(
                      //   height: 2,
                      // ),
                      Container(
                          alignment: Alignment.center,
                          width: 500,
                          child: Column(
                            children: [
                              Text(widget.username!,
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: 28,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                              Text("+91 ${widget.mobile!}",
                                  style: GoogleFonts.poppins(
                                    textStyle:
                                        Theme.of(context).textTheme.bodyLarge,
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                              Text(widget.email!,
                                  style: GoogleFonts.poppins(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                child: Text(widget.walletAddress!,
                                    style: GoogleFonts.poppins(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    )),
                              ),
                            ],
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                DrawerItem(
                  "Back to HomePage",
                  Icons.chevron_left,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen(
                                email: widget.email!,
                              )),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DrawerItem(
                  "Movies",
                  Icons.movie,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllMovieScreen(
                                categoryType: "movies",
                                screenStatus: 'buy',
                              )),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DrawerItem(
                  "Gold Tokens",
                  Icons.currency_bitcoin,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllGoldScreen(
                                categoryType: "gold",
                                screenStatus: 'buy',
                              )),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DrawerItem(
                  "Nfts",
                  Icons.token,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllNftScreen(
                                categoryType: "nfts",
                                screenStatus: 'buy',
                              )),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DrawerItem(
                  "Face Value",
                  Icons.token,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AllFacevalueScreen(
                            categoryType: "nfts",
                            screenStatus: 'buy',
                          )),
                    );
                  },
                ),
                const SizedBox(height: 20),
                DrawerItem(
                  "Personal Portfolio",
                  Icons.supervised_user_circle,
                  () {
                    // Navigation logic for Pay
                    Navigator.pop(context); // Close the drawer
                    // Add navigation logic for Pay here
                  },
                ),

                const SizedBox(height: 5),

                DrawerItem("Buy", Icons.bubble_chart, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.userType == "ADMIN"
                            ? const ShowAllVerifyBuy(screenStatus: "buy")
                            : const ShowAllVerifiedProperties(
                            screenStatus: 'buy')),
                  );
                }),

                const SizedBox(height: 5),

                DrawerItem("Sell", Icons.sell, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.userType == "ADMIN"
                            ? const ShowAllVerifySell(screenStatus: "sell")
                            : const BoughtProperties(
                                screenStatus: "sell")),
                  );
                }),
                const SizedBox(height: 5),

                DrawerItem(
                    widget.userType == "ADMIN"
                        ? "Verify Property"
                        : "Register Property",
                    Icons.home, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => widget.userType == "ADMIN"
                            ? ShowAllPendingProperties(screenStatus: "buy")
                            : const RegisterPropertyOne()),
                  );
                }),

                SizedBox(height: 20),

                DrawerItem("Setting", Icons.security, () {
                  // Navigation logic for Security Center
                  Navigator.pop(context); // Close the drawer
                  // Add navigation logic for Security Center here
                }),
                SizedBox(height: 5),

                DrawerItem("FAQs", Icons.list, () {
                  // Navigation logic for Security Center
                  Navigator.pop(context); // Close the drawer
                  // Add navigation logic for Security Center here
                }),
                SizedBox(height: 5),

                DrawerItem("Help", Icons.feedback_outlined, () {
                  // Navigation logic for Security Center
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChatbotScreen()),
                  ); // Close the drawer
                  // Add navigation logic for Security Center here
                }),
                SizedBox(height: 5),

                DrawerItem("Contact O3", Icons.contact_emergency, () {
                  // Navigation logic for Security Center
                  Navigator.pop(context); // Close the drawer
                  // Add navigation logic for Security Center here
                }),
                SizedBox(height: 5),
                const Divider(
                  height: 1,
                  color: Colors.black54,
                ),
                DrawerItem("Log out", Icons.logout, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                }),

                // Add more Drawer items here
              ],
            ),
          ),
        ),
      ),
    );
  }
}
