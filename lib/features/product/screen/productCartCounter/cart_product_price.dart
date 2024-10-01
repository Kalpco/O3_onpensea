import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartProductPrice extends StatelessWidget {
  const CartProductPrice({
    super.key,
    this.currencySign = '₹',
    required this.price,
    this.isLarge = false,
    this.maxLines = 1,
    this.lineThrough = false,
    this.decimalPlaces = 2,
  });

  final double price;
  final String currencySign;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;
  final int decimalPlaces;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$currencySign${price.toStringAsFixed(decimalPlaces)}',
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.headlineMedium!.apply(
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      )
          : Theme.of(context).textTheme.titleLarge!.apply(
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }
}