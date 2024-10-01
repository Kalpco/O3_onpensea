import 'dart:convert';

// Define the Product class
class Cart {
   String id;
   int userId;
   String productImageUri;
   String productName;
   String productDescription;
   String? productOwnerId;
   String productOwnerName;
   String productCategory;
   String productSubCategory;
   String productSize;
   double productWeight;
   double productPrice;
   int productQuantity;
   String productIsActive;
   double? productRating;
   dynamic responseDTO;
   double productMakingCharges;
   String? productOwnerType;
   dynamic gstCharges;
   int purity;
   double? totalPrice;
   double? goldPrice;
   dynamic gemsDTO;

  Cart({
    required this.id,
    required this.userId,
    required this.productImageUri,
    required this.productName,
    required this.productDescription,
    this.productOwnerId,
    required this.productOwnerName,
    required this.productCategory,
    required this.productSubCategory,
    required this.productSize,
    required this.productWeight,
    required this.productPrice,
    required this.productQuantity,
    required this.productIsActive,
    this.productRating,
    this.responseDTO,
    required this.productMakingCharges,
    this.productOwnerType,
    this.gstCharges,
    required this.purity,
    this.totalPrice,
    this.goldPrice,
    this.gemsDTO,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      productImageUri: json['productImageUri'],
      productName: json['productName'],
      productDescription: json['productDescription'],
      productOwnerId: json['productOwnerId'],
      productOwnerName: json['productOwnerName'],
      productCategory: json['productCategory'],
      productSubCategory: json['productSubCategory'],
      productSize: json['productSize'],
      productWeight: json['productWeight'].toDouble(),
      productPrice: json['productPrice'].toDouble(),
      productQuantity: json['productQuantity'],
      productIsActive: json['productIsActive'],
      productRating: json['productRating']?.toDouble(),
      responseDTO: json['responseDTO'],
      productMakingCharges: json['productMakingCharges'].toDouble(),
      productOwnerType: json['productOwnerType'],
      gstCharges: json['gstCharges'],
      purity: json['purity'],
      totalPrice: json['totalPrice']?.toDouble(),
      goldPrice: json['goldPrice']?.toDouble(),
      gemsDTO: json['gemsDTO'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productImageUri': productImageUri,
      'productName': productName,
      'productDescription': productDescription,
      'productOwnerId': productOwnerId,
      'productOwnerName': productOwnerName,
      'productCategory': productCategory,
      'productSubCategory': productSubCategory,
      'productSize': productSize,
      'productWeight': productWeight,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'productIsActive': productIsActive,
      'productRating': productRating,
      'responseDTO': responseDTO,
      'productMakingCharges': productMakingCharges,
      'productOwnerType': productOwnerType,
      'gstCharges': gstCharges,
      'purity': purity,
      'totalPrice': totalPrice,
      'goldPrice': goldPrice,
      'gemsDTO': gemsDTO,
    };
  }
}