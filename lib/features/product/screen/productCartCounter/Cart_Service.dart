import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/commons/config/api_constants.dart';

import 'Cart_Item.dart';

class CartService {
   String baseUrl = '${ApiConstants.CART_BASE_URL}';

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

  //fetch cart count data

  Future<String> fetchCartData(String userId) async {
    try {
      final String url = '$baseUrl$userId';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('payload') && data['payload'] is List) {
          final List<dynamic> payload = data['payload'];

          String payloadCount = payload.length.toString();

          print("Payload count: $payloadCount");

          return payloadCount;
        } else {
          print("Payload not found or invalid format.");
          return '0';
        }
      } else {
        print("Failed to load cart data. Status code: ${response.statusCode}");
        return '0';
      }
    } catch (error) {
      print("Error fetching cart data: $error");
      return '0'; // Return 0 if there is an error
    }
  }
}
