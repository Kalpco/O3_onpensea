import 'package:onpensea/features/scheme/Models/ResponseDTO.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SchemeApi {

  Future<ResponseDTO?> getAllSchemes() async {
    var client = http.Client();
    var uri = Uri.parse(
        "http://103.108.12.222:11003/kalpco/v0.01/investments/schemes");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      return responseDTOFromJson(
          const Utf8Decoder().convert(response.bodyBytes));
    }
    return null;
  }

  Future<void> postScheme() async {

  }

}
