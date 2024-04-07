import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:onpensea/Admin/Feature-VerifySell/Models/Seller.dart';

import '../../../config/ApiUrl.dart';

class SellerController {
  static Future<List<Seller>> getAllBuyRequests() async {
    String url = "${ApiUrl.API_URL_SELLER}seller/getPropPending?status=U";

    final List<dynamic> data;
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 204) {
      List<Seller> b = [];
      return b;
    }

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(data.length);
      return data.map((prop) => Seller.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }

  ///aprove sell is here
  static Future<String> approveSeller(
      {required String status,
      required String propId,
      required String user,
      required String sellerId,
      required String remark}) async {
print("seller id: $sellerId");
    String url =
        "${ApiUrl.API_URL_SELLER}seller/update?propId=$propId&status=$status&user=$user&sellerId=$sellerId&remarks=$remark";

    final response = await http.post(Uri.parse(url));

    if (response.statusCode >= 200 && response.statusCode <= 300) {
      return "success";
    } else {
      print("Appprove api is not working");
      return "fail";
    }
  }
}
