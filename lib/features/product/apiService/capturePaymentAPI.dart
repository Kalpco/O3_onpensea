
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/features/product/models/order_api_success.dart';

import '../models/capture_payment_success.dart';
import '../models/razorpay_failure_response.dart';

class RazorpayCapturePayment {
  final String keyId ;
  final String keySecret ;

  RazorpayCapturePayment(this.keyId, this.keySecret);

  Future<dynamic> capturePayment(
      int amount,
      String currency,
      String paymentId


      ) async {
    final url = Uri.https('api.razorpay.com', '/v1/payments/$paymentId/capture');
    final body = jsonEncode({
      'amount': amount,
      'currency': currency

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
      print("return decodedJson of capture payment ..... :    $decodedJson");
      print(response.body);
      return CapturePaymentRazorPay.fromJson(decodedJson);
    } else {
      final decodedJson = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      print('Failed to capture order: ${response.statusCode}');
     return RazorpayFailureResponse.fromJson(decodedJson);

    }
  }
}

