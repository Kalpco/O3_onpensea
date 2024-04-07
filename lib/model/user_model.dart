class UserModel {
  String name;
  String fatherName;
  String geneder;
  String city;
  String state;
  String email;
  String mobile;
  String aadhar;
  String pan;
  String userType;
  String password;
  String address;
  String profilePic;

  UserModel({required this.name,
    required this.fatherName,
    required this.geneder,
    required this.city,
    required this.state,
    required this.email,
    required this.mobile,
    required this.aadhar,
    required this.pan,
    required this.userType,
    required this.password,
    required this.address,
    required this.profilePic});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      fatherName: map['fatherName'] ?? '',
      geneder: map['geneder'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      email: map['email'] ?? '',
      mobile: map['mobile'] ?? '',
      aadhar: map['aadhar'] ?? '',
      pan: map['pan'] ?? '',
      userType: map['userType'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "fatherName": fatherName,
      "geneder": geneder,
      "city": city,
      "state": state,
      "email": email,
      "mobile": mobile,
      "aadhar": aadhar,
      "pan": pan,
      "userType": userType,
      "password": password,
      "address": address,
      "profilePic": profilePic
    };
  }
}
