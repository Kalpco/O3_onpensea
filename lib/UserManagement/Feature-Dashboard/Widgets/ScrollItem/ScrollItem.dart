import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../../Widgets/NeumorphicCategoryItem/NeumorphicCategoryItem.dart";

class ScrollItem extends StatelessWidget {
  const ScrollItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Our Cities',
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.labelLarge,
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            height: 250,
            child: ListView(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.horizontal,
              children: const [
                NeumorphicCategoryItem("Mumbai", "assets/MumbaiRent1.jpg"),
                SizedBox(
                  width: 20,
                ),
                NeumorphicCategoryItem("Delhi", "assets/DelhiRent2.jpg"),
                SizedBox(
                  width: 20,
                ),
                NeumorphicCategoryItem("London", "assets/Lon1.jpg"),
                SizedBox(
                  width: 20,
                ),
                NeumorphicCategoryItem("NewYork", "assets/Newyork1.jpg"),
                SizedBox(
                  width: 20,
                ),
                NeumorphicCategoryItem("Pune", "assets/Punele.jpg"),
                SizedBox(
                  width: 20,
                ),
                // NeumorphicCategoryItem("Home", "assets/home.jpg"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
