import 'package:onpensea/features/scheme/controller/investment_controller.dart';
import 'package:onpensea/features/scheme/models/investment_response_model.dart';

class InvestmentService {
  final _api = InvestmentController();
  Future<InvestmentResponseModel?> getAllInvestments() async {
    return _api.getAllInvestments();
  }
}