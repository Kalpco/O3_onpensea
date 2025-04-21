class ResponseDTO {
  int? status;
  String? message;
  dynamic data;

  ResponseDTO({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseDTO.fromJson(Map<String, dynamic> json) => ResponseDTO(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}