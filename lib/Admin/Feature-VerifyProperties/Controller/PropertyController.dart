import 'package:onpensea/Admin/Feature-VerifyProperties/Models/Properties.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../config/ApiUrl.dart';

class PropertyController {
  static Future<List<Properties>> fetchProperties() async {
    String url = "${ApiUrl.API_URL_PROPERTY}prop/getPropPending?status=U";

    final respons = await http.get(Uri.parse(url));

    if (respons.statusCode == 204) {
      List<Properties> b = [];
      return b;
    }

    print(respons.statusCode);

    if (respons.statusCode == 200) {
      final List<dynamic> data = json.decode(respons.body);

      return data.map((prop) => Properties.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }

  ///aprove property is here
  static Future<String> approveProperty(
      String propertyId, String status, String username) async {
    String url =
        "${ApiUrl.API_URL_PROPERTY}prop/update?status=$status&user=$username&remarks=Testing&id=$propertyId";

    print("at admin property: username: $username");

    final response = await http.post(Uri.parse(url));
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      print(response.body);
      return "success";
    } else {
      print("Appprove api is not working");
      return "fail";
    }
  }
}
