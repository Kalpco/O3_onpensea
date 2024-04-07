import "package:flutter/material.dart";

import "../../Widgets/SlidingCard/SlidingCard.dart";

class SlidingCardWidgetState extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);

  SlidingCardWidgetState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 200,
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          children: const [
            SlidingCard('Card 1', 'assets/images/1.png', Colors.white,
                'Delhi Properties', 'one if the best properties You will find it here'),
            SlidingCard('Card 2', 'assets/images/3.png', Colors.white,
                'Mumbai Propeties', 'one if the best properties You will find it here'),
            SlidingCard('Card 3', 'assets/images/5.png', Colors.white,
                'New Properties', 'new properties you will find it here'),
          ],
        ),
      ),
    );
  }
}
