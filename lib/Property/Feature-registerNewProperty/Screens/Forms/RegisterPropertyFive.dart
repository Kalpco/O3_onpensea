import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/Property/Feature-registerNewProperty/Controller/RegisterPropertyController.dart';
import 'package:onpensea/Property/Feature-registerNewProperty/Model/RegisterPropertyModel.dart';
import 'package:onpensea/UserManagement/Feature-Dashboard/Screens/common_dashboard_screen.dart';
import 'package:onpensea/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../CheckoutRegisterProperty/Screens/CheckoutScreen.dart';
import '../../../../config/CustomTheme.dart';
import '../../../../widgets/CustomButton.dart';

class RegisterPropertyFive extends StatefulWidget {
  final String propName;
  final String address;
  final String city;
  final String pincode;
  final String state;
  final String propValue;
  final String ownerName;
  final String ownerId;

  final String tokenRequested;
  final String tokenName;
  final String tokenSymbol;
  final String tokenCapacity;
  final String tokenSupply;
  final String tokenBalance;

  const RegisterPropertyFive({
    Key? key,
    required this.propName,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.propValue,
    required this.ownerName,
    required this.ownerId,
    required this.tokenRequested,
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenCapacity,
    required this.tokenSupply,
    required this.tokenBalance,
  }) : super(key: key);

  @override
  State<RegisterPropertyFive> createState() => _RegisterPropertyFive();
}

class _RegisterPropertyFive extends State<RegisterPropertyFive> {
  ///controller
  XFile? image1;
  XFile? image2;
  XFile? image3;
  File? saleDeed;
  String? username;
  String? photo;
  String? mobile;
  String? email;
  String? userType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUsername();
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _getImageFromCamera1() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      image1 = image as XFile?;
    });
  }

  Future<void> _getImageFromCamera2() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      image2 = image as XFile?;
    });
  }

  Future<void> _getImageFromCamera3() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      image3 = image as XFile?;
    });
  }

  Future<void> _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      final filePath = result.files.single.path;
      if (filePath != null) {
        setState(() {
          saleDeed = File(filePath);
        });
      }
    }
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
      userType = prefs.getString("userType");
    });
  }

  Widget uploadPropertyImages() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Upload Images :",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                image1 != null
                    ? Image.file(File(image1!.path), width: 100, height: 100)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(100, 50),
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: _getImageFromCamera1,
                        child: Text("Image 1"),
                      ),
                const SizedBox(
                  height: 10,
                ),
                image2 != null
                    ? Image.file(File(image2!.path), width: 100, height: 100)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(100, 50),
                          backgroundColor: Colors.blueGrey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: _getImageFromCamera2,
                        child: Text("Image 2"),
                      ),
                const SizedBox(
                  height: 10,
                ),
                image3 != null
                    ? Image.file(File(image3!.path), width: 100, height: 100)
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(100, 50),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueGrey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        onPressed: _getImageFromCamera3,
                        child: Text("Image 3"),
                      ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Upload PDF:",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          saleDeed != null
              ? Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                            width: 230,
                            child: Text('PDF Uploaded: ${saleDeed!.path}')),
                        IconButton(
                          iconSize: 20,
                          color: Colors.pink,
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              saleDeed = null;
                            });
                          },
                        ),
                        /* ElevatedButton.icon(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              saleDeed = null;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pinkAccent,
                          ),
                          label: Text("close"),
                        )*/
                      ],
                    ),
                  ),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  onPressed: _pickPDF,
                  child: Text("Upload PDF"),
                ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: CustomTheme.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: CustomTheme.customLinearGradient,
          ),
          child: SafeArea(
            child: Form(
              key: _formKey,
              child: SizedBox(
                height: size.height,
                child: Center(
                  child: buildCard(size),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            width: 200.0,
            height: 200.0,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(CustomTheme.logo)),
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          uploadPropertyImages(),
          SizedBox(height: size.height * 0.06),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      padding: const EdgeInsets.only(left: 8.0),
                      height: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          if (image1 == null ||
                              image2 == null ||
                              image3 == null) {
                            EasyLoading.showToast("Forgot to Upload image");
                            return;
                          }
                          if (saleDeed == null) {
                            EasyLoading.showToast("Forgot to Upload pdf");
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                      screenStatus: "property",
                                      propName: widget.propName,
                                      address: widget.address,
                                      ownerName: widget.ownerName,
                                      city: widget.city,
                                      ownerId: widget.ownerId,
                                      pincode: widget.pincode,
                                      state: widget.state,
                                      propValue: widget.propValue,
                                      tokenRequested: widget.tokenRequested,
                                      tokenName: widget.tokenName,
                                      tokenSymbol: widget.tokenSymbol,
                                      tokenCapacity: widget.tokenCapacity,
                                      tokenSupply: widget.tokenSupply,
                                      tokenBalance: widget.tokenBalance,
                                      image1: image1,
                                      image2: image2,
                                      image3: image3,
                                      saleDeed: saleDeed,
                                      userName: username,
                                    )),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          backgroundColor: Colors.purple.shade900,
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.inter(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: Text(
                          "Submit",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
