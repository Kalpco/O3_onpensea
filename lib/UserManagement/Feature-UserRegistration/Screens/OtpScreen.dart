import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../config/CustomTheme.dart';
import '../../../provider/AuthProvider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/CustomButton.dart';
import 'UserInfoScreen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> {
  String? otpCode;
  TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
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
    var isLoading;
    return Container(
      alignment: Alignment.center,
      width: size.width * 0.9,
      height: size.height * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
            height: size.height * 0.03,
          ),
          SafeArea(
            child: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.pinkAccent,
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      child: Column(children: [
                        Text(
                          "Verfication",
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineLarge,
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "You will get a OTP via SMS",
                          style: GoogleFonts.poppins(
                            textStyle:
                                Theme.of(context).textTheme.headlineLarge,
                            fontSize: 12,
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                            width: 45,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: CustomTheme.primaryColor)),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onCompleted: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: CustomButton(
                            text: "Verify",
                            onPressed: () {
                              if (otpCode != null) {
                                verifyOtp(context, otpCode!);
                              } else {
                                showSnackBar(context, "Enter 6-Digit code");
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Didn't recieve any code? ",
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineLarge,
                                fontSize: 12,
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                            Text(
                              "Resend New Code",
                              style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.headlineLarge,
                                fontSize: 12,
                                color: CustomTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget otpControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: otpController,
          style: GoogleFonts.inter(
            fontSize: 18.0,
            color: const Color(0xFF151624),
          ),
          maxLines: 1,
          keyboardType: TextInputType.number,
          cursorColor: const Color(0xFF151624),
          decoration: InputDecoration(
            hintText: 'Enter your OTP',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: otpController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: otpController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(44, 185, 176, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(44, 185, 176, 1),
                )),
            prefixIcon: Icon(
              Icons.onetwothree_outlined,
              color: otpController.text.isEmpty
                  ? const Color(0xFF151624).withOpacity(0.5)
                  : const Color.fromRGBO(44, 185, 176, 1),
              size: 16,
            ),
            suffix: Container(
              alignment: Alignment.center,
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: const Color.fromRGBO(44, 185, 176, 1),
              ),
              child: otpController.text.isEmpty
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

  void verifyOtp(BuildContext context, String userOtp) {
    EasyLoading.show(status: "Verifying..");
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () {
          EasyLoading.showSuccess("success");
          //checking whether user exist in the db
          ap.checkExistingUser().then((value) async {
            if (value == true) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoScreen()),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserInfoScreen()),
                  (route) => false);
            }
          });
        });
  }
}
