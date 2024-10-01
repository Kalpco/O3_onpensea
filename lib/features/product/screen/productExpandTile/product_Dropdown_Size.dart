import 'package:flutter/material.dart';

class ProductSizeDropdown extends StatefulWidget {
  const ProductSizeDropdown({super.key});

  @override
  State<ProductSizeDropdown> createState() => _ProductSizeDropdown();
}

class _ProductSizeDropdown extends State<ProductSizeDropdown> {
  String selectPurity = 'Select Purity'; 
  List<String> purity = ['Select Purity', '22 KT', '24 KT'];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectPurity,
        onChanged: (String? newValue) {
          setState(() {
            selectPurity = newValue!;
          });
        },
        items: purity.map<DropdownMenuItem<String>>((String size) {
          return DropdownMenuItem<String>(
            value: size,
            child: Text(size),
          );
        }).toList(),
        underline: SizedBox(),
      ),
    );
  }
}
