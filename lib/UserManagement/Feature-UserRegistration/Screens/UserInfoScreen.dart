import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/UserManagement/Feature-UserLogin/Screens/login_screen.dart';
import 'package:onpensea/UserManagement/Feature-UserRegistration/Screens/OtpScreen2.dart';
import 'package:provider/provider.dart';

import '../../../config/CustomTheme.dart';
import '../../../provider/AuthProvider.dart';
import '../../../utils/utils.dart';
import '../../../widgets/CustomButton.dart';

const List<String> list = <String>[
  'Select your gender',
  'Male',
  'Female',
  'Transgender'
];

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UserInfoScreen> createState() => _UserInfoScreen();
}

class _UserInfoScreen extends State<UserInfoScreen> {
  File? image;

  final nameController = TextEditingController();
  final fatherNameController = TextEditingController();
  final genederController = TextEditingController();

  String dropdownValue = list.first;

  final apiUrl = "http://45.118.162.234:11000/user/register";

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    fatherNameController.dispose();
    genederController.dispose();
  }

  //for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isSavedInDb;

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
          nameControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          fatherNameControllerTextField(size),
          SizedBox(
            height: size.height * 0.02,
          ),
          genderControllerTextField(size),
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
                  text: "Exit",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
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
                    String name = nameController.text ?? '';
                    String fatherName = fatherNameController.text ?? '';
                    String gender = genederController.text ?? '';

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen2(
                          name: name,
                          fatherName: fatherName,
                          gender: gender,
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

  Widget nameControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: nameController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Enter your Full Name',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: nameController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: nameController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.verified_user,
              color: nameController.text.isEmpty
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
              child: nameController.text.isEmpty
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

  Widget fatherNameControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: size.height / 12,
        child: TextField(
          controller: fatherNameController,
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: const Color(0xFF151624),
          ),
          cursorColor: const Color(0xFF151624),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Enter your Father Name',
            hintStyle: GoogleFonts.inter(
              fontSize: 16.0,
              color: const Color(0xFF151624).withOpacity(0.5),
            ),
            filled: true,
            fillColor: fatherNameController.text.isEmpty
                ? const Color.fromRGBO(248, 247, 251, 1)
                : Colors.transparent,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: BorderSide(
                  color: fatherNameController.text.isEmpty
                      ? Colors.transparent
                      : const Color.fromRGBO(255, 102, 190, 1),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(255, 102, 190, 1),
                )),
            prefixIcon: Icon(
              Icons.abc_sharp,
              color: fatherNameController.text.isEmpty
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
              child: fatherNameController.text.isEmpty
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

  Widget genderControllerTextField(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: SizedBox(
        width: double.infinity,
        height: size.height / 12,
        child: DropdownButton<String>(
          isExpanded: true,
          value: dropdownValue,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.pinkAccent),
          underline: Container(
            height: 1,
            color: Colors.deepPurpleAccent,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
              genederController.text = value!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }
}
