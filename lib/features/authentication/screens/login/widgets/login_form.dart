import 'package:onpensea/commons/styles/spacing_style.dart';
import 'package:onpensea/features/authentication/screens/forgot_password/forgot_password_screen.dart';
import 'package:onpensea/features/authentication/screens/password_configuration/forgot_password.dart';
import 'package:onpensea/features/authentication/screens/signUp/signup.dart';
import 'package:onpensea/navigation_menu.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../signUp/signupWidgets/FlipSignUp.dart';
import '../Controller/LoginController.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  bool _isPasswordVisible = false; // Add this state variable to toggle password visibility

  final loginController = Get.find<LoginController>();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    _isLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: U_Sizes.spaceBwtSections),
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: U_TextStrings.email,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email/mobile';
                }
                return null;
              },
            ),
            const SizedBox(height: U_Sizes.inputFieldSpaceBtw),
            TextFormField(
              controller: passController,
              obscureText: !_isPasswordVisible, // Use the state variable to toggle visibility
              decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash, // Toggle icon based on state
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible; // Toggle visibility
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: U_Sizes.inputFieldSpaceBtw),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Get.to(() => ForgotPasswordScreen()),
                  child: Text(U_TextStrings.forgotPassword),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _isLoading.value = true;
                    try {
                      String email = emailController.text;
                      String password = passController.text;

                      bool success =
                      await LoginController.verifyUserCredentials(
                          email, password);

                      if (success) {
                        await saveLoginStatus();
                        Get.to(() => NavigationMenu());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Invalid email or password')),
                        );
                      }
                    } catch (e) {
                      print('Error during sign in: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('An error occurred during sign in')),
                      );
                    } finally {
                      _isLoading.value = false;
                    }
                  }
                },
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isLoading,
                  builder: (context, isLoading, child) {
                    if (isLoading) {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      );
                    } else {
                      return Text(
                        U_TextStrings.signIn,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: U_Colors.satinSheenGold,
                    side: BorderSide(color: U_Colors.satinSheenGold)),
              ),
            ),
            const SizedBox(height: U_Sizes.spaceBwtSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.off(() =>   FlipSignupScreen()),//
                child: Text(
                  U_TextStrings.createAccount,
                  style: TextStyle(color: U_Colors.whiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: U_Colors.yaleBlue,
                  side: BorderSide(color: U_Colors.yaleBlue),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                onPressed: loginController.isLoading.value ? null : () => loginController.guestLogin(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: U_Colors.whiteColor,
                  side: const BorderSide(color: U_Colors.yaleBlue),
                ),
                child: loginController.isLoading.value
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(U_Colors.yaleBlue),
                  ),
                )
                    : const Text(
                  U_TextStrings.LoginGuest,
                  style: TextStyle(color: U_Colors.yaleBlue),
                ),
              )),
            )

          ],
        ),
      ),
    );
  }

  Future<void> saveLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}

