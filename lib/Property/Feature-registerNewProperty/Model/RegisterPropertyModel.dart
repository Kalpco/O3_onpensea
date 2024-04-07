import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegisterPropertyModel {
  final String propName;
  final String address;
  final String city;
  final String pincode;
  final String state;
  final String propValue;
  final String ownerName;
  final String ownerId;

  final String tokenRequested;
  final String tokenName;
  final String tokenSymbol;
  final String tokenCapacity;
  final String tokenSupply;
  final String tokenBalance;
  final XFile? image1;
  final XFile? image2;
  final XFile? image3;
  final File? saleDeed;
  final String? userName;

  RegisterPropertyModel({
    required this.propName,
    required this.address,
    required this.city,
    required this.pincode,
    required this.state,
    required this.propValue,
    required this.ownerName,
    required this.ownerId,
    required this.tokenRequested,
    required this.tokenName,
    required this.tokenSymbol,
    required this.tokenCapacity,
    required this.tokenSupply,
    required this.tokenBalance,
    required this.image1,
    required this.image2,
    required this.image3,
    required this.saleDeed,
    required this.userName,
  });

  factory RegisterPropertyModel.fromJson(Map<String, dynamic> json) {
    return RegisterPropertyModel(
      propName: json['propName'] ?? 'NA',
      address: json['address'] ?? 'NA',
      city: json['city'] ?? 'NA',
      pincode: json['pincode'] ?? 'NA',
      state: json['state'] ?? 'NA',
      propValue: json['propValue'] ?? 'NA',
      ownerName: json['ownerName'] ?? 'NA',
      ownerId: json['ownerId'] ?? 'NA',
      tokenRequested: json['tokenRequested'] ?? 'NA',
      tokenName: json['tokenName'] ?? 'NA',
      tokenSymbol: json['tokenSymbol'] ?? 'NA',
      tokenCapacity: json['tokenCapacity'] ?? 'NA',
      tokenSupply: json['tokenSupply'] ?? 'NA',
      tokenBalance: json['tokenBalance'] ?? 'NA',
      image1: json['image1'] ?? 'NA',
      image2: json['image2'] ?? 'NA',
      image3: json['image3'] ?? 'NA',
      saleDeed: json['saleDeed'] ?? 'NA',
      userName: json['userName'] ?? 'NA',
    );
  }
  @override
  String toString() {
    return  RegisterPropertyModel.fromJson.toString();
  }
}

