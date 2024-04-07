import 'package:onpensea/Admin/Feature-VerifyProperties/Models/Properties.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

///http://45.118.162.234:11003/prop/update?status=V&user=Abhishek&remarks=Testing&id=O3-Prop-30
class PropertyController {
  static Future<List<Properties>> fetchProperties() async {

    final respons = await http.get(
        Uri.parse('http://45.118.162.234:11003/prop/getPropPending?status=U'));

    if (respons.statusCode == 200) {
      final List<dynamic> data = json.decode(respons.body);
      print(data);

      return data.map((prop) => Properties.fromJson(prop)).toList();
    } else {
      return throw ('Failed to Load Properties');
    }
  }

  ///aprove property is here
  static Future<String> approveProperty(String propertyId) async {
    print("999999999999999999999999999999999999999999999999object");
    print("propertyId: " + propertyId);
    final response = await http.post(Uri.parse(
        'http://45.118.162.234:11003/prop/update?status=V&user=Abhishek&remarks=Testing&id=$propertyId'));
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      print(response.body);
      return "success";
    } else {
      print("Appprove api is not working");
      return "fail";
    }
  }
}
