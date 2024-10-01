import 'package:flutter/material.dart';
import 'package:onpensea/features/product/controller/goldApiIntegration.dart';
import 'package:onpensea/features/product/models/products.dart';

class ProductPriceExpandTile extends StatefulWidget {
   ProductPriceExpandTile({
    super.key,
    required this.product,
  });
  ProductResponseDTO product;

  

  @override
  State<ProductPriceExpandTile> createState() => _ProductPriceExpandTileState();
}

class _ProductPriceExpandTileState extends State<ProductPriceExpandTile> {


  //   @override
  // void initState() {
  //   super.initState();
  //   futureProducts = MetalRatesController().fetchMetalRates();
  // }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          SizedBox(height: 8),
          Text(
            'Price Break-up',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Gold'),
              Text('₹ ${widget.product.goldPrice!.toStringAsFixed(2)}'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Diamond'),
              Text(  '₹ ${((widget.product.gemsDTO?.priceOfSmallStones ?? 0) + (widget.product.gemsDTO?.priceOfSolitare ?? 0)).toStringAsFixed(2)}',
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Making Charge'),
              Text('₹ ${widget.product.productMakingCharges!.toStringAsFixed(2)}'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('GST'),
              Text('₹ ${widget.product.gstCharges!.toStringAsFixed(2)}'),
            ],
          ),
          SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹ ${widget.product.productPrice!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ])
        ],
      ),
    );
  }
}