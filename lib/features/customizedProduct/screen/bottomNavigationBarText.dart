import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class Bottomnavigationbartext extends StatelessWidget {
  final String text;

  const Bottomnavigationbartext(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity, // Makes sure the text alignment works across full width
      color: U_Colors.satinSheenGold, // You can replace this with any color you like
      alignment: Alignment.center, // or centerRight, center, etc.
      padding: const EdgeInsets.symmetric(horizontal: 18), // Optional: adds space inside
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );

  }
}
