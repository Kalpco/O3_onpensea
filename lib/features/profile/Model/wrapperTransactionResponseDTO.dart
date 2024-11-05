import 'package:onpensea/features/profile/Model/walletTransactionDTO.dart';

import '../../product/models/responseDTO.dart';

class WalletTransactionWrapperDTO {
  final int? userId;
  final double totalAmount;
  final ResponseDTO responseDTO;
  final List<WalletTransactionDTO> walletTransactionDTOList;

  WalletTransactionWrapperDTO({
    this.userId,
    required this.totalAmount,
    required this.responseDTO,
    required this.walletTransactionDTOList,
  });

  factory WalletTransactionWrapperDTO.fromJson(Map<String, dynamic> json) {
    var list = json['walletTransactionDTOList'] as List;
    List<WalletTransactionDTO> transactions = list.map((i) => WalletTransactionDTO.fromJson(i)).toList();

    return WalletTransactionWrapperDTO(
      userId: json['userId'],
      totalAmount: json['totalAmount'].toDouble(),
      responseDTO: ResponseDTO.fromJson(json['responseDTO']),
      walletTransactionDTOList: transactions,
    );
  }
}
