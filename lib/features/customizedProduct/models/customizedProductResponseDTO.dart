import 'dart:convert';

CustomizedProductResponseDTO customizedProductResponseDTOFromJson(String str) => CustomizedProductResponseDTO.fromJson(json.decode(str));

String customizedProductResponseDTOToJson(CustomizedProductResponseDTO data) => json.encode(data.toJson());

class CustomizedProductResponseDTO {
  String? id;
  List<String>? customizedImageUrl;
  String? customizedImageCode;
  String? productSubCategory;
  String? productType;
  int? productOwnerId;
  String? productOwnerType;
  String? productIsActive;

  CustomizedProductResponseDTO({
    this.id,
    this.customizedImageUrl,
    this.customizedImageCode,
    this.productSubCategory,
    this.productType,
    this.productOwnerId,
    this.productOwnerType,
    this.productIsActive,
  });

  factory CustomizedProductResponseDTO.fromJson(Map<String, dynamic> json) => CustomizedProductResponseDTO(
    id: json["id"],
    customizedImageUrl: json["customizedImageUrl"] == null ? [] : List<String>.from(json["customizedImageUrl"]!.map((x) => x)),
    customizedImageCode: json["customizedImageCode"],
    productSubCategory: json["productSubCategory"],
    productType: json["productType"],
    productOwnerId: json["productOwnerId"],
    productOwnerType: json["productOwnerType"],
    productIsActive: json["productIsActive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customizedImageUrl": customizedImageUrl == null ? [] : List<dynamic>.from(customizedImageUrl!.map((x) => x)),
    "customizedImageCode": customizedImageCode,
    "productSubCategory": productSubCategory,
    "productType": productType,
    "productOwnerId": productOwnerId,
    "productOwnerType": productOwnerType,
    "productIsActive": productIsActive,
  };
}