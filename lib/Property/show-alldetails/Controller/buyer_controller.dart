import 'dart:convert';

import '../../../config/ApiUrl.dart';
import '../Models/buyermodel.dart';
import 'package:http/http.dart' as http;

class BuyerController {
  static Future<List<Buyer>> getAllboughtProperties(String username) async {
    String url =
        "${ApiUrl.API_URL_BUYER}buyer/getBuyerDetailsProperty?userName=Pulkit Singh";
    final List<dynamic> data;
    final respons = await http.get(Uri.parse(url));

    if (respons.statusCode == 204) {
      List<Buyer> b = [];
      return b;
    }
    print(respons.statusCode);
    if (respons.statusCode >= 200 || respons.statusCode <= 300) {
      List<dynamic> data = json.decode(respons.body);
      print("000000000000000000000000000000000000000000");

      print(data.length);
      print(data);
      return data.map((prop) => Buyer.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }
}
