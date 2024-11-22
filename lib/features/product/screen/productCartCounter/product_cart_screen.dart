import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/product/screen/productCartCounter/product_cart_checkout.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/cart_top_app_bar.dart';
import 'dart:convert';
import 'package:onpensea/commons/config/api_constants.dart' as API_CONSTANTS_1;
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/api_constants.dart';
import '../../../Home/widgets/DividerWithAvatar.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../../authentication/screens/login/login.dart';

import 'cart_product_price.dart';
import 'cart_quantity_with_button.dart';
import 'product_cart_items_data.dart';

class ProductCartScreen extends StatefulWidget {
  const ProductCartScreen({super.key});

  @override
  _ProductCartScreenState createState() => _ProductCartScreenState();
}

class _ProductCartScreenState extends State<ProductCartScreen> {
  final loginController = Get.find<LoginController>();
  List<dynamic>? cartData;
  bool isLoading = true;
  bool isUpdatingCart = false; // New loading state for cart updates

  @override
  void initState() {
    super.initState();
    fetchCartData();

  }

  Future<void> fetchCartData() async {
    var userId = loginController.userData['userId'];
    final url = Uri.parse('${API_CONSTANTS_1.ApiConstants.CART_BASE_URL}/$userId');
    print("url:  $url");
    try {
      final response = await http.get(url);

      print("end: ${response.body}");
      print("response: ${response.statusCode}");

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['payload'] is List) { // Check if payload is a list
          setState(() {
            cartData = decodedResponse['payload'];
            isLoading = false;
          });
        } else {
          print('Payload is not a list');
          setState(() {
            cartData = []; // Set to empty list if payload is not a valid list
            isLoading = false;
          });
        }
      } else {
        print('Failed to load cart data');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Fetching cart data Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Future<void> fetchCartData() async {
  //   var userId = loginController.userData['userId'];
  //   final url = Uri.parse('${API_CONSTANTS_1.ApiConstants.CART_BASE_URL}/$userId');
  //   print("url:  $url");
  //   try {
  //     final response = await http.get(url);
  //
  //     print("end: ${response.body}");
  //     print("response: ${response.statusCode}");
  //
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         cartData = json.decode(response.body)['payload'];
  //         print("payload: ${cartData?[0]}");
  //         print("payload: ${cartData?[1]}");
  //         isLoading = false;
  //       });
  //     } else {
  //       print('Failed to load cart data');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Fetching cart data Error: $e');
  //   }
  // }


  Future<void> updateCartItemQuantity(String userId, String productId, int newQuantity, double unitPrice) async {
    setState(() {
      isUpdatingCart = true;  // Show loader
    });

    final url = Uri.parse('${API_CONSTANTS_1.ApiConstants.CART_BASE_URL}/$userId/cart/$productId/quantity/$newQuantity');
    final newPrice = unitPrice * newQuantity;

    print("url: $url");

    final updatedCart = cartData!.map((item) {
      if (item['id'] == productId) {
        return {
          ...item,
          'productPrice': newPrice,
          'productQuantity': newQuantity,
        };
      }
      return item;
    }).toList();

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'items': updatedCart}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          cartData = updatedCart;
        });
        fetchCartData(); // Fetch updated data after success
      } else {
        print('Failed to update cart: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isUpdatingCart = false;  // Hide loader
      });
    }
  }

  Future<void> deleteCartItem(String userId, String productId) async {
    final url = Uri.parse('${API_CONSTANTS_1.ApiConstants.CART_BASE_URL}/user/$userId/cart/$productId');
    final updatedCart =
    cartData!.where((item) => item['id'] != productId).toList();

    print('Deleting item from cart: $updatedCart'); // Debugging statement

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'items': updatedCart}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Item deleted successfully');
        setState(() {
          cartData = updatedCart;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item deleted from cart'),backgroundColor: Colors.red,),
        );
      } else {
        print(
            'Failed to delete item: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Delete Error: $e');
    }
  }

  double calculateTotalPrice() {
    if (cartData == null) return 0.0;
    return cartData!
        .fold(0.0, (sum, item) => sum + (item['totalPrice'] ?? 0.0));
  }


  @override
  Widget build(BuildContext context) {
    String deliverable = loginController.userData['isDeliverable'] ?? 'N';
    return Stack(
      children: [
        CartTopAppBar(
          body: Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: (cartData == null || cartData!.isEmpty) ? null : () {
                  if (loginController.userData["userId"] == 0) {
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
                          "Please login to purchase",
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
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Container(
                              color: const Color(0xffB80000),
                              padding: const EdgeInsets.all(14),
                              child: Text(
                                "Go to login",
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
                  } else {
                    if (deliverable == 'Y') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductCartCheckout(
                            cartData: cartData,
                            finalPrice: calculateTotalPrice(),
                          ),
                        ),
                      );
                    } else {
                      _showAlertDialog();
                    }
                  }
                },
                child: Text(
                  (cartData == null || cartData!.isEmpty) ? 'Cart empty' : 'Checkout \₹ ${calculateTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white, // Text color based on cart state
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: (cartData == null || cartData!.isEmpty)
                      ? U_Colors.satinSheenGold
                      : U_Colors.yaleBlue,
                ),
              ),
            ),

            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: ElevatedButton(
            //     onPressed: () {
            //       if (loginController.userData["userId"] == 0) {
            //         showDialog(
            //           context: context,
            //           builder: (ctx) => AlertDialog(
            //             title: Text(
            //               "Alert",
            //               style: GoogleFonts.poppins(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.w700,
            //                 color: Colors.grey.shade800,
            //               ),
            //             ),
            //             content: Text(
            //               "Please login to purchase",
            //               style: GoogleFonts.poppins(
            //                 fontSize: 16,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.grey.shade800,
            //               ),
            //             ),
            //             actions: <Widget>[
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.push(
            //                     context,
            //                     MaterialPageRoute(builder: (context) => const LoginScreen()),
            //                   );
            //                 },
            //                 child: Container(
            //                   color: const Color(0xffB80000),
            //                   padding: const EdgeInsets.all(14),
            //                   child: Text(
            //                     "Go to login",
            //                     style: GoogleFonts.poppins(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w700,
            //                       color: Colors.white,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               TextButton(
            //                 onPressed: () {
            //                   Navigator.of(ctx).pop(); // Close the dialog
            //                 },
            //                 child: Container(
            //                   color: Colors.grey.shade300,
            //                   padding: const EdgeInsets.all(14),
            //                   child: Text(
            //                     "Cancel",
            //                     style: GoogleFonts.poppins(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w700,
            //                       color: Colors.black,
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       } else {
            //         if (deliverable == 'Y') {
            //           Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => ProductCartCheckout(cartData: cartData,
            //                     finalPrice: calculateTotalPrice(),
            //                   )),
            //           );
            //         } else {
            //           _showAlertDialog();
            //         }
            //       }
            //     },
            //     child: Text('Checkout \₹ ${calculateTotalPrice().toStringAsFixed(2)}'),
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: U_Colors.yaleBlue,
            //     ),
            //   ),
            // ),
            body: isLoading
                ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(U_Colors.yaleBlue)))
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: cartData == null || cartData!.isEmpty
                  ? Center(child: Text('No items in the cart'))
                  : ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemCount: cartData!.length,
                itemBuilder: (_, index) {
                  final item = cartData![index];
                  print('Cart Data Length: ${cartData?.length}');

                  return Dismissible(
                    key: Key(item['id']),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      deleteCartItem(
                          loginController.userData['userId'].toString(),
                          item['id']);
                    },
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: AlignmentDirectional.centerEnd,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        ProductCartItems(
                          image: "${ApiConstants.baseUrl}${item['productImageUri'] ?? ''}",
                          description: item['productName'] ?? '',
                          purity:item['purity'],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductQuantityWithButton(
                              quantity: item['productQuantity'] ?? 1,
                              onIncrement: () {
                                final newQuantity = (item['productQuantity'] ?? 1) + 1;
                                updateCartItemQuantity(
                                  loginController.userData['userId'].toString(),
                                  item['id'],
                                  newQuantity,
                                  item['totalPrice'] / item['productQuantity'],
                                );
                              },
                              onDecrement: () {
                                if (item['productQuantity'] > 1) {
                                  final newQuantity = item['productQuantity'] - 1;
                                  updateCartItemQuantity(
                                    loginController.userData['userId'].toString(),
                                    item['id'],
                                    newQuantity,
                                    item['productPrice'] / item['productQuantity'],
                                  );
                                }
                              },
                            ),
                            CartProductPrice(
                              price: item['totalPrice']?.toDouble() ?? 0.0,
                              currencySign: '₹',
                              isLarge: false,
                              decimalPlaces: 2,
                            ),
                          ],
                        ),
                        DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),

                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        if (isUpdatingCart)
          Container(
            color: Colors.black.withOpacity(0.5),  // Dim the background
            child: Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(U_Colors.yaleBlue)),  // Show loading spinner
            ),
          ),
      ],
    );
  }


  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delivery Unavailable"),
          content: Text("Cannot deliver to this pin code"),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}




