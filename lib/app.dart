import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:onpensea/features/authentication/screens/onBoardingScreens/onboarding.dart';
import 'package:onpensea/features/scheme/Screens/digigold/screens/digigold_main.dart';
import 'package:onpensea/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'features/scheme/Screens/digigold/screens/digigold_buy_sell_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: T_AppTheme.lightTheme,
      darkTheme: T_AppTheme.darkTheme,
      home: const LoginScreen(),
    );
  }
}
