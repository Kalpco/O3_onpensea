import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/Property/Feature-registerNewProperty/Screens/Forms/RegisterPropertyFive.dart';
import 'package:onpensea/UserManagement/Feature-ApplyForTokens/Models/Properties.dart';
import 'package:onpensea/UserManagement/Feature-ApplyForTokens/Screens/Forms/FormThree.dart';

import '../../../../config/CustomTheme.dart';
import '../../../../widgets/CustomButton.dart';
import 'RegistrePropertyFour.dart';

class RegisterPropertyThree extends StatefulWidget {
  final String propName;
  final String address;
  final String city;
  final String pincode;
  final String state;
  final String propValue;
  final String ownerName;
  final String ownerId;

  const RegisterPropertyThree({
    Key? key,
    required this.propName,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.propValue,
    required this.ownerName,
    required this.ownerId,
  }) : super(key: key);

  @override
  State<RegisterPropertyThree> createState() => _RegisterPropertyThree();
}

class _RegisterPropertyThree extends State<RegisterPropertyThree> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController tokenRequestedController = TextEditingController();
  TextEditingController tokenNameController = TextEditingController();
  TextEditingController tokenSymbolController = TextEditingController();
  TextEditingController tokenCapacityController = TextEditingController();

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
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
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
                labelText(label: "Token Name"),
                textField(
                    hintText: "Enter Token Name",
                    icon: Icons.email,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: tokenNameController),
                labelText(label: "Token Requested"),
                textField(
                    hintText: "Enter Token Requested",
                    icon: Icons.edit,
                    inputType: TextInputType.number,
                    maxLines: 1,
                    controller: tokenRequestedController),
                labelText(label: "Token Symbol"),
                textField(
                    hintText: "Enter Token Symbol",
                    icon: Icons.edit,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: tokenSymbolController),
                labelText(label: "Token Capacity"),
                textField(
                    hintText: "Enter Token Capacity",
                    icon: Icons.edit,
                    inputType: TextInputType.number,
                    maxLines: 1,
                    controller: tokenCapacityController),
              ]),
            ),
            //email & password textField

            SizedBox(
              height: size.height * 0.02,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterPropertyFour(
                                              propName: widget.propName,
                                              address: widget.address,
                                              city: widget.city,
                                              pincode: widget.pincode,
                                              state: widget.state,
                                              propValue: widget.propValue,
                                              ownerName: widget.ownerName,
                                              ownerId: widget.ownerId,
                                              tokenRequested:
                                                  tokenRequestedController.text,
                                              tokenName:
                                                  tokenNameController.text,
                                              tokenSymbol:
                                                  tokenSymbolController.text,
                                              tokenCapacity:
                                                  tokenCapacityController
                                                      .text)),
                                );
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
                              "Next",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                  style: TextStyle(
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
