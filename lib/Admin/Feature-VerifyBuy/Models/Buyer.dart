class Buyer {
  final String id;
  final String address;
  final String buyerId;
  final String buyerName;
  final String buyerRequestDate;
  final String buyerWalletAddress;
  final String delFlg;
  final String paymentType;
  final String propId;
  final String propName;
  final String remarks;
  final String status;
  final String tokenId;
  final String tokenName;
  final double tokenRequested;
  final String tokenTransferStatus;
  final String verifiedBy;
  final String verifiedDate;
  final String propImage1Byte;
  final String propImage2Byte;
  final String propImage3Byte;
  final String tokenPrice;

  Buyer({
    required this.id,
    required this.address,
    required this.buyerId,
    required this.buyerName,
    required this.buyerRequestDate,
    required this.buyerWalletAddress,
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
    required this.tokenPrice,
  });

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      id: json["id"] ?? "NA",
      address: json["address"] ?? "NA",
      buyerId: json["buyerId"] ?? "NA",
      buyerName: json["buyerName"] ?? "NA",
      buyerRequestDate: json["buyerRequestDate"] ?? "NA",
      buyerWalletAddress: json["buyerWalletAddress"] ?? "NA",
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
      tokenPrice: json["tokenPrice"] ?? "NA",
    );
  }
}
