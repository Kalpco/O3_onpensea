import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/enums.dart';

class ProductBrandTitleText extends StatelessWidget {
  const ProductBrandTitleText({
    super.key,
    this.color,
    this.maxLines = 1,
    required this.title,
    this.textAlign = TextAlign.center,
    this.brandTextSize = textSizes.small,

  });
  final Color?color;
  final String title;
  final int maxLines;
  final TextAlign ? textAlign;
  final textSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: brandTextSize == textSizes.small
          ? Theme.of(context).textTheme.titleMedium!.apply(color: color)
          : brandTextSize == textSizes.medium
          ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
          : brandTextSize == textSizes.large
          ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
          :Theme.of(context).textTheme.titleLarge!.apply(color: color) ,
    );
  }
}