import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/colors.dart';

import 'addProduct.dart'; // Adjust import path as needed

class addProductActionButton extends StatelessWidget {
  //const addProductActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        onPressed: ()  {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()), // Navigate to AddProduct widget
          );
      },
      backgroundColor: U_Colors.yaleBlue,
      child: Icon(Icons.add, color: U_Colors.whiteColor),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: U_Colors.whiteColor, width: 3),
        borderRadius: BorderRadius.circular(40),
      ),
    );
  }
}
