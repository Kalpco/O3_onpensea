import 'package:onpensea/features/profile/Model/walletTransactionDTO.dart';

import '../../product/models/responseDTO.dart';

class WalletTransactionWrapperDTO {
  final BigInt totalAmount;
  final ResponseDTO responseDTO;
  final List<WalletTransactionDTO> walletTransactionDTOList;

  WalletTransactionWrapperDTO({
    required this.totalAmount,
    required this.responseDTO,
    required this.walletTransactionDTOList,
  });

  factory WalletTransactionWrapperDTO.fromJson(Map<String, dynamic> json) {
    return WalletTransactionWrapperDTO(
      totalAmount: json['totalAmount'] is String
          ? BigInt.parse(json['totalAmount'])
          : BigInt.from(json['totalAmount']),
      responseDTO: ResponseDTO.fromJson(json['responseDTO']),
      walletTransactionDTOList: (json['walletTransactionDTOList'] as List)
          .map((item) => WalletTransactionDTO.fromJson(item))
          .toList(),
    );
  }
}
