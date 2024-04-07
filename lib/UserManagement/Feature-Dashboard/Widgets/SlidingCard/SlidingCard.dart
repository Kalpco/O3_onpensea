import "package:flutter/material.dart";

class SlidingCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color color;
  final String heading;
  final String description;

  const SlidingCard(
      this.title, this.imagePath, this.color, this.heading, this.description,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height / 4,
            width: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              color: Colors.black.withOpacity(0.5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // Align text to the left
                children: [
                  Text(
                    heading,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 8), // Add some spacing
                  Text(
                    description,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  SizedBox(height: 12), // Add some more spacing
                  ElevatedButton(
                    onPressed: () {
                      // Handle button click
                    },
                    child: Text('Buy'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
