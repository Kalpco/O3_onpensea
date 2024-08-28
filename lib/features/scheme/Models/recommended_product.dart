

import 'package:flutter/material.dart';

class RecommendedProduct {
  Color? cardBackgroundColor;
  Color? buttonTextColor;
  Color? buttonBackgroundColor;
  String? imagePath;

  RecommendedProduct({
    this.cardBackgroundColor,
    this.buttonTextColor = Colors.deepOrange,
    this.buttonBackgroundColor = Colors.white,
    this.imagePath,
  });
}
