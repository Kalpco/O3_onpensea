import 'dart:convert';

InvestmentResponseModel investmentResponseModelFromJson(String str) =>
    InvestmentResponseModel.fromJson(json.decode(str));

String investmentResponseModelToJson(InvestmentResponseModel data) =>
    json.encode(data.toJson());

class InvestmentResponseModel {
  int statusCode;
  String statusMsg;
  List<Investments> payload;

  InvestmentResponseModel({
    required this.statusCode,
    required this.statusMsg,
    required this.payload,
  });

  factory InvestmentResponseModel.fromJson(Map<String, dynamic> json) =>
      InvestmentResponseModel(
        statusCode: json["statusCode"],
        statusMsg: json["statusMsg"],
        payload: List<Investments>.from(
            json["payload"].map((x) => Investments.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "statusMsg": statusMsg,
    "payload": List<dynamic>.from(payload.map((x) => x.toJson())),
  };
}

class Investments {
  String categoryType;
  int count;
  List<Datum> data;

  Investments({
    required this.categoryType,
    required this.count,
    required this.data,
  });

  factory Investments.fromJson(Map<String, dynamic> json) =>
      Investments(
        categoryType: json["categoryType"],
        count: json["count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "categoryType": categoryType,
    "count": count,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int investmentId;
  String companyName;
  String investmentImage01;
  String investmentImage02;
  String investmentImage03;
  String investmentCompanyImage;
  String investmentName;
  String investmentHeadlineSummary;
  String investmentMaturity;
  String investmentReturns;
  List<String> investmentBenefits;
  List<String> investmentInstruction;
  List<String> investmentExample;
  String investmentAboutVideoLink;
  List<String> investmentAboutDescription;
  List<Investment> investmentFaq;
  List<Investment> investmentTermsAndCondition;
  String investmentOwnerAddress;
  String investmentType;
  String investmentPrice;
  String ownerJewelleryStoreImage;
  String jewelleryShopName;
  List<String> jewelleryAddress;

  Datum({
    required this.investmentId,
    required this.companyName,
    required this.investmentImage01,
    required this.investmentImage02,
    required this.investmentImage03,
    required this.investmentCompanyImage,
    required this.investmentName,
    required this.investmentHeadlineSummary,
    required this.investmentMaturity,
    required this.investmentReturns,
    required this.investmentBenefits,
    required this.investmentInstruction,
    required this.investmentExample,
    required this.investmentAboutVideoLink,
    required this.investmentAboutDescription,
    required this.investmentFaq,
    required this.investmentTermsAndCondition,
    required this.investmentOwnerAddress,
    required this.investmentType,
    required this.investmentPrice,
    required this.ownerJewelleryStoreImage,
    required this.jewelleryShopName,
    required this.jewelleryAddress,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    investmentId: json["investmentId"],
    companyName: json["companyName"],
    investmentImage01: json["investmentImage01"],
    investmentImage02: json["investmentImage02"],
    investmentImage03: json["investmentImage03"],
    investmentCompanyImage: json["investmentCompanyImage"],
    investmentName: json["investmentName"],
    investmentHeadlineSummary: json["investmentHeadlineSummary"],
    investmentMaturity: json["investmentMaturity"],
    investmentReturns: json["investmentReturns"],
    investmentBenefits:
    List<String>.from(json["investmentBenefits"].map((x) => x)),
    investmentInstruction:
    List<String>.from(json["investmentInstruction"].map((x) => x)),
    investmentExample:
    List<String>.from(json["investmentExample"].map((x) => x)),
    investmentAboutVideoLink: json["investmentAboutVideoLink"],
    investmentAboutDescription:
    List<String>.from(json["investmentAboutDescription"].map((x) => x)),
    investmentFaq: List<Investment>.from(
        json["investmentFAQ"].map((x) => Investment.fromJson(x))),
    investmentTermsAndCondition: List<Investment>.from(
        json["investmentTermsAndCondition"]
            .map((x) => Investment.fromJson(x))),
    investmentOwnerAddress: json["investmentOwnerAddress"],
    investmentType: json["investmentType"],
    investmentPrice: json["investmentPrice"],
    ownerJewelleryStoreImage: json["ownerJewelleryStoreImage"],
    jewelleryShopName: json["jewelleryShopName"],
    jewelleryAddress:
    List<String>.from(json["jewelleryAddress"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "investmentId": investmentId,
    "companyName": companyName,
    "investmentImage01": investmentImage01,
    "investmentImage02": investmentImage02,
    "investmentImage03": investmentImage03,
    "investmentCompanyImage": investmentCompanyImage,
    "investmentName": investmentName,
    "investmentHeadlineSummary": investmentHeadlineSummary,
    "investmentMaturity": investmentMaturity,
    "investmentReturns": investmentReturns,
    "investmentBenefits":
    List<dynamic>.from(investmentBenefits.map((x) => x)),
    "investmentInstruction":
    List<dynamic>.from(investmentInstruction.map((x) => x)),
    "investmentExample":
    List<dynamic>.from(investmentExample.map((x) => x)),
    "investmentAboutVideoLink": investmentAboutVideoLink,
    "investmentAboutDescription":
    List<dynamic>.from(investmentAboutDescription.map((x) => x)),
    "investmentFAQ":
    List<dynamic>.from(investmentFaq.map((x) => x.toJson())),
    "investmentTermsAndCondition": List<dynamic>.from(
        investmentTermsAndCondition.map((x) => x.toJson())),
    "investmentOwnerAddress": investmentOwnerAddress,
    "investmentType": investmentType,
    "investmentPrice": investmentPrice,
    "ownerJewelleryStoreImage": ownerJewelleryStoreImage,
    "jewelleryShopName": jewelleryShopName,
    "jewelleryAddress": List<dynamic>.from(jewelleryAddress.map((x) => x)),
  };
}

class Investment {
  String question;
  String answer;

  Investment({
    required this.question,
    required this.answer,
  });

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answer": answer,
  };
}
