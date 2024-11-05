// gold_price_model.dart
class GoldPriceModel {
  final String goldPrice;
  final String goldUnit;

  GoldPriceModel({required this.goldPrice, required this.goldUnit});

  factory GoldPriceModel.fromJson(Map<String, dynamic> json) {
    return GoldPriceModel(
      goldPrice: json['goldPrice'],
      goldUnit: json['goldUnit'],
    );
  }
}
