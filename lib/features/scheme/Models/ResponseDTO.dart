// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ResponseDTO responseDTOFromJson(String str) => ResponseDTO.fromJson(json.decode(str));

String responseDTOToJson(ResponseDTO data) => json.encode(data.toJson());

class ResponseDTO {
  int? statusCode;
  String? statusMsg;
  List<Scheme>? schemeList;

  ResponseDTO({
    this.statusCode,
    this.statusMsg,
    this.schemeList,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) => ResponseDTO(
        statusCode: json["statusCode"],
        statusMsg: json["statusMsg"],
        schemeList: json["payload"] == null
            ? []
            : List<Scheme>.from(
                json["payload"]!.map((x) => Scheme.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "statusMsg": statusMsg,
        "payload": schemeList == null
            ? []
            : List<dynamic>.from(schemeList!.map((x) => x.toJson())),
      };
}

class Scheme {
  int? schemeId;
  String? schemeName;
  String? schemeOwnerName;
  String? schemeMerchantId;
  String? schemeRules;
  String? schemeDescription;
  String? schemeCreatedDate;
  String? schemeExpiryDate;
  String? schemeRedemptionDate;
  String? schemeDuration;
  String? schemeMinimumInvestment;
  String? schemeMaximumInvestment;
  String? schemeSpecialDiscount;
  String? schemeProductId;
  String? schemeProductName;
  String? schemeParentPlanName;
  String? schemeExtraBenefits;
  String? schemaImageUri;

  Scheme({
    this.schemeId,
    this.schemeName,
    this.schemeOwnerName,
    this.schemeMerchantId,
    this.schemeRules,
    this.schemeDescription,
    this.schemeCreatedDate,
    this.schemeExpiryDate,
    this.schemeRedemptionDate,
    this.schemeDuration,
    this.schemeMinimumInvestment,
    this.schemeMaximumInvestment,
    this.schemeSpecialDiscount,
    this.schemeProductId,
    this.schemeProductName,
    this.schemeParentPlanName,
    this.schemeExtraBenefits,
    this.schemaImageUri,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) => Scheme(
        schemeId: json["schemeID"],
        schemeName: json["schemeName"],
        schemeOwnerName: json["schemeOwnerName"],
        schemeMerchantId: json["schemeMerchantID"],
        schemeRules: json["schemeRules"],
        schemeDescription: json["schemeDescription"],
        schemeCreatedDate: json["schemeCreatedDate"],
        schemeExpiryDate: json["schemeExpiryDate"],
        schemeRedemptionDate: json["schemeRedemptionDate"],
        schemeDuration: json["schemeDuration"],
        schemeMinimumInvestment: json["schemeMinimumInvestment"],
        schemeMaximumInvestment: json["schemeMaximumInvestment"],
        schemeSpecialDiscount: json["schemeSpecialDiscount"],
        schemeProductId: json["schemeProductID"],
        schemeProductName: json["schemeProductName"],
        schemeParentPlanName: json["schemeParentPlanName"],
        schemeExtraBenefits: json["schemeExtraBenefits"],
        schemaImageUri: json["schemaImageUri"],
      );

  Map<String, dynamic> toJson() => {
        "schemeID": schemeId,
        "schemeName": schemeName,
        "schemeOwnerName": schemeOwnerName,
        "schemeMerchantID": schemeMerchantId,
        "schemeRules": schemeRules,
        "schemeDescription": schemeDescription,
        "schemeCreatedDate": schemeCreatedDate,
        "schemeExpiryDate": schemeExpiryDate,
        "schemeRedemptionDate": schemeRedemptionDate,
        "schemeDuration": schemeDuration,
        "schemeMinimumInvestment": schemeMinimumInvestment,
        "schemeMaximumInvestment": schemeMaximumInvestment,
        "schemeSpecialDiscount": schemeSpecialDiscount,
        "schemeProductID": schemeProductId,
        "schemeProductName": schemeProductName,
        "schemeParentPlanName": schemeParentPlanName,
        "schemeExtraBenefits": schemeExtraBenefits,
        "schemaImageUri": schemaImageUri,
      };
}
