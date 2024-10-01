import 'package:flutter/material.dart';

class ProductQuantityWithButton extends StatelessWidget {
  final int quantity;

  const ProductQuantityWithButton({Key? key, required this.quantity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Displaying Quantity: $quantity');
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.remove)),
        Text('$quantity'),
        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
      ],
    );
  }
}
