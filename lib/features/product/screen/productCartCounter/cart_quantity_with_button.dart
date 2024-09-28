import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ProductQuantityWithButton extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ProductQuantityWithButton({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Iconsax.minus),
          onPressed: onDecrement,
        ),
        Text('$quantity', style: Theme.of(context).textTheme.bodyLarge),
        IconButton(
          icon: Icon(Iconsax.add),
          onPressed: onIncrement,
        ),
      ],
    );
  }
}