class TransactionDTO {
  int? transactionId;
  String? paymentGatewayTransactionId;
  int? userId;
  String? transactionStatus;
  String? transactionMessage;
  String? transactionOrderId;
  DateTime? createDate;
  DateTime? updateDate;
  bool? payedFromWallet;
  double? walletAmount;
  double? transactionAmount;
  int? userAddressId;

  TransactionDTO({
     this.transactionId,
     this.paymentGatewayTransactionId,
     this.userId,
     this.transactionStatus,
     this.transactionMessage,
     this.transactionOrderId,
     this.createDate,
     this.updateDate,
    this.payedFromWallet,
    this.walletAmount,
    this.transactionAmount,
    this.userAddressId,
  });

  factory TransactionDTO.fromJson(Map<String, dynamic> json) => TransactionDTO(
    transactionId: json["transactionId"],
    paymentGatewayTransactionId: json["paymentGatewayTransactionId"],
    userId: json["userId"],
    transactionStatus: json["transactionStatus"],
    transactionMessage: json["transactionMessage"],
    transactionOrderId: json["transactionOrderId"],
    createDate: DateTime.parse(json["createDate"]),
    updateDate: DateTime.parse(json["updateDate"]),
    payedFromWallet: json["payedFromWallet"],
    walletAmount: json["walletAmount"]?.toDouble(),
    transactionAmount: json["transactionAmount"]?.toDouble,
    userAddressId: json["userAddressId"],
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "paymentGatewayTransactionId": paymentGatewayTransactionId,
    "userId": userId,
    "transactionStatus": transactionStatus,
    "transactionMessage": transactionMessage,
    "transactionOrderId": transactionOrderId,
    "createDate": createDate?.toIso8601String(),
    "updateDate": updateDate?.toIso8601String(),
    "payedFromWallet": payedFromWallet,
    "walletAmount": walletAmount,
    "transactionAmount":transactionAmount,
    "userAddressId":userAddressId,
  };
}