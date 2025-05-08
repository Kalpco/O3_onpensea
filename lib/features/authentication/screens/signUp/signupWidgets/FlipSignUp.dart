import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/images_path.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../login/login.dart';
import 'FlipSignUpForm.dart';

class FlipSignupScreen extends StatefulWidget {
  @override
  _FlipSignupScreenState createState() => _FlipSignupScreenState();
}

class _FlipSignupScreenState extends State<FlipSignupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  void _flipCard() {
    setState(() {
      if (isFront) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
      isFront = !isFront;
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFront() {
    return FlipSignupForm(
      title: "Email Signup",
      showEmail: true,
    );
  }

  Widget _buildBack() {
    return FlipSignupForm(
      title: "Mobile Signup",
      showEmail: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.off(() => LoginScreen());
          },
        ),
        title: Text(
          "Signup Here ",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: const Image(
                  height: 150,
                  image: AssetImage(U_ImagePath.kalpcoUpdatedLogo),
                  // width: 150,
                ),
              ),
              Center(
                child: Text(
                  U_TextStrings.signUpTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              SizedBox(height: 5,),
              ElevatedButton(
                onPressed: _flipCard,
                style: ElevatedButton.styleFrom(side: BorderSide(color: U_Colors.yaleBlue),backgroundColor: U_Colors.whiteColor,padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
                child: Text(isFront ? "Switch to Mobile Signup" : "Switch to Email Signup",style: TextStyle(color: U_Colors.yaleBlue),),
              ),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final angle = _animation.value;
                  final isUnder = angle > pi / 2;
        
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(angle),
                    child: SizedBox(
                      width: 500,
                      child: isUnder
                          ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: _buildBack(),
                      )
                          : _buildFront(),
                    ),
                  );
                },
              ),


            ],
          ),
        ),
      ),
    );
  }
}