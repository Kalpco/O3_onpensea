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

  final loginController = Get.put(LoginController());

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
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: U_Sizes.inputFieldSpaceBtw),
            TextFormField(
              controller: passController,
              obscureText: true, // Ensure password field is obscured
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: "Password",
                suffixIcon: Icon(Iconsax.eye_slash),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: U_Sizes.inputFieldSpaceBtw / 1),
            // const SizedBox(height: U_Sizes.inputFieldSpaceBtw / 1),
            //Remember me and forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Row(
                //   children: [
                //     Checkbox(
                //       value: true,
                //       onChanged: (value) {},
                //       activeColor: U_Colors.yaleBlue,
                //     ),
                //     const Text(U_TextStrings.rememberMe)
                //   ],
                // ),
                TextButton(
                  onPressed: () => Get.to(() => ForgotPasswordScreen()),
                  child: Text(U_TextStrings.forgotPassword),
                )
              ],
            ),
            // const SizedBox(height: U_Sizes.spaceBwtSections),
            // Sign-in
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
            // Create account
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const SignUpScreen()),
                child: Text(
                  U_TextStrings.createAccount,
                  style: TextStyle(color: U_Colors.whiteColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: U_Colors.yaleBlue,
                  side: BorderSide(color: U_Colors.satinSheenGold),
                ),
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: () => loginController.guestLogin(),
            //     child: Text(
            //       U_TextStrings.LoginGuest,
            //       style: TextStyle(color: U_Colors.yaleBlue),
            //     ),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: U_Colors.whiteColor,
            //       side: BorderSide(color: U_Colors.yaleBlue),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
