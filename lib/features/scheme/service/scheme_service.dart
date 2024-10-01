import 'package:onpensea/features/scheme/Controller/scheme_api.dart';

import '../../scheme/Models/ResponseDTO.dart';

class SchemeService{
  final _api = SchemeApi();
  Future<ResponseDTO?> getAllSchemes() async {
    return _api.getAllSchemes();
  }
}