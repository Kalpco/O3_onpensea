import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onpensea/Property/show-alldetails/Models/buyermodel.dart';
import '../../../Admin/Feature-VerifyBuy/Widgets/page_wrapper.dart';
import '../../../UserManagement/Feature-Dashboard/Widgets/Drawer/DashboardDrawer.dart';
import '../../../config/CustomTheme.dart';
import '../../../widgets/CustomButton.dart';
import '../../Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart';
import '../Controller/PropertyController.dart';

class UploadScreenshot extends StatefulWidget {
  final Buyer prop;
  final String name;
  final String remarks;
  final String userId;
  final String username;
  final String screenstatus;
  final String tokenPrice;

  const UploadScreenshot(
      {super.key,
      required this.prop,
      required this.name,
      required this.remarks,
      required this.username,
      required this.userId,
      required this.screenstatus,
      required this.tokenPrice
      });

  @override
  _UploadScreenshotState createState() => _UploadScreenshotState();
}

class _UploadScreenshotState extends State<UploadScreenshot> {
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;
  String? walletAddress;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  XFile? image1;

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  @override
  void dispose() {
    super.dispose();
    _scaffoldKey.currentState?.dispose();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  Future<void> _getImageFromCamera1() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      image1 = image as XFile?;
    });
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
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: CustomButton(
                        text: "Back",
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 8.0),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {

                          EasyLoading.show(status: "submitting request..");

                          print("tokenprice in screenshot: ${image1!.path}");
                          print("sahi propid price: ${widget.prop.id}");
                          print("sahi propid price: ${widget.prop.propId}");

                          Timer(Duration(seconds: 3), () async {
                            var response = null;

                            response =
                                await PropertyController.postTheSellerRequest(
                                    widget.prop,
                                    widget.username!,
                                    widget.userId!,
                                    widget.name,
                                    widget.remarks,
                                    image1!.path,
                                    walletAddress!,
                                  widget.tokenPrice
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
                                            screenStatus: widget.screenstatus,
                                          )),
                                );
                              });
                            } else {
                              EasyLoading.showError("Token Buy Requested Failed");
                              Timer(Duration(seconds: 2), () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ShowAllVerifiedProperties(
                                            screenStatus: widget.screenstatus,
                                          )),
                                );
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Colors.purple.shade900,
                          textStyle: GoogleFonts.inter(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: GoogleFonts.inter(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        key: _scaffoldKey,
        drawer: DashboardDrawer(
            walletAddress: walletAddress,
            userType: userType,
            username: username,
            email: email,
            mobile: mobile,
            photo: photo),
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
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage('assets/images/Bitcoin.svg.png'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Upload: Payment Screenshot',
                    style: GoogleFonts.poppins(
                      textStyle: Theme.of(context).textTheme.headlineMedium,
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  SizedBox(height: 10),
                  image1 != null
                      ? Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 60.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  iconSize: 25,
                                  color: Colors.pink,
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      image1 = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Image.file(File(image1!.path),
                                width: 200, height: 250)
                          ],
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(100, 50),
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                          ),
                          onPressed: _getImageFromCamera1,
                          child: Text("Image 1"),
                        ),
                  const SizedBox(
                    height: 40,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 280,
                      child: Text(
                        "Note: Upload the payment screenshot. If payment not successful, click back to try again.",
                        style: GoogleFonts.poppins(
                          textStyle: Theme.of(context).textTheme.headlineMedium,
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
