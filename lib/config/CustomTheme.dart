import 'dart:ui';

import 'package:flutter/material.dart';

class CustomTheme {
  // static List<Color> colorsList = [
  //   Colors.orangeAccent,
  //   Colors.purpleAccent,
  //   Colors.white60,
  //   Colors.pink,
  //   Colors.pinkAccent,
  // ];

  static String logo = "assets/images/logoThree.gif";

  static Color primaryColor = const Color(0xff170034);
  static Color secondaryColor = const Color(0xff4A2F72);
  static Color ternaryColor = const Color(0xff9B1D6E);
  static Color fonaryColor = const Color(0xffB16092);
  static Color fifthColor = const Color(0xffAE0464);

  static List<double> stops = [0.05, 0.4, 0.6, 0.9, 1];

  static List<Color> colorsList = [
    primaryColor,
    secondaryColor,
    ternaryColor,
    fonaryColor,
    fifthColor
  ];

  static Color primaryColorForMovies = const Color(0xff170034);
  static Color secondaryColorForMovies = const Color(0xff4A2F72);
  static Color ternaryColorForMovies = const Color(0xff9B1D6E);
  static Color fonaryColorForMovies = const Color(0xffB16092);
  static Color fifthColorForMovies = const Color(0xffAE0464);

  static List<Color> colorsListForMovies = [
    Colors.blue,
    Colors.blue,
    Colors.blue,
    Colors.lightBlue,
    Colors.lightBlue,
  ];

  static List<Color> colorsListForGold = [
    const Color(0xffFFD700),
    const Color(0xffFFD700),
    const Color(0xffFFD700),
    const Color(0xffFFD700),
    const Color(0xffFFD700),
  ];

  static List<Color> colorsListForNft = [
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
  ];

  static LinearGradient customLinearGradientForMovies = LinearGradient(
    colors: CustomTheme.colorsListForMovies,
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: CustomTheme.stops,
  );

  static LinearGradient customLinearGradientForGold = LinearGradient(
    colors: CustomTheme.colorsListForGold,
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: CustomTheme.stops,
  );
  static LinearGradient customLinearGradientForNft = LinearGradient(
    colors: CustomTheme.colorsListForNft,
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: CustomTheme.stops,
  );


  static LinearGradient customLinearGradient = LinearGradient(
    colors: CustomTheme.colorsList,
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: CustomTheme.stops,
  );

//static var stops = [0.1, 0.4, 0.6, 0.9, 1];
}
