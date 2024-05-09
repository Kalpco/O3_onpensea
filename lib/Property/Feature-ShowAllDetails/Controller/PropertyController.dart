import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:onpensea/Admin/Feature-VerifyBuy/Models/Buyer.dart';
import 'package:onpensea/Property/Feature-ShowAllDetails/Models/Properties.dart';
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
    print("in buy property.....................");
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

  static Future<String> postTheSellerRequest(Properties prop, String username,
      String userId, String tokenRequested, String remarks) async {
    String isTokenBuySubmitted = "false";
    try {
      final apiUrl = "${ApiUrl.API_URL_SELLER}seller/sellRequest";
      var url = Uri.parse(apiUrl);
      Map<String, dynamic> body = {
        "propId": prop.id,
        "propName": prop.propName,
        "sellerId": userId,
        "address": prop.address,
        "sellerName": username,
        "sellerWallerAddress": 'dcnsdjkncskjdcnskcdn',
        "tokenRequested": tokenRequested,
        "tokenPrice": prop.tokenPrice.toString(),
        "tokenId": prop.tokenName,
        "tokenName": prop.tokenName,
        "paymentType": 'Wallet',
        "remarks": remarks,
      };

      print("-----------------------------------------------");
      print(body.toString());
      print("-----------------------------------------------");

      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      var response = await http.post(url,
          //headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: body,
          encoding: encoding);

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



  static Future<List<Buyer>> fetchAllBuyPropertiesOfUser() async {
    final url = "${ApiUrl.API_URL_BUYER}buyer/getBuyerDetailsProperty?username=Pulkit Singh";

    final respons = await http.get(Uri.parse(url));
    if (respons.statusCode >= 200 || respons.statusCode <=300) {
      final List<dynamic> data = json.decode(respons.body);
      print('buyerrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      debugPrint(data[0].toString());
      debugPrint(data[1].toString());
      debugPrint(data[2].toString());

      return data.map((prop) => Buyer.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }

}
