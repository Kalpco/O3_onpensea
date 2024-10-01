import 'dart:convert';

import 'razorpay_response_error.dart';

RazorpayFailureResponse RazorpayFailureResponseFromJson(String str) => RazorpayFailureResponse.fromJson(json.decode(str));

String RazorpayFailureResponseToJson(RazorpayFailureResponse data) => json.encode(data.toJson());

class RazorpayFailureResponse {
  RazorpayResponseError error;

  RazorpayFailureResponse({
    required this.error,
  });

  factory RazorpayFailureResponse.fromJson(Map<String, dynamic> json) => RazorpayFailureResponse(
    error: RazorpayResponseError.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error.toJson(),
  };
}