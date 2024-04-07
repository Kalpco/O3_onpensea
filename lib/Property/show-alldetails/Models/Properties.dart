class Properties {
  final String id;
  final String propName;
  final String address;
  final String city;
  final String pinCode;
  final String state;
  final double propValue;
  final String ownerName;
  final String ownerId;
  final int tokenRequested;
  final String tokenName;
  final String tokenSymbol;
  final int tokenCap;
  final int tokenSupply;
  final int tokenBalance;
  final String propRegisteredDate;
  final String propOnO3CreatedDate;
  final String delFlg;
  final String status;
  final String verifiedBy;
  final String verifiedDate;
  final String docSaleDeed;
  final String propDoc1;
  final String propDoc2;
  final String propDoc3;
  final String propDoc4;
  final String propImage1;
  final String propImage2;
  final String propImage3;
  final String propImage4;
  final String propImage5;
  final String propImage1Byte;
  final String propImage2Byte;
  final String propImage3Byte;
  final String propImage4Byte;
  final String propImage5Byte;
  final String remakrs;

  final double tokenPrice;


  Properties({required this.id,
    required this.propName,
    required this.address,
    required this.city,
    required this.pinCode,
    required this.state,
    required this.propValue,
    required this.ownerName,
    required this.ownerId,
    required this.tokenRequested,
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenCap,
    required this.tokenSupply,
    required this.tokenBalance,
    required this.propRegisteredDate,
    required this.propOnO3CreatedDate,
    required this.delFlg,
    required this.status,
    required this.verifiedBy,
    required this.verifiedDate,
    required this.docSaleDeed,
    required this.propDoc1,
    required this.propDoc2,
    required this.propDoc3,
    required this.propDoc4,
    required this.propImage1,
    required this.propImage2,
    required this.propImage3,
    required this.propImage4,
    required this.propImage5,

    required this.propImage1Byte,
    required this.propImage2Byte,
    required this.propImage3Byte,
    required this.propImage4Byte,
    required this.propImage5Byte,
    required this.remakrs,
    required this.tokenPrice,

  });

  factory Properties.fromJson(Map<String, dynamic> json) {

    return Properties(


      id: json['id'] ?? 'NA',
      propName: json['propName'] ?? 'NA',
      address: json['address'] ?? 'NA',
      city: json['city'] ?? 'NA',
      pinCode: json['pinCode'] ?? 'NA',
      state: json['state'] ?? 'NA',
      propValue: json['propValue'] ?? 'NA',
      ownerName: json['ownerName'] ?? 'NA',
      ownerId: json['ownerId'] ?? 'NA',
      tokenRequested: json['tokenRequested'] ?? 'NA',
      tokenName: json['tokenName'] ?? 'NA',
      tokenSymbol: json['tokenSymbol'] ?? 'NA',
      tokenCap: json['tokenCap'] ?? 'NA',
      tokenSupply: json['tokenSupply'] ?? 'NA',
      tokenBalance: json['tokenBalance'] ?? 'NA',
      propRegisteredDate: json['propRegisteredDate'] ?? 'NA',
      propOnO3CreatedDate: json['propOnO3CreatedDate'] ?? 'NA',
      delFlg: json[' delFlg'] ?? 'NA',
      status: json['status'] ?? 'NA',
      verifiedBy: json['verifiedBy'] ?? 'NA',
      verifiedDate: json['verifiedDate'] ?? 'NA',
      docSaleDeed: json['docSaleDeed'] ?? 'NA',
      propDoc1: json['propDoc1'] ?? 'NA',
      propDoc2: json['propDoc2'] ?? 'NA',
      propDoc3: json['propDoc3'] ?? 'NA',
      propDoc4: json['propDoc4'] ?? 'NA',
      propImage1: json['propImage1'] ?? 'NA',
      propImage2: json['propImage2'] ?? 'NA',
      propImage3: json['propImage3'] ?? 'NA',
      propImage4: json['propImage4'] ?? 'NA',
      propImage5: json['propImage5'] ?? 'NA',
      propImage1Byte: json['propImage1Byte'] ?? 'NA',
      propImage2Byte: json['propImage2Byte'] ?? 'NA',
      propImage3Byte: json['propImage3Byte'] ?? 'NA',
      propImage4Byte: json['propImage4Byte'] ?? 'NA',
      propImage5Byte: json['propImage5Byte'] ?? 'NA',
      remakrs: json['remarks'] ?? 'NA',
      tokenPrice: json['tokenPrice'] ?? "NA",
    );
  }


}
