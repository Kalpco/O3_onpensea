class TransactionModel {
  final int vaultId;
  final int userId;
  final double pricePerMgNoGst;
  final double pricePerMgWithGst;
  final String vaultTransactionType;
  final double weightMg;
  final double amount;
  final int transactionId;
  final DateTime createdAt;
  final String createdBy;
  final double vendorBuyingRate;
  final double vendorSellingRate;
  final double kalpcoBuyingRate;
  final double kalpcoSellingRate;

  TransactionModel({
    required this.vaultId,
    required this.userId,
    required this.pricePerMgNoGst,
    required this.pricePerMgWithGst,
    required this.vaultTransactionType,
    required this.weightMg,
    required this.amount,
    required this.transactionId,
    required this.createdAt,
    required this.createdBy,
    required this.vendorBuyingRate,
    required this.vendorSellingRate,
    required this.kalpcoBuyingRate,
    required this.kalpcoSellingRate,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      vaultId: json['vaultId'] ?? 0,
      userId: json['userId'] ?? 0,
      pricePerMgNoGst: json['pricePerMgNoGst']?.toDouble() ?? 0.0,
      pricePerMgWithGst: json['pricePerMgWithGst']?.toDouble() ?? 0.0,
      vaultTransactionType: json['vaultTransactionType'] ?? '',
      weightMg: json['weight_mg']?.toDouble() ?? 0.0,
      amount: json['amount']?.toDouble() ?? 0.0,
      transactionId: json['transactionId'] ?? 0,
      createdAt: json.containsKey('createdAt') ? DateTime.parse(json['createdAt']) : DateTime.now(),
      createdBy: json['createdBy'] ?? '',
      vendorBuyingRate: json['vendorBuyingRate']?.toDouble() ?? 0.0,
      vendorSellingRate: json['vendorSellingRate']?.toDouble() ?? 0.0,
      kalpcoBuyingRate: json['kalpcoBuyingRate']?.toDouble() ?? 0.0,
      kalpcoSellingRate: json['kalpcoSellingRate']?.toDouble() ?? 0.0,
    );
  }
}
