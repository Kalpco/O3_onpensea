import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../UserManagement/Feature-ApplyForTokens/Models/Properties.dart';
import '../../../../config/CustomTheme.dart';
import '../../../../widgets/CustomButton.dart';
import 'FormTwo.dart';

class FormOne extends StatefulWidget {
  final Properties props;

  const FormOne({Key? key, required this.props}) : super(key: key);

  @override
  State<FormOne> createState() => _FormOneScreen();
}

class _FormOneScreen extends State<FormOne> {
  final propertyNameController = TextEditingController();
  final propIdController = TextEditingController();
  final propertyOwnerName = TextEditingController();
  final tokenNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    propertyNameController..text = widget.props.propName;
    propIdController..text = widget.props.id;
    propertyOwnerName..text = widget.props.ownerName;
    tokenNameController..text = widget.props.tokenName;
  }

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
              margin: const EdgeInsets.only(top: 0),
              child: Column(children: [
                labelText(label: "Property Name"),
                textField(
                    hintText: "Enter Property Name",
                    icon: Icons.account_circle,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: propertyNameController),
                labelText(label: "Property Id"),
                textField(
                    hintText: "Property Id",
                    icon: Icons.abc,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: propIdController),
                labelText(label: "Property Owner Name"),
                textField(
                    hintText: "Property Owner Name",
                    icon: Icons.edit,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: propertyOwnerName),
                labelText(label: "Token Name"),
                textField(
                    hintText: "Token Name",
                    icon: Icons.edit,
                    inputType: TextInputType.name,
                    maxLines: 1,
                    controller: tokenNameController),
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
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        child: CustomButton(
                          text: "Exit",
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
                            if (_formKey.currentState!.validate()) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormTwo(
                                        props: widget.props,
                                        propertyOwnerName:
                                            widget.props.ownerName,
                                        propId: widget.props.id,
                                        propertyName: widget.props.propName,
                                        tokenName: widget.props.tokenName)),
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
