class Deatils {
  final int totalBuyCount;
  final int totalSellCount;
  final int totalPropCount;
  final int totalTokeHoldigs;
  final double totalTokenPrice;

  Deatils({
    required this.totalBuyCount,
    required this.totalSellCount,
    required this.totalPropCount,
    required this.totalTokeHoldigs,
    required this.totalTokenPrice,
  });

  factory Deatils.fromJson(Map<String, dynamic> json) {
    return Deatils(
      totalBuyCount: json['totalBuyCount'] ?? 0.0,
      totalSellCount: json['totalSellCount'] ?? 0,
      totalPropCount: json['totalPropCount'] ?? 0,
      totalTokeHoldigs: json['totalTokeHoldigs'] ?? 0,
      totalTokenPrice: json['totalTokenPrice'] ?? 0.0,
    );
  }
}
