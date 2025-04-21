import 'dart:convert';


import 'package:onpensea/features/customizedProduct/models/responseDTO.dart';

import 'customizedProductResponseDTO.dart';

CustomizedProductWrapperResponseDTO productWrapperResponseDtoFromJson(String str) => CustomizedProductWrapperResponseDTO.fromJson(json.decode(str));

String productWrapperResponseDtoToJson(CustomizedProductWrapperResponseDTO data) => json.encode(data.toJson());

class CustomizedProductWrapperResponseDTO {
  List<CustomizedProductResponseDTO> customizedProductResponseDTOList;
  ResponseDTO responseDTO;

  CustomizedProductWrapperResponseDTO({
    required this.customizedProductResponseDTOList,
    required this.responseDTO,
  });

  factory CustomizedProductWrapperResponseDTO.fromJson(Map<String, dynamic> json) => CustomizedProductWrapperResponseDTO(
    customizedProductResponseDTOList: List<CustomizedProductResponseDTO>.from(json["customizedProductResponseDTOList"].map((x) => CustomizedProductResponseDTO.fromJson(x))),
    responseDTO: ResponseDTO.fromJson(json["responseDTO"]),
  );

  Map<String, dynamic> toJson() => {
    "customizedProductResponseDTOList": List<dynamic>.from(customizedProductResponseDTOList.map((x) => x.toJson())),
    "responseDTO": responseDTO.toJson(),
  };
}