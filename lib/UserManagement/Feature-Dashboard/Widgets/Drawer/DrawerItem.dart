import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerItem(this.text, this.icon, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(text,
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.displayLarge,
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
            )),
      ),
    );
  }
}
