import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/utils/theme/theme.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:upgrader/upgrader.dart';
import 'features/authentication/screens/login/login.dart';
import 'navigation_menu.dart'; // Import your update checker


class App extends StatefulWidget {
  final bool isLoggedIn;
  const App({super.key, required this.isLoggedIn});

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    _secureScreen();
  }

  Future<void> _secureScreen() async {
    try {
      await ScreenProtector.preventScreenshotOn();
    } catch (e) {
      print('Error preventing screenshot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: T_AppTheme.lightTheme,
      home: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.material,
        // Use the material dialog style
        showIgnore: true,
        // Enable the "Ignore" button so we can rename it to "Cancel"
        showLater: false,
        // Disable the "Later" button

        // Prevents dismissing the dialog by tapping outside
        showReleaseNotes: false,
        upgrader: Upgrader(
          // Hide release notes if you don't want them
          debugDisplayAlways: true,
          durationUntilAlertAgain: Duration(seconds: 0),
          messages: MyCustomUpgraderMessages(), // Custom messages
        ),
        child: widget.isLoggedIn ? const NavigationMenu() : const LoginScreen(),
      ),
    );
  }
}

class MyCustomUpgraderMessages extends UpgraderMessages {
  @override
  String get buttonTitleUpdate {
    return 'Update Now';
  }

  @override
  String get buttonTitleIgnore {
    return 'Cancel'; // Change the text for the "Ignore" button to "Cancel"
  }

  @override
  String get buttonTitleLater {
    return ''; // Return an empty string to hide the "Later" button
  }
}
