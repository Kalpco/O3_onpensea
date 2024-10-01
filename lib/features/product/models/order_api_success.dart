

import 'dart:convert';

RazorpaySuccessResponseDTO RazorpaySuccessResponseDTOFromJson(String str) => RazorpaySuccessResponseDTO.fromJson(json.decode(str));

String RazorpaySuccessResponseDTOToJson(RazorpaySuccessResponseDTO data) => json.encode(data.toJson());

class RazorpaySuccessResponseDTO {
    String id;
    String entity;
    int amount;
    int amountPaid;
    int amountDue;
    String currency;
    String receipt;
    dynamic offerId;
    String status;
    int attempts;

    int createdAt;

    RazorpaySuccessResponseDTO({
        required this.id,
        required this.entity,
        required this.amount,
        required this.amountPaid,
        required this.amountDue,
        required this.currency,
        required this.receipt,
        this.offerId,
        required this.status,
        required this.attempts,

        required this.createdAt,
    });

    factory RazorpaySuccessResponseDTO.fromJson(Map<String, dynamic> json) => RazorpaySuccessResponseDTO(
        id: json["id"],
        entity: json["entity"],
        amount: json["amount"],
        amountPaid: json["amount_paid"],
        amountDue: json["amount_due"],
        currency: json["currency"],
        receipt: json["receipt"],
        offerId: json["offer_id"],
        status: json["status"],
        attempts: json["attempts"],
        createdAt: json["created_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "amount": amount,
        "amount_paid": amountPaid,
        "amount_due": amountDue,
        "currency": currency,
        "receipt": receipt,
        "offer_id": offerId,
        "status": status,
        "attempts": attempts,
        "created_at": createdAt,
    };
}
