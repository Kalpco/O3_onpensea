import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:get/get.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';

class BottomAddToCart extends StatefulWidget {
  BottomAddToCart({super.key, required this.product});

  final ProductResponseDTO product;

  @override
  State<BottomAddToCart> createState() => _BottomAddToCartState();
}

class _BottomAddToCartState extends State<BottomAddToCart> {
  final loginController = Get.find<LoginController>();
  int _quantity = 1;
  late double _totalPrice;

  @override
  void initState() {
    super.initState();
    _totalPrice = (widget.product.productPrice ?? 0.0) * _quantity;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _totalPrice = (widget.product.productPrice ?? 0.0) * _quantity;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _totalPrice = (widget.product.productPrice ?? 0.0) * _quantity;
      });
    }
  }

  Future<void> _addToCart() async {
    int userId = loginController.userData['userId'];
    final url = 'http://103.108.12.222:11004/kalpco/carts/$userId';
    final cartData = {
      'cartId': userId.toString(),
      'items': [
        {
          'productId': widget.product.id,
          'image': widget.product.productImageUri?[0],  // Only the first image
          'description': widget.product.productDescription,
          'price': _totalPrice, // Use the updated total price
          'quantity': _quantity
        }
      ]
    };

    print('UserId: $userId');
    print('CartData: ${jsonEncode(cartData)}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cartData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item added to cart successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item to cart: ${response.body}'),
            backgroundColor: U_Colors.yaleBlue,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: U_Sizes.defaultSpace, vertical: U_Sizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? U_Colors.dark : U_Colors.light,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(U_Sizes.cardRadiusLg),
          topRight: Radius.circular(U_Sizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _decrementQuantity,
                child: const U_CircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: U_Colors.yaleBlue,
                  width: 40,
                  height: 40,
                  color: U_Colors.whiteColor,
                  size: 25,
                ),
              ),
              const SizedBox(width: U_Sizes.spaceBtwItems),
              Text('$_quantity', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(width: U_Sizes.spaceBtwItems),
              GestureDetector(
                onTap: _incrementQuantity,
                child: const U_CircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: U_Colors.satinSheenGold,
                  width: 40,
                  height: 40,
                  color: U_Colors.whiteColor,
                  size: 25,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _addToCart,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(U_Sizes.md),
              backgroundColor: U_Colors.yaleBlue,
              side: const BorderSide(color: U_Colors.black),
            ),
            child: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
