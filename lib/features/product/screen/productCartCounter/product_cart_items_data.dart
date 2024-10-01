import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCartItems extends StatelessWidget {
  final String image;
  final String description;
  final int purity;

  const ProductCartItems({required this.image, required this.description,required this.purity, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    print("description: $description");
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: Colors.red, size: 50);
              },
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Purity : ${purity.toString()}',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

      ],
    );
  }
}