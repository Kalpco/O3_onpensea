import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/Admin/Feature-VerifyBuy/Widgets/carousel_slider.dart';
import 'package:carousel_slider/carousel_slider.dart' as Cslider;
import 'package:onpensea/Token/Model/TokenPriceModel.dart';
import 'package:onpensea/Token/Widgets/token_cards_widget/single_card.dart';

class CarouselTokenCard extends StatefulWidget {
  final Future<List<TokenPriceModel>> props;

  const CarouselTokenCard({required this.props, super.key});

  @override
  State<CarouselTokenCard> createState() => _CarouselTokenCardState();
}

class _CarouselTokenCardState extends State<CarouselTokenCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TokenPriceModel>>(
        future: widget.props!,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasData) {
            final tokens = snapshot.data!;
            return horizontalSummary(tokens);
          } else {
            return const Text("No data available");
          }
        });
  }

  Widget horizontalSummary(List<TokenPriceModel> tokens) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: tokens.length,
        itemBuilder: (context, index) {
          final token = tokens[index];
          return SingleCard(
              textHeading: token.tokenName,
              textDetails: "${token.price}",
              extraDetails: "+124.55(0.58%)");
        },
      ),
    );
  }
}
