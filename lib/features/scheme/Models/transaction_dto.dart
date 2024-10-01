class TransactionDto {
  String? payementGatewayTransctionId;
  String? userId;
  String? transactionStatus;
  String? transactionMessage;
  String? merchantId;
  String? schemeId;
  String? schemeAmount;
  String? interestRate;
  String? isActive;

  TransactionDto(
      {required this.isActive,
      required this.interestRate,
      required this.schemeAmount,
      required this.merchantId,
      required this.userId,
      required this.payementGatewayTransctionId,
      required this.schemeId,
      required this.transactionStatus,
      required this.transactionMessage});

}
