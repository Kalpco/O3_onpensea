import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DigiGoldCustomAppBar extends StatelessWidget {
  const DigiGoldCustomAppBar({super.key, this.isTransactionDataAvailable});

  final bool? isTransactionDataAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: 300, // Set height as per the design
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8_KuUq4ay88xl_WuU2_6NGteuytEmxrGS0w&s', // Replace with your image URL
              ),
              fit: BoxFit.cover,
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
                      print("out");
                      //Navigator.pop(context);
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
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
                  const SizedBox(
                    width: 20,
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Gold Locker',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '12.7 mg',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
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
                      isTransactionDataAvailable! ? "₹7.32/mg" : "_",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      isTransactionDataAvailable!
                          ? "Current gold buying price\n(inclusive of taxes)"
                          : "FSetching gold account details",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                )
              ],
            ))
      ],
    ));
  }
}
