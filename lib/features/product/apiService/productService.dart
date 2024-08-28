import 'dart:convert';
import 'package:get/get.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';
import 'package:http/http.dart' as http;
import '../../authentication/screens/login/Controller/LoginController.dart';

class ProductService {
  final LoginController loginController = Get.find<LoginController>();
  late final int userId = loginController.userData['userId'];

  // Base URL without userId
  static const String baseUrl = 'http://103.108.12.222:11002/kalpco/v0.01/products/merchant/';

  Future<ProductWrapperResponseDTO> fetchProducts() async {
    // Construct the full URL with userId
    final String url = '$baseUrl$userId/U/catalog';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ProductWrapperResponseDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }
  }

  //subcategory
  Future<ProductWrapperResponseDTO> fetchProductsBySubCategory(String productSubCategory) async {

    try {
      final url = '$baseUrl$userId/U/catalog?productSubCategory=$productSubCategory';
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
