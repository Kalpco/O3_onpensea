import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';

import 'Cart_Item.dart';

class CartService {
  static String baseUrl = '${ApiConstants.CART_BASE_URL}';

  Future<Cart> fetchCartItems(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl$userId'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print('API Response: ${response.body}');  // Print the raw response
      print('Parsed Payload: ${jsonResponse['payload']}');  // Print the parsed payload
      return Cart.fromJson(jsonResponse['payload']);
    } else {
      print('Failed to load cart items: ${response.statusCode}');
      throw Exception('Failed to load cart items');
    }
  }
}
