import 'package:onpensea/Property/Feature-ShowAllDetails/Models/Properties.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onpensea/config/ApiUrl.dart';

class BuyerController {
  static Future<String> postTheBuerRequest(
      Properties prop, String tokenRequested, String remarks)  async {

    final urlApi = "${ApiUrl.API_URL_BUYER}buyer/buyRequest";

    var url = Uri.parse(urlApi);

    String msg;

    print('Prop id ${prop.id}');


    Map<String,dynamic> body = {
      "propId": prop.id,
      "propName": prop.propName,
      "buyerId": 'Buyer1',
      "address": prop.address,
      "buyerName": "ByerName",
      "buyerWalletAddress": 'dcnsdjkncskjdcnskcdn',
     "tokenRequested": tokenRequested,
      //"tokenRequested": "100",
      "tokenId": prop.tokenName,
      "tokenName": prop.tokenName,
      "paymentType": 'Wallet',
      "remarks": remarks,
      "tokenPrice": prop.tokenPrice.toString(),
    };
    String jsonBody = json.encode(body);
    final encoding = Encoding.getByName('utf-8');

    var response = await http.post(url,
        //headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: body,
      encoding: encoding

    );


    print('========  ${response.body}');

    print('at controller  ${response.statusCode} ');
    if (response.statusCode == 202) {
      msg = "Request submitted for Buying Property : ${prop.propName}  ";

      return Future.value(msg);
    }

    msg = " ${response.body} ";
    return Future.value(msg);
  }
}
