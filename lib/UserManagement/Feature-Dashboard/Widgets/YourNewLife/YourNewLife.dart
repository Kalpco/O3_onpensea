import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

import "../../../../GoldTokens/Screens/all_gold_screen.dart";
import "../../../../Nfts/Screens/all_nfts_screen.dart";
import "../../../../Property/Feature-ShowAllDetails/Screens/ShowAllVerifiedProperties.dart";
import "../../../../movies/Screens/all_movie_screen.dart";
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
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowAllVerifiedProperties(screenStatus: 'buy',)),
                  );
                },
                child: SquareContainer(Icons.add_circle, 'assets/images/11.png'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllGoldScreen(screenStatus: '',)),
                  );
                },
                child: SquareContainer(Icons.add_circle, 'assets/images/metals/diamond.jpg'),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllMovieScreen(screenStatus: '',)),
                  );
                },
                child: SquareContainer(Icons.add_circle, 'assets/images/movies/cinema.jpg'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AllNftScreen(screenStatus: '',)),
                  );
                },
                child: SquareContainer(Icons.add_circle, 'assets/images/nfts/NFT.jpg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
