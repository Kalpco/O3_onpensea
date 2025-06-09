import 'package:flutter/material.dart';

class Last7DaysGoldRateDTO {
  final DateTime date;
  final double priceGram24k;
  final double priceGram22k;
  final double priceGram18k;


  Last7DaysGoldRateDTO({required this.date, required this.priceGram24k,required this.priceGram22k,required this.priceGram18k});

  factory Last7DaysGoldRateDTO.fromJson(Map<String, dynamic> json) {
    return Last7DaysGoldRateDTO(
      date: DateUtils.dateOnly(DateTime.parse(json['date']).toLocal()),
      priceGram24k: double.parse(json['price_gram_24k'].toString()),
      priceGram22k: double.parse(json['price_gram_22k'].toString()),
      priceGram18k: double.parse(json['price_gram_18k'].toString()),

    );
  }
}
