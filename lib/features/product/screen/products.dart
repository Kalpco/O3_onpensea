import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onpensea/features/product/apiService/productService.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';
import 'package:onpensea/features/product/models/products.dart';

import 'package:onpensea/utils/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<ProductWrapperResponseDTO> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
      ),
      body: FutureBuilder<ProductWrapperResponseDTO>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }  else {
             final products = snapshot.data!.productListResponseDTO;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        "http://45.118.162.234:11003/kalpco/v0.01${product.productImageUri![0]}",
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(product.productName!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(product.productDescription!),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Weight: ${product.productWeight}g'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Price: \₹${product.productPrice}'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  
  
}
