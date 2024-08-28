import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/authentication/screens/login/login.dart';

import '../../../../utils/constants/colors.dart';

class SuccessForgotPasswordScreen extends StatelessWidget {
  const SuccessForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Text(
              'PASSWORD\n   UPDATED',
              style: GoogleFonts.poppins(
                fontSize: 40,
                color: U_Colors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: U_Colors.green,
            ),
            SizedBox(height: 30),
            Text(
              'Your password has been updated!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide.none,
                  backgroundColor: U_Colors.yaleBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'LOGIN',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: U_Colors.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
