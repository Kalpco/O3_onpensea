import 'package:onpensea/Admin/Feature-VerifySell/Models/Properties.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:onpensea/config/ApiUrl.dart';

class PropertyController {
  static Future<List<Properties>> fetchProperties() async {

    String url = "${ApiUrl.API_URL_PROPERTY}prop/getPropPending?status=U";

    final respons = await http.get(
        Uri.parse(url));
    if (respons.statusCode == 200) {
      final List<dynamic> data = json.decode(respons.body);
      print(data);

      return data.map((prop) => Properties.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }
}
