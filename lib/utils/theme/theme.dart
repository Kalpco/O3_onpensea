import 'package:onpensea/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:onpensea/utils/theme/custom_themes/bottom_sheet_theme.dart';
import 'package:onpensea/utils/theme/custom_themes/checkboxx_theme.dart';
import 'package:onpensea/utils/theme/custom_themes/elevated_button_theme.dart';
import 'package:onpensea/utils/theme/custom_themes/outline_button_theme.dart';
import 'package:onpensea/utils/theme/custom_themes/text_field_theme.dart';
import 'package:onpensea/utils/theme/custom_themes/text_theme.dart';
import 'package:flutter/material.dart';

import 'custom_themes/chip_theme.dart';

class T_AppTheme {
  T_AppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: T_TextTheme.lightTextTheme,
      elevatedButtonTheme: T_ElevatedButtonTheme.lightElebvatedBttonTheme,
      chipTheme: T_ChipTheme.lightchipTheme,
      appBarTheme: T_AppBarTheme.lightAppBarTheme,
      checkboxTheme: T_CheckBoxTheme.lightCheckBoxTheme,
      bottomSheetTheme: T_BottomSheetTheme.lightBottomSheetTheme,
      outlinedButtonTheme: T_OutlineButtonTheme.lightOutlineButtonTheme,
      inputDecorationTheme: T_TextFieldTheme.lightInputDecorationTheme);

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      textTheme: T_TextTheme.darkTextTheme,
      elevatedButtonTheme: T_ElevatedButtonTheme.darktElebvatedBttonTheme,
      chipTheme: T_ChipTheme.darkchipTheme,
      appBarTheme: T_AppBarTheme.darkAppBarTheme,
      checkboxTheme: T_CheckBoxTheme.darkCheckBoxTheme,
      bottomSheetTheme: T_BottomSheetTheme.darkBottomSheetTheme,
      outlinedButtonTheme: T_OutlineButtonTheme.darkOutlineButtonTheme,
      inputDecorationTheme: T_TextFieldTheme.darkInputDecorationTheme);
}
