class UserDetailsBean {
  final String id;
  final String name;
  final String fatherName;
  final String geneder;
  final String city;
  final String state;
  final String address;
  final String email;
  final String mobileNo;
  final int aadharNo;
  final String panNo;
  final String walletAddress;
  final String userType;
  final String createdDate;
  final String delFlg;
  final String session;
  final String accessToken;
  final int power;
  final String remarks;
  final String password;
  final int totalBuyCount;
  final int totalSellCount;
  final int totalPropCount;
  final int totalTokeHoldigs;
  final double totalTokenPrice;
  final String propName;
  final String type;
  final String status;

  UserDetailsBean({
    required this.id,
    required this.name,
    required this.fatherName,
    required this.geneder,
    required this.city,
    required this.state,
    required this.address,
    required this.email,
    required this.mobileNo,
    required this.aadharNo,
    required this.panNo,
    required this.walletAddress,
    required this.userType,
    required this.createdDate,
    required this.delFlg,
    required this.session,
    required this.accessToken,
    required this.power,
    required this.remarks,
    required this.password,
    required this.totalBuyCount,
    required this.totalSellCount,
    required this.totalPropCount,
    required this.totalTokeHoldigs,
    required this.totalTokenPrice,
    required this.propName,
    required this.type,
    required this.status,
  });

  factory UserDetailsBean.fromJson(Map<String, dynamic> json) {
    return UserDetailsBean(
      id: json['id'] ?? 'NA',
      name: json['name'] ?? 'NA',
      fatherName: json['fatherName'] ?? 'NA',
      geneder: json['geneder'] ?? 'NA',
      city: json['city'] ?? 'NA',
      state: json['state'] ?? 'NA',
      address: json['address'] ?? 'NA',
      email: json['email'] ?? 'NA',
      mobileNo: json['mobileNo'] ?? 'NA',
      aadharNo: json['aadharNo'] ?? 'NA',
      panNo: json['panNo'] ?? 'NA',
      walletAddress: json['walletAddress'] ?? 'NA',
      userType: json['userType'] ?? 'NA',
      createdDate: json['createdDate'] ?? 'NA',
      delFlg: json['delFlg'] ?? 'NA',
      session: json['session'] ?? 'NA',
      accessToken: json['accessToken'] ?? 'NA',
      power: json['power'] ?? 'NA',
      remarks: json['remarks'] ?? 'NA',
      password: json['password'] ?? 'NA',
      totalBuyCount: json["totalBuyCount"] ?? "NA",
      totalPropCount: json["totalPropCount"] ?? "NA",
      totalSellCount: json["totalSellCount"] ?? "NA",
      totalTokeHoldigs: json["totalTokeHoldigs"] ?? "NA",
      totalTokenPrice: json["totalTokenPrice"] ?? "NA",
      propName: json['propName'] ?? 'NA',
      type: json['type'] ?? 'NA',
      status: json['status'] ?? 'NA',
    );
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name': name,
    'fatherName': fatherName,
    'geneder': geneder,
   'city': city,
    'state': state,
   'address': address,
    'email': email,
    'mobileNo': mobileNo,
    'aadharNo': aadharNo,
    'panNo': panNo,
    'walletAddress': walletAddress,
    'userType': userType,
    'createdDate': createdDate,
    'delFlg': delFlg,
    'session': session,
    'accessToken': accessToken,
    'power': power,
    'remarks': remarks,
    'password': password,
    "totalBuyCount": totalBuyCount,
    "totalPropCount": totalPropCount,
    "totalSellCount": totalSellCount,
    "totalTokeHoldigs": totalTokeHoldigs,
    "totalTokenPrice": totalTokenPrice,
    'propName': propName,
    'type': type,
    'status': status,
  };
}
