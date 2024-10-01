class WalletTransactionDTO {
  final int walletId;
  final DateTime updateaDate;
  final BigInt amount;
  final String reason;
  final String transactionType;

  WalletTransactionDTO({
    required this.walletId,
    required this.updateaDate,
    required this.amount,
    required this.reason,
    required this.transactionType,
  });

  factory WalletTransactionDTO.fromJson(Map<String, dynamic> json) {
    return WalletTransactionDTO(
      walletId: json['walletId'],
      updateaDate: DateTime.parse(json['updateaDate']),
      amount: json['amount'] is String
          ? BigInt.parse(json['amount'])
          : BigInt.from(json['amount']),
      reason: json['reason'],
      transactionType: json['transactionType'],
    );
  }
}