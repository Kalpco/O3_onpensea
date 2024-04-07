import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onpensea/Property/show-alldetails/Models/buyermodel.dart';
import 'package:onpensea/Property/show-alldetails//Models/Properties.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onpensea/config/ApiUrl.dart';

class PropertyController {
  static Future<List<Properties>> fetchProperties() async {
    final url = "${ApiUrl.API_URL_PROPERTY}prop/getPropPending?status=V";

    final respons = await http.get(Uri.parse(url));
    if (respons.statusCode == 200) {
      final List<dynamic> data = json.decode(respons.body);
      print(data);

      return data.map((prop) => Properties.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }

  static Future<String> postTheBuyerRequest(Properties prop, String username,
      String userId, String tokenRequested, String remarks) async {
    String isBuyerRequestSaved = "false";
    print("==============================================================");
    print("in buy property....................");
    print("username: $username | userId: $userId");
    try {
      final urlApi = "${ApiUrl.API_URL_BUYER}buyer/buyRequest";
      var url = Uri.parse(urlApi);

      Map<String, dynamic> body = {
        "propId": prop.id,
        "propName": prop.propName,
        "buyerId": userId,
        "address": prop.address,
        "buyerName": username,
        "buyerWalletAddress": 'dcnsdjkncskjdcnskcdn',
        "tokenRequested": tokenRequested,
        "tokenId": prop.tokenName,
        "tokenName": prop.tokenName,
        "paymentType": 'Wallet',
        "remarks": remarks,
        "tokenPrice": prop.tokenPrice.toString(),
      };

      print("-----------------------------------------------");
      print(body.toString());
      print("-----------------------------------------------");

      final encoding = Encoding.getByName('utf-8');

      var response = await http.post(url,
          //headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: body,
          encoding: encoding);

      if (response.statusCode >= 400) {
        isBuyerRequestSaved = "false";
        return Future.value(isBuyerRequestSaved);
      }
      if (response.statusCode >= 200 || response.statusCode <= 300) {
        String paymentResponse = await isPaymentDoneForBuy(
            prop, username, userId, tokenRequested, remarks);
        if (paymentResponse == "true") {
          isBuyerRequestSaved = "true";
        }
        return isBuyerRequestSaved;
      }
    } catch (e) {
      print("$e");
    }
    return Future.value(isBuyerRequestSaved);
  }

  static Future<String> postTheSellerRequest(Buyer prop, String username,
      String userId, String tokenRequested, String remarks, String imagePath, String walletaddress, String tokenPrice) async {
    String isTokenBuySubmitted = "false";
    try {
      final apiUrl = "${ApiUrl.API_URL_SELLER}seller/sellRequest";
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      print("token000000000000000000000000000000000000000000000000000");
      print("token price: ${prop.tokenPrice}");

      print("sahi token price: $tokenPrice");
      print("sahi propid: ${prop.id}");

      request.fields['propId'] = prop.propId! ?? "NA";
      request.fields['propName'] = prop.propName;
      request.fields['sellerId'] = userId;
      request.fields['address'] =  prop.address;
      request.fields['sellerName'] = username;
      request.fields['sellerWallerAddress'] = walletaddress;
      request.fields['tokenRequested'] = tokenRequested;
      request.fields['tokenPrice'] = tokenPrice;
      request.fields['tokenId'] = prop.tokenName;
      request.fields['tokenName'] = prop.tokenName;
      request.fields['paymentType'] =  'Wallet';
      request.fields['remarks'] = remarks;

      request.files
          .add(await http.MultipartFile.fromPath('screenshot', imagePath));

      var response = await request.send();
      final respStr = await response.stream.bytesToString();

      print(respStr);
      print(response.statusCode);

      if (response.statusCode >= 400) {
        isTokenBuySubmitted = "false";
        return Future.value(isTokenBuySubmitted);
      }

      if (response.statusCode >= 200 || response.statusCode <= 300) {
        isTokenBuySubmitted = "true";
        print(isTokenBuySubmitted);
        return Future.value(isTokenBuySubmitted);
      }

    } catch (e) {
      print("$e");
    }
    return Future.value(isTokenBuySubmitted);
  }

  static Future<String> isPaymentDoneForBuy(Properties prop, String username,
      String userId, String tokenRequested, String remarks) async {
    try {
      final dio = Dio();

      var formData = FormData.fromMap({
        'paymentType': "Phonepay",
        'paymentId': "paymentId123",
        'buyerId': "buyerId123",
        'buyerName': username,
        'propName': prop.propName,
        'tokenId': prop.id,
        'tokenName': prop.tokenName,
        'tokenPrice': prop.tokenPrice,
        'totalAmount':
            (prop.propValue / double.parse(tokenRequested)).round().toString(),
        'tokenCount': tokenRequested,
        'rtgsId': "RTGSID123",
        'neftId': "NEFTID123",
        'upiId': "UPIID123",
        'netBankId': "NETBANK123",
        'bankName': "IDBI BANK",
        'offerApplied': "NA",
        'discount': "20",
        'remarks': remarks,
        'propId': prop.id,
      });

      final response = await dio.post(
        "${ApiUrl.API_URL_TOKEN}buyDtd/postPayment",
        data: formData,
      );

      print(response.data);

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
