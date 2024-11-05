class WalletTransactionDTO {
  final int walletId;
  final DateTime? updateaDate; // Make this nullable
  final double amount;
  final String? reason; // Make this nullable
  final String transactionType;
  final String? productType; // Make this nullable

  WalletTransactionDTO({
    required this.walletId,
    required this.updateaDate,
    required this.amount,
    this.reason,
    required this.transactionType,
    this.productType,// Optional parameter, can be null
  });

  factory WalletTransactionDTO.fromJson(Map<String, dynamic> json) {
    return WalletTransactionDTO(
      walletId: json['walletId'],
      updateaDate: json['updateaDate'] != null ? DateTime.parse(json['updateaDate']) : null,
      amount: json["amount"].toDouble(),
      reason: json['reason'],
      transactionType: json['transactionType'],
      productType: json['productType'],// This can be null now
    );
  }
}
