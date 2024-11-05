import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/Home/Screens/HomeScreen.dart';

import '../../../../../utils/constants/colors.dart';

class DigiGoldCustomAppBar extends StatelessWidget {
  final String? goldPrice;
  final String? mgOfGoldUserHas;
  final bool? isTransactionDataAvailable;

  const DigiGoldCustomAppBar(
      {super.key,
      this.goldPrice,
      this.mgOfGoldUserHas,
      this.isTransactionDataAvailable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8_KuUq4ay88xl_WuU2_6NGteuytEmxrGS0w&s',
                ),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  U_Colors.yaleBlue, // Apply a red overlay to blend with the image
                  BlendMode.srcATop,
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.off(() => HomeScreen());
                      },
                    ),
                    const SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://cdn.logojoy.com/wp-content/uploads/2018/08/30154327/163.png",
                        fit: BoxFit.fill,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Gold Vault',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'balance: ${mgOfGoldUserHas ?? "0"} mg',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.more_vert, color: Colors.white),
              ],
            ),
          ),
          Positioned(
            top: 120,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      goldPrice != null ? "₹$goldPrice/mg" : "Loading...",
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      goldPrice != null
                          ? "Current gold buying price\n(inclusive of taxes)"
                          : "Fetching gold account details",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
