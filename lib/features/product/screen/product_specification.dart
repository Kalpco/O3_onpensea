import 'package:flutter/material.dart';

class ProductSpecification extends StatelessWidget {
   const ProductSpecification({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
     return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    Center(child: Text('Brand')),
                    Center(child: Text('Raj Jewels')),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Weight')),
                    Center(child: Text('54.50 g')),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Cell 5')),
                    Center(child: Text('Cell 6')),
                  ],
                ),
                TableRow(
                  children: [
                    Center(child: Text('Cell 7')),
                    Center(child: Text('Cell 8')),
                  ],
                ),
              ],
            ),
          );
        
  }

  
}