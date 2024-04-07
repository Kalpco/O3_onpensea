import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onpensea/Property/Feature-registerNewProperty/Model/RegisterPropertyModel.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/config/ApiUrl.dart';

class RegisterPropertyController {
  static Future<String> registerProperty(RegisterPropertyModel rpm) async {
    String isPropertyRegistered = "false";

    print("in");

    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse("${ApiUrl.API_URL_PROPERTY}prop/register"));

      request.fields['propName'] = rpm.propName;
      request.fields['address'] = rpm.address;
      request.fields['city'] = rpm.city;
      request.fields['pinCode'] = rpm.pincode;
      request.fields['state'] = rpm.state;
      request.fields['propValue'] = rpm.propValue;
      request.fields['ownerName'] = rpm.ownerName;
      request.fields['ownerId'] = rpm.ownerId;

      request.fields['tokenRequested'] = rpm.tokenRequested;
      request.fields['tokenName'] = rpm.tokenName;
      request.fields['tokenSymbol'] = rpm.tokenSymbol;
      request.fields['tokenCap'] = rpm.tokenCapacity;
      request.fields['tokenSupply'] = rpm.tokenSupply;
      request.fields['tokenBalance'] = rpm.tokenBalance;
      request.fields['userName'] = rpm.userName!;
      request.files
          .add(await http.MultipartFile.fromPath('image1', rpm.image1!.path));
      request.files
          .add(await http.MultipartFile.fromPath('image2', rpm.image2!.path));
      request.files
          .add(await http.MultipartFile.fromPath('image3', rpm.image3!.path));
      request.files.add(
          await http.MultipartFile.fromPath('saleDeed', rpm.saleDeed!.path));

      var res = await request.send();
      final respStr = await res.stream.bytesToString();

      print("adityaaaaaa000000000000000000000000");
      print(respStr);
      print(res.statusCode);

      if (res.statusCode == 400) {
        return "false";
      }

      if (res.statusCode >= 200 || res.statusCode <= 300) {
        String paymentResponse = await isPaymentDone(rpm);
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

  static Future<String> isPaymentDone(RegisterPropertyModel rpm) async {
    try {
      print(
          "tokenPrice: ${double.parse(rpm.propValue) / double.parse(rpm.tokenRequested)}");
      print(
          "totalAmount : ${(double.parse(rpm.propValue) / double.parse(rpm.tokenRequested)) + 20.0}");
      final dio = Dio();

      var formData = FormData.fromMap({
        'userID': "${rpm.userName}",
        'userName': "${rpm.userName}",
        'propName': rpm.propName,
        'tokenName': rpm.tokenName,
        'tokenPrice':
            (double.parse(rpm.propValue) / double.parse(rpm.tokenRequested))
                .round()
                .toString(),
        'totalAmount':
            ((double.parse(rpm.propValue) / double.parse(rpm.tokenRequested)) +
                    20.0)
                .round()
                .toString(),
        'rtgsId': "RTGSID2023",
        'neftId': "NEFTID2023",
        'upiId': "UPIID2023",
        'netBankId': "NETBANKINGID2023",
        'bankName': "IDBI BANK",
        'tokenCount': rpm.tokenRequested,
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
