import 'package:onpensea/features/scheme/Controller/transaction_api.dart';
import 'package:onpensea/features/scheme/Models/transaction_dto.dart';
import 'package:onpensea/features/scheme/Models/transaction_request_dto.dart';

class TransactionService{
  final _api = TransactionApi();

  @override
  Future<TransactionResponseDTO?> postTransaction(TransactionDto transactionDto) async {
    return _api.post(transactionDto);
  }
}
