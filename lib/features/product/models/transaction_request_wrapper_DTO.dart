import 'dart:convert';

import 'package:onpensea/features/product/models/product_transaction_DTO_list.dart';
import 'package:onpensea/features/product/models/transaction_DTO.dart';

import '../../profile/Model/responseDTO.dart';
import 'investmentTransactionDTOList.dart';

class TransactionRequestResponseWrapperDTO {
  List<ProductTransactionDTO>? productTransactionDTOList;
  List<InvestmentTransactionDTOList>? investmentTransactionDTOList;
  TransactionDTO? transactionDTO;
  ResponseDTO? responseDTO;

  TransactionRequestResponseWrapperDTO({
    this.productTransactionDTOList,
    this.investmentTransactionDTOList,
    this.transactionDTO,
    this.responseDTO,
  });

  factory TransactionRequestResponseWrapperDTO.fromJson(Map<String, dynamic> json) => TransactionRequestResponseWrapperDTO(
    productTransactionDTOList: json["productTransactionDTOList"] != null
        ? List<ProductTransactionDTO>.from(json["productTransactionDTOList"].map((x) => ProductTransactionDTO.fromJson(x)))
        : null,
    investmentTransactionDTOList: json["investmentTransactionDTOList"] != null
        ? List<InvestmentTransactionDTOList>.from(json["investmentTransactionDTOList"].map((x) => InvestmentTransactionDTOList.fromJson(x)))
        : null,
    transactionDTO: json["transactionDTO"] != null
        ? TransactionDTO.fromJson(json["transactionDTO"])
        : null,
    responseDTO: json["responseDTO"] != null
        ? ResponseDTO.fromJson(json["responseDTO"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "productTransactionDTOList": productTransactionDTOList != null
        ? List<dynamic>.from(productTransactionDTOList!.map((x) => x.toJson()))
        : null,
    "investmentTransactionDTOList": investmentTransactionDTOList != null
        ? List<dynamic>.from(investmentTransactionDTOList!.map((x) => x.toJson()))
        : null,
    "transactionDTO": transactionDTO?.toJson(),
    "responseDTO": responseDTO?.toJson(),
  };
}
