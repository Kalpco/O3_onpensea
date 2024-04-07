import 'dart:convert';

import 'package:flutter/cupertino.dart';

import '../../config/ApiUrl.dart';
import '../Model/TokenPriceModel.dart';
import 'package:http/http.dart' as http;

class TokenPriceController {


  static Future<List<TokenPriceModel>> fetchAllTokens() async {


    String url = "${ApiUrl.API_URL_GETTOKENPRICE}token/getTokenPrices";
    final respons = await http.get(Uri.parse(url));

    if (respons.statusCode == 200) {
      final List<dynamic> data = json.decode(respons.body);
      List<TokenPriceModel> lst = data.map((prop) => TokenPriceModel.fromJson(prop)).toList().cast<TokenPriceModel>();
      return lst;
    } else {
      return throw ('Failed to Load Tokens list');
    }
  }
}
