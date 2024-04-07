class TokenPriceModel {

  final String tokenName;
  final String tokenSymbol;
  final int tokenCap;
  final int tokenSupply;
  final double tokenBalance;
  final String updatedDate;
  final String delFlg;
  final String status;
  final String remarks;
  final double price;
  final String lastUpdatedDate;

  TokenPriceModel({
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenCap,
    required this.tokenSupply,
    required this.tokenBalance,
    required this.updatedDate,
    required this.delFlg,
    required this.status,
    required this.price,
    required this.lastUpdatedDate,
    required this.remarks,
  });

  factory TokenPriceModel.fromJson(Map<String, dynamic> json) {
    return TokenPriceModel(
      tokenName: json['tokenName'] ?? 'NA',
      tokenSymbol: json['tokenSymbol'] ?? 'NA',
      tokenCap: json['tokenCap'] ?? 'NA',
      tokenSupply: json['tokenSupply'] ?? 'NA',
      tokenBalance: json['tokenBalance'] ?? 'NA',
      updatedDate: json['updatedDate'] ?? 'NA',
      delFlg: json['delFlg'] ?? 'NA',
      status: json['status'] ?? 'NA',
      remarks: json['remarks'] ?? 'NA',
      price: json['price'] ?? 'NA',
      lastUpdatedDate: json['lastUpdatedDate'] ?? 'NA',
    );
  }
}
