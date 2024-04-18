class AllDetails {
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
  final String sessionId;
  final String accessToken;
  final int power;
  final String remarks;
  final String password;
  final String? photo;
  final String? verificationDate;
  final String? kycStatus;

  AllDetails(
      {required this.id,
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
      required this.sessionId,
      required this.accessToken,
      required this.power,
      required this.remarks,
      required this.password,
      required this.photo,
      required this.verificationDate,
      required this.kycStatus});

  factory AllDetails.fromJson(Map<String, dynamic> json) {
    return AllDetails(
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
        sessionId: json['sessionId'] ?? 'NA',
        accessToken: json['accessToken'] ?? 'NA',
        power: json['power'] ?? 'NA',
        remarks: json['remarks'] ?? 'NA',
        password: json['password'] ?? 'NA',
        photo: json['photo'] ?? 'NA',
        verificationDate: json['verificationDate'] ?? 'NA',
        kycStatus: json['kycStatus'] ?? "NA");
  }

  Map<String, dynamic> toJson() => {
        'id': id,
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
        'session': sessionId,
        'accessToken': accessToken,
        'power': power,
        'remarks': remarks,
        'password': password,
      };

  @override
  String toString() {
    return toJson().toString();
  }
}
