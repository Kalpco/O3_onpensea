import 'dart:async';
import 'dart:convert';

import 'package:onpensea/UserManagement/Feature-Dashboard/Model/UserDetailsBean.dart';
import 'package:onpensea/config/ApiUrl.dart';
import 'package:http/http.dart' as http;
import '../Model/AllDetails.dart';
import '../Model/deatils.dart';

class DashboardController {
  static Future<AllDetails> getUserDetailsBasedOnEmail(String email) async {
    String? username;
    try {
      var response = await http.get(Uri.parse(
          '${ApiUrl.API_URL_USERMANAGEMENT}user/getUserDetailsByEmail?emailId=$email'));
      print(response.body);
      if (response.statusCode >= 200 || response.statusCode <= 300) {
        final List<dynamic> data = json.decode(response.body);
        print("============================================================");
        print("userdetails: ${data.first.runtimeType}");
        return Future.value(AllDetails.fromJson(data.first));
      } else {
        return Future.error(
            "This is the error ", StackTrace.fromString("This is its trace"));
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<List<Deatils>> fetchDetails(String name) async {
    final response = await http.get(Uri.parse(
        '${ApiUrl.API_URL_USERMANAGEMENT}user/getCountDetails?userId=$name&status=V'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print("============================================================");
      print(data);

      return data.map((detail) => Deatils.fromJson(detail)).toList();
    } else {
      throw ('Failed to Load details');
    }
  }
//
// static Future<List<recentTransaction>> fetchTransactions(String name) async {
//   final respons = await http.get(Uri.parse(
//       'http://45.118.162.234:11000/user/getTxnDetails?userId=$name'));
//   if (respons.statusCode == 200) {
//     final List<dynamic> data = json.decode(respons.body);
//     print("============================================================");
//     print(data);
//
//     return data.map((deaf) => recentTransaction.fromJson(deaf)).toList();
//   } else {
//     throw ('Failed to Load details');
//   }
// }
}
