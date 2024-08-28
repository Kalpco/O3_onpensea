import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/commons/styles/custom_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color backgroundColor;
  final List<Widget> actions;

  const CustomAppBar(
      {super.key,
      required this.title,
      required this.backgroundColor,
      required this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: actions[0],
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      backgroundColor: backgroundColor,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(45);
}
