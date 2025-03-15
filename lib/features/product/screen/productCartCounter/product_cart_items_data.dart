

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/response/response.dart';

import '../../../../network/dio_client.dart';
import '../../../../utils/constants/colors.dart';

class ProductCartItems extends StatefulWidget {
  final String image;
  final String description;
  final int purity;

  const ProductCartItems({required this.image, required this.description,required this.purity, Key? key}) : super(key: key);

  @override
  State<ProductCartItems> createState() => _ProductCartItemsState();
}

class _ProductCartItemsState extends State<ProductCartItems> {

  Uint8List? _imageData;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchImage();
  }


  Future<void> _fetchImage() async {
    try {
      Dio dio = DioClient.getInstance();
      Response<List<int>> response = await dio.get<List<int>>(
        widget.image,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data != null) {
        setState(() {
          _imageData = Uint8List.fromList(response.data!);
          _isLoading = false;
        });
      } else {
        throw Exception("Empty image data");
      }
    } catch (e) {
      print('Error fetching image: $e');
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    print("description: ${widget.description}");
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:  _isLoading
                ? Center(child: CircularProgressIndicator(color: U_Colors.yaleBlue)) // Show loader
                : _hasError || _imageData == null
                ? Icon(Icons.error, color: Colors.red, size: 50) // Error icon
                : Image.memory(_imageData! as Uint8List, fit: BoxFit.cover),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Purity : ${widget.purity.toString()}',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

      ],
    );
  }
}