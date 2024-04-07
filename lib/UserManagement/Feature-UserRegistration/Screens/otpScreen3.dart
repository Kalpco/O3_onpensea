import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/CustomTheme.dart';
import '../../../widgets/CustomButton.dart';
import 'otpScreen4.dart';

class OtpScreen3 extends StatefulWidget {
  const OtpScreen3(
      {Key? key,
      required this.name,
      required this.fatherName,
      required this.gender,
      required this.city,
      required this.state,
      required this.email})
      : super(key: key);

  final String name;
  final String fatherName;
  final String gender;
  final String city;
  final String state;
  final String email;

  @override
  State<OtpScreen3> createState() => _OtpScreen3();
}

class _OtpScreen3 extends State<OtpScreen3> {
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController aadharNumberController = TextEditingController();
  TextEditingController panNumberController = TextEditingController();

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
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.8,
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
              image:
                  DecorationImage(image: AssetImage(CustomTheme.logo)),
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(50.0)),
            ),
          ),

          SizedBox(
            height: size.height * 0.04,
          ),

          //email & password textField
          mobileNumberControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          aadharNumberControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          panNumberControllerTextField(size),
          //this is the gender controller
          SizedBox(
            height: size.height * 0.02,
          ),
          SizedBox(
            height: size.height * 0.05,
          ),

          //sign in button
          combineButon(),
        ],
      ),
    );
  }

  Widget combineButon() {
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
                  onPressed: () {
                    String panNumber = panNumberController.text ?? '';
                    String aadharNumber = aadharNumberController.text ?? '';
                    String mobileNumber = mobileNumberController.text ?? '';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen4(
                          panNumber: panNumber,
                          aadharNumber: aadharNumber,
                          mobileNumber: mobileNumber,
                          name: widget.name,
                          fatherName: widget.fatherName,
                          gender: widget.gender,
                          city: widget.city,
                          state: widget.state,
                          email: widget.email,
                        ),
                      ),
                    );
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
                    "Continue",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget mobileNumberControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: mobileNumberController,
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.number,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter MobileNumber',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: mobileNumberController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: mobileNumberController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.mobile_screen_share_rounded,
              color: mobileNumberController.text.isEmpty
                  ? const Color(0xFF66CD).withOpacity(0.5)
                  : const Color.fromRGBO(255, 102, 190, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(255, 102, 190, 1),
              ),
              child: mobileNumberController.text.isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget aadharNumberControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: aadharNumberController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter AdhaarNumber',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: aadharNumberController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: aadharNumberController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(4255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.confirmation_number,
              color: aadharNumberController.text.isEmpty
                  ? const Color(0xFF66CD).withOpacity(0.5)
                  : const Color.fromRGBO(255, 102, 190, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(255, 102, 190, 1),
              ),
              child: aadharNumberController.text.isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget panNumberControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: panNumberController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Enter PanNumber',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: panNumberController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: panNumberController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.panorama_fish_eye,
              color: panNumberController.text.isEmpty
                  ? const Color(0xFF66CD).withOpacity(0.5)
                  : const Color.fromRGBO(255, 102, 190, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(255, 102, 190, 1),
              ),
              child: panNumberController.text.isEmpty
                  ? const Center()
                  : const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 13,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
