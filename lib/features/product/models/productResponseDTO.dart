import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/models/responseDTO.dart';



class ProductWrapperResponseDTO {
  List<ProductResponseDTO> productListResponseDTO;
  ResponseDTO responseDTO;

  ProductWrapperResponseDTO({
    required this.productListResponseDTO,
    required this.responseDTO,
  });

  factory ProductWrapperResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProductWrapperResponseDTO(
      productListResponseDTO: (json['productListResponseDTO'] as List)
          .map((item) => ProductResponseDTO.fromJson(item))
          .toList(),
      responseDTO: ResponseDTO.fromJson(json['responseDTO']),
    );
  }
}
