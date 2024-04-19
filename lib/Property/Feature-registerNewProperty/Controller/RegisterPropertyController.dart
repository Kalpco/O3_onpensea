import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onpensea/Property/Feature-registerNewProperty/Model/RegisterPropertyModel.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/config/ApiUrl.dart';

class RegisterPropertyController {
  static Future<String> registerProperty(
    String propName,
    String address,
    String city,
    String pincode,
    String state,
    String propValue,
    String ownerName,
    String ownerId,
    String tokenRequested,
    String tokenName,
    String tokenSymbol,
    String tokenCapacity,
    String tokenSupply,
    String tokenBalance,
    XFile? image1,
    XFile? image2,
    XFile? image3,
    File? saleDeed,
    String? userName,
  ) async {
    String isPropertyRegistered = "false";

    print("in");

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("${ApiUrl.API_URL_PROPERTY}prop/register"));

      request.fields['propName'] = propName;
      request.fields['address'] = address;
      request.fields['city'] = city;
      request.fields['pinCode'] = pincode;
      request.fields['state'] = state;
      request.fields['propValue'] = propValue;
      request.fields['ownerName'] = ownerName;
      request.fields['ownerId'] = ownerId;

      request.fields['tokenRequested'] = tokenRequested;
      request.fields['tokenName'] = tokenName;
      request.fields['tokenSymbol'] = tokenSymbol;
      request.fields['tokenCap'] = tokenCapacity;
      request.fields['tokenSupply'] = tokenSupply;
      request.fields['tokenBalance'] = tokenBalance;
      request.fields['userName'] = userName!;
      request.files
          .add(await http.MultipartFile.fromPath('image1', image1!.path));
      request.files
          .add(await http.MultipartFile.fromPath('image2', image2!.path));
      request.files
          .add(await http.MultipartFile.fromPath('image3', image3!.path));
      request.files
          .add(await http.MultipartFile.fromPath('saleDeed', saleDeed!.path));

      var res = await request.send();
      final respStr = await res.stream.bytesToString();

      print("adityaaaaaa000000000000000000000000");
      print(respStr);
      print(res.statusCode);

      if (res.statusCode == 400) {
        return "false";
      }

      if (res.statusCode >= 200 || res.statusCode <= 300) {
        String paymentResponse = await isPaymentDone(
            propName,
            address,
            city,
            pincode,
            state,
            propValue,
            ownerName,
            ownerId,
            tokenRequested,
            tokenName,
            tokenSymbol,
            tokenCapacity,
            tokenSupply,
            tokenBalance,
            image1,
            image2,
            image3,
            saleDeed,
            userName);
        if (paymentResponse == "true") {
          isPropertyRegistered = "true";
        }
        return isPropertyRegistered;
      }
    } catch (e) {
      print("error message: $e");
    }
    return isPropertyRegistered;
  }

  static Future<String> isPaymentDone(
    String propName,
    String address,
    String city,
    String pincode,
    String state,
    String propValue,
    String ownerName,
    String ownerId,
    String tokenRequested,
    String tokenName,
    String tokenSymbol,
    String tokenCapacity,
    String tokenSupply,
    String tokenBalance,
    XFile? image1,
    XFile? image2,
    XFile? image3,
    File? saleDeed,
    String? userName,
  ) async {
    try {
      print(
          "tokenPrice: ${double.parse(propValue) / double.parse(tokenRequested)}");
      print(
          "totalAmount : ${(double.parse(propValue) / double.parse(tokenRequested)) + 20.0}");
      final dio = Dio();

      var formData = FormData.fromMap({
        'userID': "${userName}",
        'userName': "${userName}",
        'propName': propName,
        'tokenName': tokenName,
        'tokenPrice': (double.parse(propValue) / double.parse(tokenRequested))
            .round()
            .toString(),
        'totalAmount':
            ((double.parse(propValue) / double.parse(tokenRequested)) + 20.0)
                .round()
                .toString(),
        'rtgsId': "RTGSID2023",
        'neftId': "NEFTID2023",
        'upiId': "UPIID2023",
        'netBankId': "NETBANKINGID2023",
        'bankName': "IDBI BANK",
        'tokenCount': tokenRequested,
        'discount': "20",
        'offerApplied': "N",
        "paymentType": "Net banking",
      });
      final response = await dio.post(
        "${ApiUrl.API_URL_TOKEN}propdtd/postPayment",
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: formData,
      );

      if (response.statusCode! >= 400) {
        return "false";
      }

      if (response.statusCode! >= 200 || response.statusCode! <= 300) {
        return "true";
      }
    } catch (e) {
      print("$e");
    }
    return "false";
  }
}
