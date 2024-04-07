class Seller {

  final String id;

  final String propId;

  final String propName;

  final String sellerId;

  final String sellerName;

  final String address;

  final String sellerWallerAddress;

  final double tokenRequested;

  final String tokenId;

  final String tokenName;

  final String paymentType;

  final String tokenTransferStatus;

  final String tokenRequestDate;

  final String verifiedDate;

  final String verifiedBy;

  final String delFlg;

  final String status;

  final String remarks;
  final String propImage1Byte;
  final String propImage2Byte;
  final String propImage3Byte;
  final String tokePrice;

  Seller({
    required this.id,
    required this.address,
    required this.sellerId,
    required this.sellerName,
    required this.tokenRequestDate,
    required this.sellerWallerAddress,
    required this.delFlg,
    required this.paymentType,
    required this.propId,
    required this.propName,
    required this.remarks,
    required this.status,
    required this.tokenId,
    required this.tokenName,
    required this.tokenRequested,
    required this.tokenTransferStatus,
    required this.verifiedBy,
    required this.verifiedDate,
    required this.propImage1Byte,
    required this.propImage2Byte,
    required this.propImage3Byte,
    required this.tokePrice,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json["id"] ?? "NA",
      address: json["address"] ?? "NA",
      sellerId: json["sellerId"] ?? "NA",
      sellerName: json["buyerName"] ?? "NA",
      tokenRequestDate: json["buyerRequestDate"] ?? "NA",
      sellerWallerAddress: json["buyerWalletAddress"] ?? "NA",
      delFlg: json["delFlg"] ?? "NA",
      paymentType: json["paymentType"] ?? "NA",
      propId: json["propId"] ?? "NA",
      propName: json["propName"] ?? "NA",
      remarks: json["remarks"] ?? "NA",
      status: json["status"] ?? "NA",
      tokenId: json["tokenId"] ?? "NA",
      tokenName: json["tokenName"] ?? "NA",
      tokenRequested: json["tokenRequested"] ?? "NA",
      tokenTransferStatus: json["tokenTransferStatus"] ?? "NA",
      verifiedBy: json["verifiedBy"] ?? "NA",
      verifiedDate: json["verifiedDate"] ?? "NA",
      propImage1Byte: json["propImage1Byte"] ?? "NA",
      propImage2Byte: json["propImage2Byte"] ?? "NA",
      propImage3Byte: json["propImage3Byte"] ?? "NA",
      tokePrice: json["tokenPrice"] ?? "NA",
    );
  }
}
