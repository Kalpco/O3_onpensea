import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SquareContainer extends StatelessWidget {
  final IconData iconData;
  final String imagePath;

  const SquareContainer(this.iconData, this.imagePath, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius:
            BorderRadius.circular(20.0), // Adjust the border radius as needed
      ),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Icon(
            iconData,
            size: 48, // Adjust the size of the icon as needed
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
