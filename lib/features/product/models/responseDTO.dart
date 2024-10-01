class ResponseDTO {
  int? code;
  String? message;
  dynamic data;
  DateTime? timeStamp;

  ResponseDTO({this.code, this.message, this.data, this.timeStamp});

  factory ResponseDTO.fromJson(Map<String, dynamic> json) {
    return ResponseDTO(
        code: json['code'],
        message: json['message'],
        data: json['data'],
        timeStamp: json['timeStamp']
    );
  }
}