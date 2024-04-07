import "package:flutter/material.dart";

import "package:google_fonts/google_fonts.dart";

class NeumorphicCategoryItem extends StatelessWidget {
  final String name;
  final String imageAsset;

  const NeumorphicCategoryItem(this.name, this.imageAsset, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /* Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CityDetailsPage(name),
          ),
        );*/
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: GoogleFonts.poppins(
                textStyle: Theme.of(context).textTheme.labelLarge,
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
