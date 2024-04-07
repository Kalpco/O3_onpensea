import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:onpensea/config/ApiUrl.dart';

import '../../../Admin/Feature-VerifyBuy/Models/Buyer.dart';
import '../../../UserManagement/Feature-ApplyForTokens/Models/Properties.dart';

class TokenController {
  static Future<List<Properties>> fetchPropertiesToken() async {
    String url =
        "${ApiUrl.API_URL_PROPERTY}prop/getPropPendingFinal?userId=ADMIN";

    final List<dynamic> data;
    final respons = await http.get(Uri.parse(url));

    if (respons.statusCode == 204) {
      List<Properties> b = [];
      return b;
    }

    if (respons.statusCode == 200) {
      final List<dynamic> data = json.decode(respons.body);
      print(data);

      return data.map((prop) => Properties.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }

  ///aprove buy is here
  static Future<String> approveBuyer(
      {required Properties props,
      required String noOfBlock,
      required String userId,
      required String smartContractAddress, required String username}) async {
    String url = "${ApiUrl.API_URL_TOKEN}token/postTokens";

    print("at token property: username: $username");

    var json = {
      "userId": username,
      "tokenName": props.tokenName,
      "tokenSymbol": props.tokenSymbol,
      "tokenCap": props.tokenCap.toString(),
      "tokenSupply": props.tokenSupply.toString(),
      "tokenBalance": props.tokenBalance.toString(),
      "propName": props.propName,
      "propId": props.id,
      "propOwnerName": props.ownerName,
      "smartContarctAddress": smartContractAddress,
      "noOfBlock": noOfBlock,
      "tokenPrice": props.tokenPrice.toString(),
    };
    var formData = FormData.fromMap(json);

    final dio = Dio();
    final response = await dio.post(
      url,
      data: formData,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data);
      return "success";
    } else {
      print("Api not working");
      return "fail";
    }
  }
}
