import 'package:onpensea/Property/Feature-ShowAllDetails/Models/Properties.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onpensea/config/ApiUrl.dart';

class SellerController {
  static Future<String> postTheBuerRequest(
      Properties prop, String tokenRequested, String remarks) async {

    final apiUrl = "${ApiUrl.API_URL_SELLER}seller/sellRequest";

    var url = Uri.parse(apiUrl);

    String msg;

    print('Prop id ${prop.id}');

    Map<String, dynamic> body = {
      "propId": prop.id,
      "propName": prop.propName,
      "sellerId": 'seller1',
      "address": prop.address,
      "sellerName": "TesterSellName",
      "sellerWallerAddress": 'dcnsdjkncskjdcnskcdn',
      "tokenRequested": tokenRequested,
      "tokenPrice": prop.tokenPrice.toString(),
      "tokenId": prop.tokenName,
      "tokenName": prop.tokenName,
      "paymentType": 'Wallet',
      "remarks": remarks
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    var response = await http.post(url,
        //headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
        encoding: encoding);

    print('========  ${response.body}');

    print('at controller  ${response.statusCode} ');
    if (response.statusCode == 202) {
      msg = "Request submitted for Selling Property : ${prop.propName} ";

      return Future.value(msg);
    }

    msg = " ${response.body} ";
    return Future.value(msg);
  }
}
