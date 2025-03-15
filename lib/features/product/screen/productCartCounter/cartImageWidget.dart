import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/colors.dart';

import '../../../../network/dio_client.dart';

class CartImageWidget extends StatefulWidget {
  final String imageUrl;
  const CartImageWidget({super.key, required this.imageUrl});

  @override
  State<CartImageWidget> createState() => _CartImageWidgetState();
}

class _CartImageWidgetState extends State<CartImageWidget> {

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
        widget.imageUrl,
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

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: U_Colors.yaleBlue,));
    }

    if (_hasError || _imageData == null) {
      return _buildErrorWidget();
    }
    
    return Image.memory(
      _imageData!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildErrorWidget();
      },
    );
  }
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300], // Placeholder background
      alignment: Alignment.center,
      child: Icon(Icons.error, color: Colors.red, size: 50),
    );
  }
}
