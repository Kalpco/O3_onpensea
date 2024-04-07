import "package:flutter/material.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";

import "../../../config/CustomTheme.dart";
import "../../../widgets/CustomButton.dart";
import "otpScreen3.dart";

class OtpScreen2 extends StatefulWidget {
  final String name;
  final String fatherName;
  final String gender;

  const OtpScreen2(
      {Key? key,
      required this.name,
      required this.fatherName,
      required this.gender})
      : super(key: key);

  @override
  State<OtpScreen2> createState() => _OtpScreen2();
}

class _OtpScreen2 extends State<OtpScreen2> {
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController emailController = TextEditingController();

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
              image: DecorationImage(image: AssetImage(CustomTheme.logo)),
              color: Colors.blue,
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
            ),
          ),

          SizedBox(
            height: size.height * 0.04,
          ),

          //email & password textField
          cityControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          stateControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          emailControllerTextField(size),
          //this is the gender controller
          SizedBox(
            height: size.height * 0.02,
          ),
          //remember & forget text
          /*buildRememberForgetSection(),*/
          SizedBox(
            height: size.height * 0.05,
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
                  onPressed: () {
                    String city = cityController.text ?? '';
                    String state = stateController.text ?? '';
                    String email = emailController.text ?? '';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen3(
                          city: city,
                          state: state,
                          email: email,
                          name: widget.name,
                          fatherName: widget.fatherName,
                          gender: widget.gender,
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
                  child: Text(
                    "Continue",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cityControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: cityController,
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.name,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter your City',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: cityController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: cityController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.gps_fixed,
              color: cityController.text.isEmpty
                  ? const Color(0xFF66BE).withOpacity(0.5)
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
              child: cityController.text.isEmpty
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

  Widget stateControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: stateController,
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.text,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter your State',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: stateController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: stateController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.gps_fixed,
              color: stateController.text.isEmpty
                  ? const Color(0xFF66BE).withOpacity(0.5)
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
              child: stateController.text.isEmpty
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

  Widget emailControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: emailController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your Email',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: emailController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: emailController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.email,
              color: emailController.text.isEmpty
                  ? const Color(0xFF66BE).withOpacity(0.5)
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
              child: emailController.text.isEmpty
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
