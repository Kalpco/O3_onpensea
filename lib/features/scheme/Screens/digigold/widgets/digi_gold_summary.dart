import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DigiGoldSummary extends StatelessWidget {

  const DigiGoldSummary({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "What's your gold Locker?",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[300],
              image: const DecorationImage(
                image: CachedNetworkImageProvider(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTluRrOgDV5xFTS0ylSXJHJgcTK1MkYow5MkA&s'),
                // Replace with your image asset
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.play_circle_fill,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Buy, sell and gift 99.99% pure gold on Google Pay securely",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Action for Buy Gold button
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Buy gold',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () {
              // Action for Learn more
            },
            child: Text(
              'Learn more',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
