import 'dart:convert';
import 'package:get/get.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';
import 'package:http/http.dart' as http;
import '../../authentication/screens/login/Controller/LoginController.dart';

class ProductService {
  final LoginController loginController = Get.find<LoginController>();
  late final int userId = loginController.userData['userId'];

  // Base URL without userId
  static String baseUrl = '${ApiConstants.PRODUCTS_BASE_URL}/merchant/';

  Future<ProductWrapperResponseDTO> fetchProducts(String? productCategory, String? typeOfStone,int pageNo, int pageSize) async {
    // Construct the full URL with userId
    final String url = '$baseUrl$userId/U/catalog?productCategory=$productCategory&typeOfStone=$typeOfStone&pageNo=$pageNo&size=$pageSize';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ProductWrapperResponseDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }

  //subcategory
  Future<ProductWrapperResponseDTO> fetchProductsBySubCategory( String? productCategory,String? typeOfStone, String? productSubCategory,int pageNo, int pageSize) async {

    try {
      final url = '$baseUrl$userId/U/catalog?productCategory=$productCategory&productSubCategory=$productSubCategory&typeOfStone=$typeOfStone&pageNo=$pageNo&size=$pageSize';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ProductWrapperResponseDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }





  Future<ProductWrapperResponseDTO> fetchProductsByStoneType(String? typeOfStone) async {

    try {
      final url = '$baseUrl$userId/U/catalog?typeOfStone=$typeOfStone';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return ProductWrapperResponseDTO.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }




}
