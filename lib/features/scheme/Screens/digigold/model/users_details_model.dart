// user_details_model.dart
class UserDetailsModel {
  final String masterVaultId;
  final String userId;
  final String weightInMg;
  final String amount;
  final String? status;
  final String createdAt;
  final String createdBy;
  final String updatedAt;
  final String updatedBy;

  UserDetailsModel({
    required this.masterVaultId,
    required this.userId,
    required this.weightInMg,
    required this.amount,
    this.status,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      masterVaultId: json['masterVaultId'].toString(),
      userId: json['userId'].toString(),
      weightInMg: json['weightInMg'].toString(),
      amount: json['amount'].toString(),
      status: json['status'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      updatedAt: json['updatedAt'],
      updatedBy: json['updatedBy'],
    );
  }
}
