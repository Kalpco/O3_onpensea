import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/config/ApiUrl.dart';

import '../Models/Buyer.dart';

class BuyController {
  static Future<List<Buyer>> getAllBuyRequests() async {
    String url = "${ApiUrl.API_URL_BUYER}buyer/allRequest";
    final List<dynamic> data;
    final respons = await http.get(Uri.parse(url));

    if (respons.statusCode == 204) {
      List<Buyer> b = [];
      return b;
    }

    if (respons.statusCode == 200) {
      List<dynamic> data = json.decode(respons.body);
      print("000000000000000000000000000000000000000000");
      print(data.length);
      print(data);
      return data.map((prop) => Buyer.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Propertiesss');
    }
  }

  ///aprove buy is here
  static Future<String> approveBuyer(
      {required String status,
      required String tokenId,
      required String user,
      required String buyerId,
      required String remark}) async {

    print("buyer id : $buyerId");
    String url =
        "${ApiUrl.API_URL_BUYER}buyer/update?tokenId=$tokenId&status=$status&user=$user&buyerId=$buyerId&remarks=$remark";

    print(url);




    final response = await http.post(Uri.parse(url));
    print(response.body);
    print(response.statusCode);
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      print(response.body);
      return "success";
    } else {
      print("Appprove api is not working");
      return "fail";
    }
  }
}
