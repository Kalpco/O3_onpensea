import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'features/authentication/screens/login/Controller/LoginController.dart';
import 'features/product/controller/wishlistController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 // Import your update checker
//hacker

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/.env.production");
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  Get.put(WishlistController());
  Get.put(LoginController());
  runApp( App(isLoggedIn: isLoggedIn));
}

