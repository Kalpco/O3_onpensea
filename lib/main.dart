import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app.dart';
import 'features/product/controller/wishlistController.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
 // Import your update checker
//hacker

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/.env.production");

  Get.put(WishlistController());

  runApp(const App());
}

