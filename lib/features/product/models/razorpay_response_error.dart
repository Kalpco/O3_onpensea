class RazorpayResponseError {
  String code;
  String description;
  String source;
  String step;
  String reason;
  String field;

  RazorpayResponseError({
    required this.code,
    required this.description,
    required this.source,
    required this.step,
    required this.reason,
    required this.field,
  });

  factory RazorpayResponseError.fromJson(Map<String, dynamic> json) => RazorpayResponseError(
    code: json["code"],
    description: json["description"],
    source: json["source"],
    step: json["step"],
    reason: json["reason"],
    field: json["field"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "description": description,
    "source": source,
    "step": step,
    "reason": reason,
    "field": field,
  };
}