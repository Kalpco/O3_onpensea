import 'last7DaysGoldRateDTO.dart';

class GoldRateEntryDTO {
  final String carat;
  final double todayPrice;
  final double yesterdayPrice;
  List<Last7DaysGoldRateDTO>? last7DaysList;
  List<Last7DaysGoldRateDTO>? monthList;


  GoldRateEntryDTO({
    required this.carat,
    required this.todayPrice,
    required this.yesterdayPrice,
    this.last7DaysList,
    this.monthList,
  });

  factory GoldRateEntryDTO.fromJson(Map<String, dynamic> json) {
    return GoldRateEntryDTO(
      carat: json['carat'],
      todayPrice: double.parse(json['todayPrice'].toString()),
      yesterdayPrice: double.parse(json['yesterdayPrice'].toString()),
      last7DaysList: (json['last7Days'] as List<dynamic>?)
          ?.map((e) => Last7DaysGoldRateDTO.fromJson(e))
          .toList(),
      monthList: (json['monthRates'] as List<dynamic>?)
          ?.map((e) => Last7DaysGoldRateDTO.fromJson(e))
          .toList(),
    );
  }
}
