import 'package:flutter/material.dart';

class DigigoldBuyInfo extends StatelessWidget {

  DigigoldBuyInfo({super.key, this.weightInMg, this.pricePerMgNoGst, this.pricePerMgWithGst});

  String? weightInMg;
  String? pricePerMgNoGst;
  String? pricePerMgWithGst;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            '$weightInMg mg',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Price ₹$pricePerMgNoGst/mg (excl. GST)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Text(
            '₹$pricePerMgWithGst/mg (with 3% GST)',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
