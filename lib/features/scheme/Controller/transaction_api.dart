import 'package:http/http.dart' as http;
import 'package:onpensea/features/scheme/Models/transaction_dto.dart';
import 'dart:convert';

import '../Models/transaction_request_dto.dart';

class TransactionApi {
  Future<TransactionResponseDTO?> post(TransactionDto transactionDto) async {
    var client = http.Client();
    var uri = Uri.parse(
        "http://103.108.12.222:11001/kalpco/v0.01/investments/schemes");
    var response = await client.get(uri);

    if (response.statusCode == 200) {
      return transactionResponseDTOFromJson(
          const Utf8Decoder().convert(response.bodyBytes));
    }
    return null;
  }
}
