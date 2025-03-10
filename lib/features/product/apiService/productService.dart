import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';
import 'package:http/http.dart' as http;
import '../../../network/dio_client.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';

class ProductService {
  final LoginController loginController = Get.find<LoginController>();
  late final int userId = loginController.userData['userId'];
  late final String userType = loginController.userData['userType'];
  static final Dio dio = DioClient.getInstance();

  // Base URL without userId
  static String baseUrl = '${ApiConstants.PRODUCTS_BASE_URL}/merchant/';

  //For fetching all products
  Future<ProductWrapperResponseDTO> fetchProducts(String? productCategory,String? subCategory, String? typeOfStone,int pageNo, int pageSize) async {
    // Construct the full URL with userId
  try{
    final String url = '$baseUrl$userId/U/catalog?productCategory=$productCategory&productSubCategory=$subCategory&typeOfStone=$typeOfStone&pageNo=$pageNo&size=$pageSize';
    // final response = await http.get(Uri.parse(url));
    final  response = await dio.get(url);

    if (response.statusCode == 200) {
      return ProductWrapperResponseDTO.fromJson(json.decode(response.data));
    } else {
      throw Exception('Failed to load products');
    }
  }catch(e){
    print("❌ Error fetching products: $e");
    throw Exception('Failed to fetch products');
  }

  }
  //For fetching Admin data only
  Future<ProductWrapperResponseDTO> fetchAdminProducts(String? productCategory,String? subCategory, String? typeOfStone,int pageNo, int pageSize) async {
    // Construct the full URL with userId
    final String url = '$baseUrl$userId/$userType/catalog?productCategory=$productCategory&productSubCategory=$subCategory&typeOfStone=$typeOfStone&pageNo=$pageNo&size=$pageSize';
    print("url $url");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return ProductWrapperResponseDTO.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load products');
    }

  }

  //subcategory products for user
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

  //subcategory products for Admin

  Future<ProductWrapperResponseDTO> fetchAdminProductsBySubCategory( String? productCategory,String? typeOfStone, String? productSubCategory,int pageNo, int pageSize) async {

    try {
      final url = '$baseUrl$userId/$userType/catalog?productCategory=$productCategory&productSubCategory=$productSubCategory&typeOfStone=$typeOfStone&pageNo=$pageNo&size=$pageSize';
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
