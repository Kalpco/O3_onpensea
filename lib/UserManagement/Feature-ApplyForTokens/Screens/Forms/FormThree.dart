import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/UserManagement/Feature-ApplyForTokens/Controller/TokenController.dart';
import 'package:onpensea/UserManagement/Feature-ApplyForTokens/Models/Properties.dart';
import 'package:onpensea/UserManagement/Feature-ApplyForTokens/Screens/ShowAllPendingPropertiesToken.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Admin/Feature-VerifyBuy/Controller/BuyController.dart';
import '../../../../config/CustomTheme.dart';
import '../../../../widgets/CustomButton.dart';
import '../../../Feature-Dashboard/Screens/common_dashboard_screen.dart';

class FormThree extends StatefulWidget {
  final String propertyName;
  final String propId;
  final String propertyOwnerName;

  final String tokenName;
  final String tokenSymbol;
  final String tokenCap;
  final String tokenSupply;
  final String tokenBalance;
  final Properties props;

  const FormThree(
      {Key? key,
      required this.propertyOwnerName,
      required this.propId,
      required this.propertyName,
      required this.tokenName,
      required this.tokenSupply,
      required this.tokenCap,
      required this.tokenBalance,
      required this.tokenSymbol,
      required this.props})
      : super(key: key);

  @override
  State<FormThree> createState() => _FormThreeScreen();
}

class _FormThreeScreen extends State<FormThree> {
  final smartContractAddressController = TextEditingController();
  final noOfBlockController = TextEditingController();
  final tokenPriceController = TextEditingController();
  final userIdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? username;
  String? photo;
  String? mobile;
  String? email;

  void initState() {
    super.initState();
    tokenPriceController..text = widget.props.tokenPrice.toString();
    getUsername();
  }

  Future<void> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      photo = prefs.getString("photo");
      mobile = prefs.getString("mobile");
      email = prefs.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: CustomTheme.primaryColor,
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: CustomTheme.customLinearGradient,
            ),
            child: Form(
              key: _formKey,
              child: SafeArea(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo & text
            // logo(size.height / 8, size.height / 8),
            SizedBox(
              height: size.height * 0.01,
            ),
            //richText(24),
            Container(
              width: 200.0,
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage(CustomTheme.logo)),
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              margin: const EdgeInsets.only(top: 20),
              child: Column(children: [
                labelText(label: "Smart Contract Addres"),
                textField(
                    hintText: "Smart Contract Address",
                    icon: Icons.account_circle,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: smartContractAddressController),
                labelText(label: "No. of Block"),
                textField(
                    hintText: "No of Block",
                    icon: Icons.email,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: noOfBlockController),
                labelText(label: "Token Price"),
                textField(
                    hintText: "Token Price",
                    icon: Icons.edit,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: tokenPriceController),
              ]),
            ),
            //email & password textField

            SizedBox(height: size.height * 0.08),
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
                        padding: EdgeInsets.only(left: 8.0),
                        height: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              var duration = Duration(seconds: 5);
                              var durationOne = Duration(seconds: 3);
                              EasyLoading.show(status: 'Accepting...');
                              Timer(durationOne, () {
                                TokenController.approveBuyer(
                                        username: username!,
                                        smartContractAddress:
                                            smartContractAddressController.text,
                                        props: widget.props,
                                        noOfBlock: noOfBlockController.text,
                                        userId: userIdController.text)
                                    .then((value) => {
                                          if (value == "success")
                                            {
                                              EasyLoading.showSuccess(
                                                  'Token Submitted'),
                                              Timer(durationOne, () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ShowAllPendingPropertiesToken(
                                                              screenStatus:
                                                                  "buy")),
                                                );
                                              })
                                            }
                                          else
                                            {
                                              EasyLoading.showError(
                                                  'Failed to submit'),
                                              Timer(durationOne, () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ShowAllPendingPropertiesToken(
                                                              screenStatus:
                                                                  "buy")),
                                                );
                                              })
                                            }
                                        });
                              });
                            }
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
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: size.height * 0.01,
            ),
          ],
        ),
      ),
    );
  }

  Widget labelText({required label}) {
    return Column(
      children: [
        Container(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: EdgeInsets.only(left: 6.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: "Poppins",
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                )),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget textField({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter some text";
          }
          return null;
        },
        cursorColor: Colors.pinkAccent,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: CustomTheme.fifthColor,
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.grey.shade100,
          filled: true,
        ),
      ),
    );
  }
}
