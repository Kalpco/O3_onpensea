import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CarouselWithPictures extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/images/12.png',
    'assets/images/11.png',
    'assets/images/10.png',
    'assets/images/8.png',
  ];

  final List<String> placeNames = [
    'Delhiiiiiiiiiiii',
    'Mumbai',
    'Pune',
    'London',
  ];

  CarouselWithPictures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250.0,
        width: 350.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 1.0,
              offset: Offset(1.0, 1.0),
              spreadRadius: 0.0,
            ),
            BoxShadow(
              color: Colors.white,
              blurRadius: 10.0,
              offset: Offset(-4.0, -4.0),
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: PageView.builder(
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {

                switch (index) {
                  case 0:

                    break;
                  case 1:

                    break;
                  case 2:

                  case 3:

                    break;
                  default:
                    break;
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: AssetImage(imagePaths[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text(
                    placeNames[index],
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

