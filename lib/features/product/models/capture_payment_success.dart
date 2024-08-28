import 'dart:convert';

import 'acquirer_data.dart';

CapturePaymentRazorPay capturePaymentRazorPayFromJson(String str) => CapturePaymentRazorPay.fromJson(json.decode(str));

String capturePaymentRazorPayToJson(CapturePaymentRazorPay data) => json.encode(data.toJson());

class CapturePaymentRazorPay {
  String id;
  String entity;
  int amount;
  String currency;
  String status;
  String orderId;
  dynamic invoiceId;
  bool international;
  String method;
  int amountRefunded;
  dynamic refundStatus;
  bool captured;
  String description;
  String cardId;
  dynamic bank;
  dynamic wallet;
  dynamic vpa;
  String email;
  String contact;
  String customerId;
  String tokenId;
  int fee;
  int tax;
  dynamic errorCode;
  dynamic errorDescription;
  dynamic errorSource;
  dynamic errorStep;
  dynamic errorReason;
  // AcquirerData acquirerData;
  int createdAt;

  CapturePaymentRazorPay({
    required this.id,
    required this.entity,
    required this.amount,
    required this.currency,
    required this.status,
    required this.orderId,
    this.invoiceId,
    required this.international,
    required this.method,
    required this.amountRefunded,
    this.refundStatus,
    required this.captured,
    required this.description,
    required this.cardId,
    this.bank,
    this.wallet,
    this.vpa,
    required this.email,
    required this.contact,
    required this.customerId,
    required this.tokenId,
    required this.fee,
    required this.tax,
    this.errorCode,
    this.errorDescription,
    this.errorSource,
    this.errorStep,
    this.errorReason,
    // required this.acquirerData,
    required this.createdAt,
  });

  factory CapturePaymentRazorPay.fromJson(Map<String, dynamic> json) => CapturePaymentRazorPay(
    id: json["id"] ?? '',
    entity: json["entity"] ?? '',
    amount: json["amount"] ?? 0,
    currency: json["currency"] ?? '',
    status: json["status"] ?? '',
    orderId: json["order_id"] ?? '',
    invoiceId: json["invoice_id"],
    international: json["international"] ?? false,
    method: json["method"] ?? '',
    amountRefunded: json["amount_refunded"] ?? 0,
    refundStatus: json["refund_status"],
    captured: json["captured"] ?? false,
    description: json["description"] ?? '',
    cardId: json["card_id"] ?? '',
    bank: json["bank"],
    wallet: json["wallet"],
    vpa: json["vpa"],
    email: json["email"] ?? '',
    contact: json["contact"] ?? '',
    customerId: json["customer_id"] ?? '',
    tokenId: json["token_id"] ?? '',
    fee: json["fee"] ?? 0,
    tax: json["tax"] ?? 0,
    errorCode: json["error_code"],
    errorDescription: json["error_description"],
    errorSource: json["error_source"],
    errorStep: json["error_step"],
    errorReason: json["error_reason"],
    // acquirerData: AcquirerData.fromJson(json["acquirer_data"] ?? {}),
    createdAt: json["created_at"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "entity": entity,
    "amount": amount,
    "currency": currency,
    "status": status,
    "order_id": orderId,
    "invoice_id": invoiceId,
    "international": international,
    "method": method,
    "amount_refunded": amountRefunded,
    "refund_status": refundStatus,
    "captured": captured,
    "description": description,
    "card_id": cardId,
    "bank": bank,
    "wallet": wallet,
    "vpa": vpa,
    "email": email,
    "contact": contact,
    "customer_id": customerId,
    "token_id": tokenId,
    "fee": fee,
    "tax": tax,
    "error_code": errorCode,
    "error_description": errorDescription,
    "error_source": errorSource,
    "error_step": errorStep,
    "error_reason": errorReason,
    // "acquirer_data": acquirerData.toJson(),
    "created_at": createdAt,
  };
}
