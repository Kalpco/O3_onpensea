class ProductTransactionDTO {
  int? transactionDetailId;
  String? productId;
  double? productPrice;
  double? gstCharge;
  double? makingCharges;
  double? totalAmount;
  double? productWeight;
  double? discountPercentage;
  double? discountedPrice;
  int? purity;
  int? merchantId;
  int? offerId;
  int? couponId;
  bool? payedFromWallet;
  double? walletAmount;
  DateTime? createDate;
  DateTime? updateDate;
  int? userId;
  int? userAddressId;
  String? productPic;
  String? deliveryStatus;
  String? productName;
  int? productQuantity;
  double? goldAndDiamondPrice;
  bool? discountApplied;

  ProductTransactionDTO({
    this.transactionDetailId,
    this.productId,
    this.productPrice,
    this.gstCharge,
    this.makingCharges,
    this.totalAmount,
    this.productWeight,
    this.discountPercentage,
    this.discountedPrice,
    this.purity,
    this.merchantId,
    this.offerId,
    this.couponId,
    this.payedFromWallet,
    this.walletAmount,
    this.createDate,
    this.updateDate,
    this.deliveryStatus,
    this.productName,
    this.productPic,
    this.productQuantity,
    this.userId,
    this.userAddressId,
    this.goldAndDiamondPrice,
    this.discountApplied
  });

  factory ProductTransactionDTO.fromJson(Map<String, dynamic> json) => ProductTransactionDTO(
    transactionDetailId: json["transactionDetailId"],
    productId: json["productId"],
    productPrice: json["productPrice"]?.toDouble(),
    gstCharge: json["gstCharge"]?.toDouble(),
    makingCharges: json["makingCharges"]?.toDouble(),
    totalAmount: json["totalAmount"]?.toDouble(),
    productWeight: json["productWeight"]?.toDouble(),
    discountPercentage: json["discountPercentage"]?.toDouble(),
    discountedPrice: json["discountedPrice"]?.toDouble(),
    purity: json["purity"],
    merchantId: json["merchantId"],
    offerId: json["offerId"],
    couponId: json["couponId"],
    payedFromWallet: json["payedFromWallet"],
    walletAmount: json["walletAmount"]?.toDouble(),
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
    updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
    deliveryStatus: json["deliveryStatus"],
    productName: json["productName"],
    productPic: json["productPic"],
    productQuantity: json["productQuantity"],
    userId: json["userId"],
    userAddressId: json["userAddressId"],
    goldAndDiamondPrice: json["goldAndDiamondPrice"],
      discountApplied: json["discountApplied"]

  );

  Map<String, dynamic> toJson() => {
    "transactionDetailId": transactionDetailId,
    "productId": productId,
    "productPrice": productPrice,
    "gstCharge": gstCharge,
    "makingCharges": makingCharges,
    "totalAmount": totalAmount,
    "productWeight": productWeight,
    "discountPercentage": discountPercentage,
    "discountedPrice": discountedPrice,
    "purity": purity,
    "merchantId": merchantId,
    "offerId": offerId,
    "couponId": couponId,
    "payedFromWallet": payedFromWallet,
    "walletAmount": walletAmount,
    "createDate": createDate?.toIso8601String(),
    "updateDate": updateDate?.toIso8601String(),
    "productPic": productPic,
    "deliveryStatus": deliveryStatus,
    "productName": productName,
    "productQuantity": productQuantity,
    "userId": userId,
    "userAddressId":userAddressId,
    "goldAndDiamondPrice":goldAndDiamondPrice
  };
}