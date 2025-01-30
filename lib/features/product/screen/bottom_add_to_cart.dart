import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/authentication/screens/login/login.dart';
import 'package:onpensea/features/authentication/screens/signUp/signup.dart';
import 'dart:convert';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:get/get.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import 'CheckoutScreen/CheckoutScreen.dart';

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
  late double _makingCharges;
  late double _goldAndDiamondPrice;
  late double _gstCharges;

  @override
  void initState() {
    super.initState();
    _totalPrice = (widget.product.productPrice ?? 0.0) * _quantity;
    _makingCharges = (widget.product.productMakingCharges ?? 0.0) * _quantity;
    _gstCharges = (widget.product.gstCharges ?? 0.0) * _quantity;
    _goldAndDiamondPrice = (widget.product.goldAndDiamondPrice ?? 0.0) * _quantity;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _totalPrice = (widget.product.productPrice ?? 0.0) * _quantity;
      _makingCharges = (widget.product.productMakingCharges ?? 0.0) * _quantity;
      _gstCharges = (widget.product.gstCharges ?? 0.0) * _quantity;
      _goldAndDiamondPrice = (widget.product.goldAndDiamondPrice ?? 0.0) * _quantity;
      print("increment price: $_totalPrice");
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _totalPrice = (widget.product.productPrice ?? 0.0) * _quantity;
        _makingCharges = (widget.product.productMakingCharges ?? 0.0) * _quantity;
        _gstCharges = (widget.product.gstCharges ?? 0.0) * _quantity;
        _goldAndDiamondPrice = (widget.product.goldAndDiamondPrice ?? 0.0) * _quantity;
        print("decrement price: $_totalPrice");
      });
    }
  }

  Future<void> _addToCart() async {
    int userId = loginController.userData['userId'];
    final url = '${ApiConstants.CART_BASE_URL}/$userId';

    String? firstImage = widget.product.productImageUri?[0];

    String isProductActive = ((widget.product.productIsActive == true) ? "Y" : "N");

print("first image: $firstImage");

    print("product quantity: $_quantity");
    print("product sum total: $_totalPrice");

    final cartData = {
      "id": widget.product.id,
      "productImageUri": firstImage,
      "productName": widget.product.productName,
      "productDescription": widget.product.productDescription,
      "productOwnerId":  widget.product.productOwnerId,
      "productOwnerName": widget.product.productOwnerName,
      "productCategory": widget.product.productCategory,
      "productSubCategory": widget.product.productSubCategory,
      "productSize": widget.product.productSize,
      "productWeight": widget.product.productWeight,
      "productPrice": widget.product.productPrice,
      "productQuantity": _quantity,
      "productIsActive": isProductActive,
      "productRating": widget.product.productRating,
      "productMakingCharges": _makingCharges,
      "productOwnerType": widget.product.productOwnerType,
      "gstCharges": _gstCharges,
      "purity": widget.product.purity,
      "totalPrice": _totalPrice,
      "goldPrice": widget.product.goldPrice,
      "goldAndDiamondPrice" : _goldAndDiamondPrice,
      "discountApplied":widget.product.discountApplied,
      "discountPercentage": widget.product.discountPercentage
      // "gemsDTO": {
      //   "noOfSmallStones": widget.product.gemsDTO?.noOfSmallStones!,
      //   "weightOfSmallStones":widget.product.gemsDTO?.weightOfSmallStones!,
      //   "priceOfSmallStones": widget.product.gemsDTO?.priceOfSmallStones!,
      //   "noOfSolitareDiamond": widget.product.gemsDTO?.noOfSolitareDiamond,
      //   "weightOfSolitareDiamond": widget.product.gemsDTO?.weightOfSolitareDiamond!,
      //   "priceOfSolitare": widget.product.gemsDTO?.priceOfSolitare!,
      //   "clarityOfSolitareDiamond": widget.product.gemsDTO?.clarityOfSolitareDiamond!,
      //   "typeOfStone": widget.product.gemsDTO?.typeOfStone!
      // }
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cartData),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
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
                onTap: () {
                  if (loginController.userData["userId"] != 0) {
                    _decrementQuantity();
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "Alert",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        content: Text(
                          "Please Register to purchase",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: Container(
                              color: const Color(0xffB80000),
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                "Go to Register",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(); // Close the dialog
                            },
                            child: Container(
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const U_CircularIcon(
                  icon: Iconsax.minus,
                  backgroundColor: U_Colors.satinSheenGold,
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
                onTap: () {
                  if (loginController.userData["userId"] != 0) {
                    _incrementQuantity();
                  } else {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(
                          "Alert",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        content: Text(
                          "Please Register to purchase",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUpScreen()),
                              );
                            },
                            child: Container(
                              color: const Color(0xffB80000),
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                "Go to Register",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop(); // Close the dialog
                            },
                            child: Container(
                              color: Colors.grey.shade300,
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                "Cancel",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const U_CircularIcon(
                  icon: Iconsax.add,
                  backgroundColor: U_Colors.yaleBlue,
                  width: 40,
                  height: 40,
                  color: U_Colors.whiteColor,
                  size: 25,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (loginController.userData['userId'] != 0) {
                _addToCart();
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      "Alert",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    content: Text(
                      "Please Register to purchase",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: Container(
                          color: const Color(0xffB80000),
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "Go to Register",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(); // Close the dialog
                        },
                        child: Container(
                          color: Colors.grey.shade300,
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(U_Sizes.md),
              backgroundColor: U_Colors.satinSheenGold,
              side: const BorderSide(color: U_Colors.black),
            ),
            child: const Text('Add to cart'),
          ),
          ElevatedButton(
            onPressed: () {
              if (loginController.userData['userId'] != 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutScreen(
                            product: widget.product,
                            quantity: _quantity,
                            makingCharges: _makingCharges,
                            gstCharges : _gstCharges,
                            goldAndDiamondPrice : _goldAndDiamondPrice,
                            totalPrice: _totalPrice,
                          )),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(
                      "Alert",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    content: Text(
                      "Please Register to purchase",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()),
                          );
                        },
                        child: Container(
                          color: const Color(0xffB80000),
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "Go to Register",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop(); // Close the dialog
                        },
                        child: Container(
                          color: Colors.grey.shade300,
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(U_Sizes.md),
              backgroundColor: U_Colors.yaleBlue,
              side: const BorderSide(color: U_Colors.black),
            ),
            child: const Text('Buy Now'),
          ),
          // SizedBox(
          //
          //   child: ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) =>
          //                 CheckoutScreen(product: widget.product)),
          //       );
          //     },
          //     child: const Text('Buy Now'),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: U_Colors.satinSheenGold,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
