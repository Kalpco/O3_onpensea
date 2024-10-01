import 'dart:convert';

class ResponseDTO {
  final int code;
  final String message;
  final dynamic data;
  final DateTime timeStamp;

  ResponseDTO({
    required this.code,
    required this.message,
    this.data,
    required this.timeStamp,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
      code: json['code'],
      message: json['message'],
      data: json['data'], // Depending on the structure, you might want to parse this differently.
      timeStamp: DateTime.parse(json['timeStamp']),
    );
  }
  Map<String, dynamic> toJson() => {
    "code": code,
    "message": message,
    "data": data,
    "timeStamp": timeStamp.toIso8601String(),
  };
}
