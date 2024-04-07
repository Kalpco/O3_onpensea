import 'package:flutter/material.dart';

class RecommendedProduct {
  Color? cardBackgroundColor;
  Color? buttonTextColor;
  Color? buttonBackgroundColor;
  String? imagePath;
  String? title;

  RecommendedProduct({
    this.cardBackgroundColor,
    this.buttonTextColor = Colors.deepOrange,
    this.buttonBackgroundColor = Colors.white,
    this.imagePath,
    this.title,
  });
}
