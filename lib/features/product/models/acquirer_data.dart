import 'dart:convert';
class AcquirerData {
  String authenticationReferenceNumber;

  AcquirerData({
    required this.authenticationReferenceNumber,
  });

  factory AcquirerData.fromJson(Map<String, dynamic> json) => AcquirerData(
    authenticationReferenceNumber: json["authentication_reference_number"]?? '',
  );

  Map<String, dynamic> toJson() => {
    "authentication_reference_number": authenticationReferenceNumber,
  };
}