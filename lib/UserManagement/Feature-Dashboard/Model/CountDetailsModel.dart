class CountDetailsModel {
  final int totalBuyCount;
  final int totalSellCount;
  final int totalPropCount;
  final int totalTokeHoldigs;
  final double totalTokenPrice;

  const CountDetailsModel({
    required this.totalBuyCount,
    required this.totalPropCount,
    required this.totalSellCount,
    required this.totalTokeHoldigs,
    required this.totalTokenPrice,
  });

  factory CountDetailsModel.fromJson(Map<String, dynamic> json) {
    return CountDetailsModel(
        totalBuyCount: json["totalBuyCount"] ?? "NA",
        totalPropCount: json["totalPropCount"] ?? "NA",
        totalSellCount: json["totalSellCount"] ?? "NA",
        totalTokeHoldigs: json["totalTokeHoldigs"] ?? "NA",
        totalTokenPrice: json["totalTokenPrice"] ?? "NA");
  }
}
