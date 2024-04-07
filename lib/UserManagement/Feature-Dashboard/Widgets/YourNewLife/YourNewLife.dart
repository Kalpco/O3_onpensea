import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../../Widgets/YourNewLife/SquareContainer.dart";

class YourNewLife extends StatelessWidget {
  const YourNewLife({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.0,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Explore Gold-Movies-NFTS",
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.labelLarge,
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.normal,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SquareContainer(Icons.add_circle, 'assets/images/metals/copper.jpg'),
              SquareContainer(Icons.add_circle, 'assets/images/metals/diamond.jpg'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SquareContainer(Icons.add_circle, 'assets/images/nfts/monkey.webp'),
              SquareContainer(
                Icons.add_circle,
                'assets/images/movies/animal.jpg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
