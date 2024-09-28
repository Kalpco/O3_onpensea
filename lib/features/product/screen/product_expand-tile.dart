import 'package:flutter/material.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/utils/constants/colors.dart';

class ProductExpandTile extends StatelessWidget {
    ProductExpandTile({
    super.key,
    required this.product
  });

  ProductResponseDTO product;
  
  @override
  Widget build(BuildContext context) {
    return Container(
            margin: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
               borderRadius: BorderRadius.all(
                Radius.circular(10), // Adjust the radius as needed
              ),
            ),
            child: Column(
              children: [
                ExpansionTile(
                  backgroundColor: U_Colors.whiteColor,
                  title:Text('Product Specifications',style: Theme.of(context).textTheme.titleMedium,),

                  children: [
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Gold weight ',style: const TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text((product.productWeight?.toStringAsFixed(2) ?? 'NIL')+' gm')),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Gold Purity',style :const TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text((product.purity?.toString() ?? 'NA') + ' K',
                              )),
                            ),
                          ],
                        ),
                         TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Diamond Type',style :const TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text(product.gemsDTO?.typeOfStone ?? 'NA')),
                            ),
                          ],
                        ),

                        TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('No. of diamonds',style :const TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text(product.gemsDTO?.noOfSmallStones?.toString() ?? 'NA')),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Divider(),
                            Divider(),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Wt. of diamonds',style :const TextStyle(fontWeight: FontWeight.bold),)),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text((product.gemsDTO?.weightOfSmallStones?.toStringAsFixed(2) ?? 'NA') + ' ct')),
                            ),
                          ],
                        ),
                        // TableRow(
                        //   children: [
                        //     Divider(),
                        //     Divider(),
                        //   ],
                        // ),
                        // TableRow(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: Center(child: Text('No. of solitare',style :const TextStyle(fontWeight: FontWeight.bold),)),
                        //     ),
                        //     Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: Center(child: Text(product.gemsDTO?.noOfSolitareDiamond?.toString() ?? 'NA')),
                        //     ),
                        //   ],
                        // ),
                        // TableRow(
                        //   children: [
                        //     Divider(),
                        //     Divider(),
                        //   ],
                        // ),
                        // TableRow(
                        //   children: [
                        //     Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: Center(child: Text('Wt. of Solitare',style :const TextStyle(fontWeight: FontWeight.bold),)),
                        //     ),
                        //     Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: Center(child: Text((product.gemsDTO?.weightOfSolitareDiamond?.toString() ?? 'NA') + ' ct')),
                        //     ),
                        //   ],
                        // ),

                      ],
                    ),
                  ],
                ),
               

              ],
            ),
            
          );
  }
}