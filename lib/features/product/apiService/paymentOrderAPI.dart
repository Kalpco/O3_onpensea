
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/features/product/models/order_api_success.dart';

import '../models/razorpay_failure_response.dart';

class RazorpayOrderAPI {

  final String keyId ;
  final String keySecret ;

  RazorpayOrderAPI(this.keyId, this.keySecret);

  Future<dynamic> createOrder(
    int amount, 
    String currency,
    String receipt,
    
  ) async {
    final url = Uri.https('api.razorpay.com', '/v1/orders');
    final body = jsonEncode({
      'amount': amount,
      'currency': currency,
      'receipt': receipt,
    });

    final credentials = base64Encode(utf8.encode('$keyId:$keySecret'));

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic $credentials',
      },
      body: body,
    );
  
    if (response.statusCode == 200) {
       final decodedJson = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
        print("return dto .....");
        print(response.body);
      // Parse the JSON into the RazorpaySuccessResponseDTO object
      return RazorpaySuccessResponseDTO.fromJson(decodedJson);

    } else {
      final decodedJson = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      print('Failed to create order: ${response.statusCode}');
      return RazorpayFailureResponse.fromJson(decodedJson);

    }
  }
}

