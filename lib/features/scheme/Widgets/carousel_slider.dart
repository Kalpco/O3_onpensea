import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/commons/config/api_constants.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    super.key,
    required this.items,
  });

  final List<String> items;

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    String? bytesList;

    return Column(
      children: [
        SizedBox(
          height: height * 0.35,
          child: PageView.builder(
            itemCount: widget.items.length,
            onPageChanged: (int currentIndex) {
              newIndex = currentIndex;
              setState(() {});
            },
            itemBuilder: (_, index) {
              return FittedBox(
                  fit: BoxFit.contain,
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl:
                        "${ApiConstants.INVESTMENTMS_URL}${widget.items[index]}",
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(color: Colors.grey,),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ));
            },
          ),
        ),
        AnimatedSmoothIndicator(
          effect: const WormEffect(
              //
              ),
          count: widget.items.length,
          activeIndex: newIndex,
        )
      ],
    );
  }
}
