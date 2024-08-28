
class GemsDTO {
   int? noOfSmallStones;
   double? weightOfSmallStones;
   int? noOfSolitareDiamond;
   int? weightOfSolitareDiamond;
   String? clarityOfSolitareDiamond;
   String typeOfStone;
   double? priceOfSmallStones;
   double? priceOfSolitare;

  GemsDTO({
    this.noOfSmallStones,
    this.weightOfSmallStones,
    this.noOfSolitareDiamond,
    this.weightOfSolitareDiamond,
    this.clarityOfSolitareDiamond,
    required this.typeOfStone,
    this.priceOfSmallStones,
    this.priceOfSolitare,
  });

   factory GemsDTO.fromJson(Map<String, dynamic> json) => GemsDTO(
     noOfSmallStones: json["noOfSmallStones"],
     weightOfSmallStones: json["weightOfSmallStones"]?.toDouble(),
     noOfSolitareDiamond: json["noOfSolitareDiamond"],
     weightOfSolitareDiamond: (json["weightOfSolitareDiamond"] as num?)?.toInt(),
     clarityOfSolitareDiamond: json["clarityOfSolitareDiamond"],
     typeOfStone: json["typeOfStone"],
     priceOfSmallStones: json["priceOfSmallStones"]?.toDouble(),
     priceOfSolitare: json["priceOfSolitare"]?.toDouble(),

   );

  Map<String, dynamic> toJson() => {
    "noOfSmallStones": noOfSmallStones,
    "weightOfSmallStones": weightOfSmallStones,
    "noOfSolitareDiamond": noOfSolitareDiamond,
    "weightOfSolitareDiamond": weightOfSolitareDiamond,
    "clarityOfSolitareDiamond": clarityOfSolitareDiamond,
    "typeOfStone": typeOfStone,
    "priceOfSmallStones" :priceOfSmallStones,
    "priceOfSolitare":priceOfSolitare,
    };
}