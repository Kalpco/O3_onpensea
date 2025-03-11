import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';

import '../../network/dio_client.dart';

// class U_RoundedImage extends StatelessWidget {
//   U_RoundedImage( {
//     super.key,
//     this.border,
//     this.padding,
//     this.onPressed,
//     this.width,
//     this.height,
//     this.applyImageRadius = true,
//     required this.imageUrl,
//     this.fit = BoxFit.contain,
//     this.backgroundColor,
//     this.isNetworkImage = true,
//     this.borderRadius = U_Sizes.md,
//     this.isSelected = false,
//   });
//
//   final double? width,height;
//   final String imageUrl;
//   final bool applyImageRadius;
//   final BoxBorder? border;
//   final Color? backgroundColor;
//   final BoxFit? fit;
//   final EdgeInsetsGeometry?padding;
//   final bool isNetworkImage;
//   final VoidCallback?onPressed;
//   final double borderRadius;
//   final bool isSelected;
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         width: width,
//         height: height,
//         padding: padding,
//         decoration: BoxDecoration(border: border ?? (isSelected ? Border.all(color:U_Colors.satinSheenGold, width: 3) : null),color: backgroundColor,borderRadius: BorderRadius.circular(borderRadius)),
//         child: ClipRRect(
//           borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius):BorderRadius.zero,
//           // child: Image(fit:fit,image: isNetworkImage ? NetworkImage(imageUrl):AssetImage(imageUrl) as ImageProvider),
//           child: isNetworkImage  ? FutureBuilder<Uint8List?>(
//             future: _fetchImage(imageUrl),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return Center(
//                   child: CircularProgressIndicator(color: U_Colors.yaleBlue),
//                 );
//               } else if (snapshot.hasError || snapshot.data == null) {
//                 return Center(child: Icon(Icons.error, color: Colors.red));
//               } else {
//                 return Image.memory(snapshot.data!, fit: fit);
//               }
//             },
//           )
//               : Image.asset(imageUrl, fit: fit),
//         ),
//       ),
//     );
//   }
// }
//
// Future<Uint8List?> _fetchImage(String url) async {
//   try {
//     final dio = DioClient.getInstance();
//     final response = await dio.get<List<int>>(
//       url,
//       options: Options(responseType: ResponseType.bytes),
//     );
//     return Uint8List.fromList(response.data!);
//   } catch (e) {
//     print("❌ Image loading error: $e");
//     return null;
//   }
// }
class U_RoundedImage extends StatefulWidget {
  final double? width, height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;
  final bool isSelected;

  const U_RoundedImage({
    super.key,
    this.border,
    this.padding,
    this.onPressed,
    this.width,
    this.height,
    this.applyImageRadius = true,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.isNetworkImage = true,
    this.borderRadius = U_Sizes.md,
    this.isSelected = false,
  });

  @override
  _U_RoundedImageState createState() => _U_RoundedImageState();
}

class _U_RoundedImageState extends State<U_RoundedImage> {
  static final Map<String, Uint8List?> _imageCache = {};
  final ValueNotifier<Uint8List?> _imageData = ValueNotifier<Uint8List?>(null);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    if (widget.isNetworkImage) {
      _fetchImage(widget.imageUrl);
    }
  }

  Future<void> _fetchImage(String url) async {
    if (_imageCache.containsKey(url)) {
      _imageData.value = _imageCache[url]; // Load from cache
      _isLoading.value = false;
      return;
    }
    _isLoading.value = true;
    try {
      final dio = DioClient.getInstance();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final imageBytes = Uint8List.fromList(response.data!);
      _imageCache[url] = imageBytes; // Store in cache
      _imageData.value = imageBytes;
    } catch (e) {
      print("❌ Image loading error: $e");
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          border: widget.border ??
              (widget.isSelected
                  ? Border.all(color: U_Colors.satinSheenGold, width: 3)
                  : null),
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: ClipRRect(
          borderRadius: widget.applyImageRadius
              ? BorderRadius.circular(widget.borderRadius)
              : BorderRadius.zero,
          child: widget.isNetworkImage
              ? ValueListenableBuilder<bool>(
            valueListenable: _isLoading,
            builder: (context, isLoading, _) {
              return  ValueListenableBuilder<Uint8List?>(
                valueListenable: _imageData,
                builder: (context, imageData, _) {
                  if (_imageCache.containsKey(widget.imageUrl)) {
                    return Image.memory(_imageCache[widget.imageUrl]!, fit: widget.fit);
                  }

                  return ValueListenableBuilder<bool>(
                    valueListenable: _isLoading,
                    builder: (context, isLoading, _) {
                      return isLoading
                          ? Center(child: CircularProgressIndicator(color: U_Colors.yaleBlue))
                          : Center(child: Icon(Icons.error, color: Colors.red));
                    },
                  );
                },
              );
            },
          )
              : Image.asset(widget.imageUrl, fit: widget.fit),
        ),
      ),
    );
  }
}