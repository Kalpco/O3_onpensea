import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/config/CustomTheme.dart';
import 'package:provider/provider.dart';

import '../../../provider/AuthProvider.dart';
import '../../../widgets/CustomButton.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen> {

  final TextEditingController phoneController = TextEditingController();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(TextPosition(
      offset: phoneController.text.length,
    ));
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
            child: SizedBox(
              height: size.height,
              child: Center(
                child: buildCard(size),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      width: size.width * 0.9,
      height: size.height * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
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
            height: size.height * 0.05,
          ),

          //email & password textField
          phoneControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),

          SizedBox(
            height: size.height * 0.03,
          ),

          //this is the gender controller
          SizedBox(
            height: size.height * 0.03,
          ),
          //remember & forget text
          /*buildRememberForgetSection(),*/
          SizedBox(
            height: size.height * 0.04,
          ),
          combineButton(),
        ],
      ),
    );
  }

  Widget combineButton() {
    return Align(
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
                  onPressed: () => {
                    EasyLoading.show(status: "loading..."),
                    sendPhoneNumber(),
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
                  child: const Text('Continue'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget phoneControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          onChanged: (value) {
            setState(() {
              phoneController.text = value;
            });
          },
          cursorColor: Colors.pinkAccent,
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "Enter phone number",
            hintStyle: GoogleFonts.inter(
              fontSize: 14.0,
              color: Colors.grey.shade500,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black12),
            ),
            prefixIcon: Container(
              padding: const EdgeInsets.all(16),
              child: InkWell(
                onTap: () {
                  showCountryPicker(
                      context: context,
                      countryListTheme:
                          const CountryListThemeData(bottomSheetHeight: 550),
                      onSelect: (value) {
                        setState(() {
                          selectedCountry = value;
                        });
                      });
                },
                child: Text(
                  "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                  style: GoogleFonts.inter(
                    fontSize: 18.0,
                    color: const Color(0xFF151624),
                  ),
                ),
              ),
            ),
            suffixIcon: phoneController.text.length > 9
                ? Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.green),
                    child: const Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 20,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    ap.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
