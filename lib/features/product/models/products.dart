import 'package:onpensea/features/product/models/responseDTO.dart';

import 'gemsDTo.dart';

class ProductResponseDTO {
  String? id;
  List<String>? productImageUri;
  String? productName;
  String? productDescription;
  int? productOwnerId;
  String? productOwnerName;
  String? productCategory;
  String? productSubCategory;
  String? productSize;
  double? productWeight;
  double? productPrice;
  int? productQuantity;
  bool? productIsActive;
  List<Map<String, String>>? productComment;
  double? productRating;
  ResponseDTO? responseDTO;
  String? productOwnerType;
  double? totalPrice;
  double? goldPrice;
  double? gstCharges;
  double? productMakingCharges;
  int? purity;
  GemsDTO? gemsDTO;

  ProductResponseDTO({
    this.id,
    this.productImageUri,
    this.productName,
    this.productDescription,
    this.productOwnerId,
    this.productOwnerName,
    this.productCategory,
    this.productSubCategory,
    this.productSize,
    this.productWeight,
    this.productPrice,
    this.productQuantity,
    this.productIsActive,
    this.productComment,
    this.productRating,
    this.responseDTO,
    this.productOwnerType,
    this.goldPrice,
    this.productMakingCharges,
    this.gstCharges,
    this.totalPrice,
    this.purity,
    this.gemsDTO,
  });

  factory ProductResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProductResponseDTO(
      id: json['id'],
      productImageUri: List<String>.from(json['productImageUri'] ?? []),
      productName: json['productName'],
      productDescription: json['productDescription'],
      productOwnerId: json['productOwnerId'],
      productOwnerName: json['productOwnerName'],
      productCategory: json['productCategory'],
      productSubCategory: json['productSubCategory'],
      productSize: json['productSize'],
      productWeight: json['productWeight']?.toDouble(),
      productPrice: json['productPrice']?.toDouble(),
      productQuantity: json['productQuantity'],
      productIsActive: json['productIsActive'] == 'Y',
      productComment: List<Map<String, String>>.from(
        json['productComment']?.map((item) => Map<String, String>.from(item)) ?? [],
      ),
      productRating: json['productRating']?.toDouble(),
      responseDTO: json['responseDTO'] != null ? ResponseDTO.fromJson(json['responseDTO']) : null,
      productOwnerType: json['productOwnerType'],
      goldPrice: json['goldPrice']?.toDouble(),
      productMakingCharges: json['productMakingCharges']?.toDouble(),
      gstCharges: json['gstCharges']?.toDouble(),
      totalPrice: json['totalPrice']?.toDouble(),
      purity: json['purity'],
      gemsDTO: json['gemsDTO'] != null ? GemsDTO.fromJson(json["gemsDTO"]) : null,
    );
  }
}