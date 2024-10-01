import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/appBar.dart';
import 'package:onpensea/utils/constants/sizes.dart';

class ProductList extends StatelessWidget{
  const ProductList({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: U_AppBar(title: Text('Product List'),showBackArrow: true, actions: [],),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(U_Sizes.defaultSpace),
          child: Column(
            children: [
              
            ],
          ),
        ),
      ),
    );
  }
  
}