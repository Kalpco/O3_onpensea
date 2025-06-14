import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';
import 'package:onpensea/features/Admin/adminHomeScreen.dart';
import 'package:onpensea/features/Admin/adminProductsHomeScreen.dart';
import 'package:onpensea/features/Admin/adminEditProduct.dart';
import 'package:onpensea/features/product/apiService/paymentOrderAPI.dart';
import 'package:onpensea/features/product/controller/post_transaction_Api_calling.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/features/product/models/razorpay_failure_response.dart';

import 'package:onpensea/features/product/screen/bottom_add_to_cart.dart';
import 'package:onpensea/features/product/screen/curvedEdgesWidget.dart';
import 'package:onpensea/features/product/screen/productExpandTile/product_Dropdown_Size.dart';
import 'package:onpensea/features/product/screen/productExpandTile/product_Price_Expand_Tile.dart';
import 'package:onpensea/features/product/screen/productHome/product_Fail_Page.dart';
import 'package:onpensea/features/product/screen/productHome/product_Success_page.dart';
import 'package:onpensea/features/product/screen/product_expand-tile.dart';
import 'package:onpensea/features/product/screen/product_image_slider.dart';
import 'package:onpensea/features/product/screen/product_metadata.dart';
import 'package:onpensea/features/product/screen/product_specification.dart';
import 'package:onpensea/features/product/screen/rating_n_share.dart';
import 'package:onpensea/utils/constants/appBar.dart';
import 'package:onpensea/utils/constants/circularIcon.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/images_path.dart';
import 'package:onpensea/utils/constants/product_title.dart';
import 'package:onpensea/utils/constants/roundedImage.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';
import 'package:onpensea/utils/theme/custom_themes/app_bar_theme.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:readmore/readmore.dart';

import '../../../utils/constants/api_constants.dart';
import '../../navigation_menu.dart';
import '../../network/dio_client.dart';
import '../authentication/screens/login/Controller/LoginController.dart';

class AdminProductDetail extends StatefulWidget {
  AdminProductDetail({super.key, required this.product});

  ProductResponseDTO product;

  @override
  State<AdminProductDetail> createState() => _AdminProductDetailState();
}

class _AdminProductDetailState extends State<AdminProductDetail> {
  String? userType;
  final loginController = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();
    getUserType();
  }

  void getUserType() {
    userType = loginController.userData['userType'];
    print("userType:$userType");
  }

  void showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Expanded(child: Text("Product Deleted")),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the alert dialog
                },
              )
            ],
          ),
          content: Text('The product has been successfully deleted.'),
        );
      },
    );
  }

  // Future<void> deleteProduct() async {
  //   //API URL
  //   final String apiUrl ='http://o3uat.kalpco.in/products/kalpco/v1.0.0/products/merchant/${widget.product.productOwnerId}/M/catalog/${widget.product.id}';
  //   try {
  //     final response = await http.delete(Uri.parse(apiUrl));
  //
  //     // Check for a 200 OK response
  //     if (response.statusCode == 200) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Product has been deleted succesfully'))
  //       );
  //     } else {
  //       // Show error message if the response is not 200
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Failed to delete product'))
  //       );
  //     }
  //   } catch (e) {
  //     // Handle any errors that occur during the request
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('An error occurred: $e'))
  //     );
  //   }
  // }
  Future<void> deleteProduct() async {
    final dioClient = DioClient.getInstance();
    final String apiUrl =
        '${ApiConstants.baseUrl}/merchant/${widget.product.productOwnerId}/M/catalog/${widget.product.id}';
    print('apiUrl:$apiUrl');
    try {
      final response = await dioClient.delete(apiUrl);

      // Check for a 200 OK response
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product has been deleted successfully'),backgroundColor: Colors.green),
          );
        }
        Navigator.pop(context);
        Get.offAll(() => NavigationMenu());
      } else {
        // Show error message if the response is not 200
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete product')),
          );
        }
      }
    } catch (e) {
      // Handle any errors that occur during the request
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return Scaffold(
        //bottomNavigationBar: BottomAddToCart(product: widget.product),
        body: SingleChildScrollView(
      child: Column(children: [
        // 1. product Image Slider
        ProductImageSlider(product: widget.product),
        // 2. product details
        Padding(
          padding: const EdgeInsets.only(
              right: U_Sizes.defaultSpace,
              left: U_Sizes.defaultSpace,
              bottom: U_Sizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //rating
              const RatingnShare(),
              //price title
              ProductMetaData(product: widget.product),
              // const SizedBox(height: U_Sizes.spaceBwtSections),
              //product description
              const SizedBox(height: U_Sizes.spaceBtwItems),
              // const ProductSizeDropdown(),
              const SizedBox(height: U_Sizes.spaceBtwItems),

              // const ProductTitleText(title: 'Product Details',smallSize:false),
              Text('Product Details',
                  style: Theme.of(context).textTheme.titleMedium),

              ReadMoreText(
                widget.product.productDescription!,
                trimLines: 1,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                lessStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              Divider(),
              //  const ProductTitleText(title: 'Product Specifications',smallSize:false),
              // Text('Product Specifications',style: Theme.of(context).textTheme.titleMedium),

              //product detail
              // const ProductSpecification(),

              ProductExpandTile(product: widget.product),
              Divider(),
              ProductPriceExpandTile(product: widget.product),
              Divider(),
              SizedBox(height: 20.0),
              if (userType == "M")
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirm Delete ?"),
                                  content: Text("Are you sure want to delete?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteProduct();
                                        // Navigator.of(context).pop(); // Close the dialog
                                        // showDeleteConfirmationDialog();// Close the dialog
                                        // Pop the current screen
                                        // Here you can perform the actual delete logic if needed.
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide.none,
                            backgroundColor: U_Colors.satinSheenGold,
                            padding: EdgeInsets.symmetric(
                                vertical: 14.0, horizontal: 18.0),
                            minimumSize: Size(120, 38),
                          ),
                          child: Text('Delete'),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminEditProduct(product: widget.product)));
                      },
                      child: Text('Update '),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: U_Colors.yaleBlue,
                        side: BorderSide.none,
                        padding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 18.0),
                        minimumSize: Size(120, 38),
                      ),
                    ),
                  ],
                )

// Inside the build method of ProductDetail
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) =>
//                                   CheckoutScreen(product: widget.product)),
//                         );
//                       },
//                       child: const Text('Buy Now'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: U_Colors.satinSheenGold,
//                       ),
//                     ),
//                   ),
            ],
          ),
        )
      ]),
    ));
  }
}
