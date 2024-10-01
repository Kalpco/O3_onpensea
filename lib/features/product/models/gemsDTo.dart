class GemsDTO {
  int? noOfSmallStones;
  double? weightOfSmallStones;
  double? priceOfSmallStones;
  int? noOfSolitareDiamond;
  double? weightOfSolitareDiamond;
  double? priceOfSolitare;
  String? clarityOfSolitareDiamond;
  String? typeOfStone;

  GemsDTO({
    this.noOfSmallStones,
    this.weightOfSmallStones,
    this.priceOfSmallStones,
    this.noOfSolitareDiamond,
    this.weightOfSolitareDiamond,
    this.priceOfSolitare,
    this.clarityOfSolitareDiamond,
    this.typeOfStone,
  });

  factory GemsDTO.fromJson(Map<String, dynamic> json) => GemsDTO(
    noOfSmallStones: json["noOfSmallStones"],
    weightOfSmallStones: json["weightOfSmallStones"]?.toDouble(),
    priceOfSmallStones: json["priceOfSmallStones"]?.toDouble(),
    noOfSolitareDiamond: json["noOfSolitareDiamond"],
    weightOfSolitareDiamond: json["weightOfSolitareDiamond"]?.toDouble(),
    priceOfSolitare: json["priceOfSolitare"]?.toDouble(),
    clarityOfSolitareDiamond: json["clarityOfSolitareDiamond"],
    typeOfStone: json["typeOfStone"],
  );

  Map<String, dynamic> toJson() => {
    "noOfSmallStones": noOfSmallStones,
    "weightOfSmallStones": weightOfSmallStones,
    "priceOfSmallStones": priceOfSmallStones,
    "noOfSolitareDiamond": noOfSolitareDiamond,
    "weightOfSolitareDiamond": weightOfSolitareDiamond,
    "priceOfSolitare": priceOfSolitare,
    "clarityOfSolitareDiamond": clarityOfSolitareDiamond,
    "typeOfStone": typeOfStone,
  };
}
