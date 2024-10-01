class InvestmentTransactionDTOList {
  int? investmentId;
  String? investmentType;
  String? investmentName;
  double? investmentAmount;
  DateTime? createDate;
  DateTime? updateDate;

  InvestmentTransactionDTOList({
    this.investmentId,
    this.investmentType,
    this.investmentName,
    this.investmentAmount,
    this.createDate,
    this.updateDate,
  });

  factory InvestmentTransactionDTOList.fromJson(Map<String, dynamic> json) => InvestmentTransactionDTOList(
    investmentId: json["investmentId"],
    investmentType: json["investmentType"],
    investmentName: json["investmentName"],
    investmentAmount: json["investmentAmount"]?.toDouble(),
    createDate: json["createDate"] == null ? null : DateTime.parse(json["createDate"]),
    updateDate: json["updateDate"] == null ? null : DateTime.parse(json["updateDate"]),
  );

  Map<String, dynamic> toJson() => {
    "investmentId": investmentId,
    "investmentType": investmentType,
    "investmentName": investmentName,
    "investmentAmount": investmentAmount,
    "createDate": createDate?.toIso8601String(),
    "updateDate": updateDate?.toIso8601String(),
  };
}
