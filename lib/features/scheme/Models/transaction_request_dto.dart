
import 'dart:convert';

TransactionResponseDTO transactionResponseDTOFromJson(String str) => TransactionResponseDTO.fromJson(json.decode(str));

String transactionResponseDTOToJson(TransactionResponseDTO data) => json.encode(data.toJson());

class TransactionResponseDTO {
  int status;
  String message;
  Data data;

  TransactionResponseDTO({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TransactionResponseDTO.fromJson(Map<String, dynamic> json) => TransactionResponseDTO(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int transactionId;

  Data({
    required this.transactionId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    transactionId: json["transactionId"],
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
  };
}