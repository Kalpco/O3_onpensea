// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome schemeTransactionFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  int statusCode;
  String statusMsg;
  List<Payload> payload;

  Welcome({
    required this.statusCode,
    required this.statusMsg,
    required this.payload,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    statusCode: json["statusCode"],
    statusMsg: json["statusMsg"],
    payload: List<Payload>.from(json["payload"].map((x) => Payload.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "statusMsg": statusMsg,
    "payload": List<dynamic>.from(payload.map((x) => x.toJson())),
  };
}

class Payload {
  int schemeTransactionId;
  String schemeId;
  String schemeCustomerName;
  String schemeCustomerId;
  String schemeEnrollmentDate;
  String schemeMaturityDate;
  String schemePremiumAmount;
  String schemeTotalInstallmentToBePaid;
  String schemeTotalAmountPaidTillNow;
  String schemeNoOfInstallment;
  String schemeSpecialDiscount;
  String schemeStatus;
  String schemeCreatedAt;
  String schemeCreatedBy;
  String schemeUpdatedAt;
  String schemeUpdatedBy;
  String schemeLastEmiTransactionDate;
  String schemeEmiTransactionDate;
  String schemeTransactionStatus;
  String schemeBankName;
  String schemeBankAccount;
  String schemePanNumber;
  String schemeAadharNumber;
  String schemeNomineeName;
  String schemeRelationship;
  String schemeMobileNumber;

  Payload({
    required this.schemeTransactionId,
    required this.schemeId,
    required this.schemeCustomerName,
    required this.schemeCustomerId,
    required this.schemeEnrollmentDate,
    required this.schemeMaturityDate,
    required this.schemePremiumAmount,
    required this.schemeTotalInstallmentToBePaid,
    required this.schemeTotalAmountPaidTillNow,
    required this.schemeNoOfInstallment,
    required this.schemeSpecialDiscount,
    required this.schemeStatus,
    required this.schemeCreatedAt,
    required this.schemeCreatedBy,
    required this.schemeUpdatedAt,
    required this.schemeUpdatedBy,
    required this.schemeLastEmiTransactionDate,
    required this.schemeEmiTransactionDate,
    required this.schemeTransactionStatus,
    required this.schemeBankName,
    required this.schemeBankAccount,
    required this.schemePanNumber,
    required this.schemeAadharNumber,
    required this.schemeNomineeName,
    required this.schemeRelationship,
    required this.schemeMobileNumber,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
    schemeTransactionId: json["schemeTransactionID"],
    schemeId: json["schemeID"],
    schemeCustomerName: json["schemeCustomerName"],
    schemeCustomerId: json["schemeCustomerID"],
    schemeEnrollmentDate: json["schemeEnrollmentDate"],
    schemeMaturityDate: json["schemeMaturityDate"],
    schemePremiumAmount: json["schemePremiumAmount"],
    schemeTotalInstallmentToBePaid: json["schemeTotalInstallmentToBePaid"],
    schemeTotalAmountPaidTillNow: json["schemeTotalAmountPaidTillNow"],
    schemeNoOfInstallment: json["schemeNoOfInstallment"],
    schemeSpecialDiscount: json["schemeSpecialDiscount"],
    schemeStatus: json["schemeStatus"],
    schemeCreatedAt: json["schemeCreatedAt"],
    schemeCreatedBy: json["schemeCreatedBy"],
    schemeUpdatedAt: json["schemeUpdatedAt"],
    schemeUpdatedBy: json["schemeUpdatedBy"],
    schemeLastEmiTransactionDate: json["schemeLastEmiTransactionDate"],
    schemeEmiTransactionDate: json["schemeEmiTransactionDate"],
    schemeTransactionStatus: json["schemeTransactionStatus"],
    schemeBankName: json["schemeBankName"],
    schemeBankAccount: json["schemeBankAccount"],
    schemePanNumber: json["schemePanNumber"],
    schemeAadharNumber: json["schemeAadharNumber"],
    schemeNomineeName: json["schemeNomineeName"],
    schemeRelationship: json["schemeRelationship"],
    schemeMobileNumber: json["schemeMobileNumber"],
  );

  Map<String, dynamic> toJson() => {
    "schemeTransactionID": schemeTransactionId,
    "schemeID": schemeId,
    "schemeCustomerName": schemeCustomerName,
    "schemeCustomerID": schemeCustomerId,
    "schemeEnrollmentDate": schemeEnrollmentDate,
    "schemeMaturityDate": schemeMaturityDate,
    "schemePremiumAmount": schemePremiumAmount,
    "schemeTotalInstallmentToBePaid": schemeTotalInstallmentToBePaid,
    "schemeTotalAmountPaidTillNow": schemeTotalAmountPaidTillNow,
    "schemeNoOfInstallment": schemeNoOfInstallment,
    "schemeSpecialDiscount": schemeSpecialDiscount,
    "schemeStatus": schemeStatus,
    "schemeCreatedAt": schemeCreatedAt,
    "schemeCreatedBy": schemeCreatedBy,
    "schemeUpdatedAt": schemeUpdatedAt,
    "schemeUpdatedBy": schemeUpdatedBy,
    "schemeLastEmiTransactionDate": schemeLastEmiTransactionDate,
    "schemeEmiTransactionDate": schemeEmiTransactionDate,
    "schemeTransactionStatus": schemeTransactionStatus,
    "schemeBankName": schemeBankName,
    "schemeBankAccount": schemeBankAccount,
    "schemePanNumber": schemePanNumber,
    "schemeAadharNumber": schemeAadharNumber,
    "schemeNomineeName": schemeNomineeName,
    "schemeRelationship": schemeRelationship,
    "schemeMobileNumber": schemeMobileNumber,
  };
}
