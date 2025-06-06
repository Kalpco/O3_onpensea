import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:onpensea/features/product/screen/curvedEdgesWidget.dart';
import 'package:onpensea/features/product/screen/productWidget/get_product_icon_app.dart';
import 'package:onpensea/utils/constants/api_constants.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/roundedImage.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:photo_view/photo_view.dart';

import '../../../network/dio_client.dart';
import '../models/customizedProductResponseDTO.dart';

class CustomProductImageSlider extends StatefulWidget {
  CustomProductImageSlider({super.key, required this.customProduct});

  CustomizedProductResponseDTO customProduct;

  @override
  State<CustomProductImageSlider> createState() => _CustomProductImageSliderState();
}

class _CustomProductImageSliderState extends State<CustomProductImageSlider> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return CurvedEdgesWidget(
      child: Container(
        color: dark ? U_Colors.grey : U_Colors.whiteColor,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () =>
                  _showFullScreenImage(
                      "${ApiConstants.baseUrl}${widget.customProduct
                          .customizedImageUrl![_selectedIndex]}"),
              child: SizedBox(
                height: 700,
                child: Padding(
                    padding: const EdgeInsets.all(
                        U_Sizes.productImageRadius * 2),
                    //child: Center(child: Image.network("${ApiConstants.baseUrl}${widget.product.productImageUri![_selectedIndex]}", fit: BoxFit.cover,)),
                    child: Center(
                      child: FutureBuilder<Uint8List?>(
                        future: fetchImageList(
                            "${ApiConstants.baseUrl}${widget.customProduct
                                .customizedImageUrl![_selectedIndex]}"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                                color: U_Colors.yaleBlue);
                          } else if (snapshot.hasError) {
                            return Icon(Icons.error, color: Colors.red);
                          } else {
                            return Image.memory(snapshot.data!);
                          }
                        },
                      ),
                    )

                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            //slider
            Positioned(
              right: 0,
              bottom: 25,
              left: U_Sizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  separatorBuilder: (_, __) =>
                  const SizedBox(width: U_Sizes.spaceBtwItems),
                  itemCount: widget.customProduct.customizedImageUrl!.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      GestureDetector(
                        child: U_RoundedImage(
                          width: 80,
                          backgroundColor: dark ? U_Colors.dark : U_Colors.grey,
                          padding: const EdgeInsets.all(U_Sizes.sm),
                          imageUrl:
                          "${ApiConstants.baseUrl}${widget.customProduct
                              .customizedImageUrl![index]}",
                          onPressed: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                          isSelected: index == _selectedIndex,
                          isNetworkImage: true,
                        ),
                      ),
                ),
              ),
            ),
            AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: U_Colors.whiteColor,
              actions: [
                GetProductIconApp(
                  onPressed: () {},
                  iconColor: U_Colors.black,
                  counterBgColor: U_Colors.black,
                  counterTextColor: U_Colors.whiteColor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(String imageUrl) {
    final ValueNotifier<Uint8List?> imageData = ValueNotifier<Uint8List?>(null);
    final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);

    // Fetch the image when dialog opens
    _fetchImage(imageUrl, imageData, isLoading);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog.fullscreen(
          child: Stack(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: isLoading,
                builder: (context, loading, _) {
                  return ValueListenableBuilder<Uint8List?>(
                    valueListenable: imageData,
                    builder: (context, imageData, _) {
                      if (loading) {
                        return Center(
                          child: CircularProgressIndicator(
                              color: U_Colors.yaleBlue),
                        );
                      } else if (imageData == null) {
                        return Center(child: Icon(
                            Icons.error, color: Colors.red));
                      } else {
                        return PhotoView(
                          minScale: PhotoViewComputedScale.contained,
                          imageProvider: MemoryImage(imageData),
                          backgroundDecoration: BoxDecoration(
                              color: U_Colors.whiteColor),
                        );
                      }
                    },
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _fetchImage(String url, ValueNotifier<Uint8List?> imageData,
      ValueNotifier<bool> isLoading) async {
    try {
      final dio = DioClient.getInstance();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      imageData.value = Uint8List.fromList(response.data!);
    } catch (e) {
      print("❌ Image loading error: $e");
      imageData.value = null;
    } finally {
      isLoading.value = false;
    }


  }
  Future<Uint8List?> fetchImageList(String url) async {
    try {
      final dio = DioClient.getInstance();
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data!);
    } catch (e) {
      print("❌ Image loading error: $e");
      return null;
    }
  }
}
