// lib/widgets/custom_floating_action_button.dart
import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/colors.dart'; // Adjust import path as needed

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomFloatingActionButton({required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: U_Colors.yaleBlue,
      child: Icon(Icons.phone, color: U_Colors.whiteColor),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: U_Colors.whiteColor, width: 3),
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
