import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/features/product/apiService/productService.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/primary_header_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../models/products.dart';
import '../productCategory/product_home_category.dart';
import '../productGridLayout/product_grid_layout.dart';
import '../productHeading/product_section_heading.dart';
import '../productHomeAppBar/home_app_bar.dart';
import '../productWidget/product_cart_vertical.dart';

class ProductSubCategoryDetailPage extends StatefulWidget {
  final String? productSubCategory;

  ProductSubCategoryDetailPage({required this.productSubCategory});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductSubCategoryDetailPage> {
  late Future<ProductWrapperResponseDTO> futureProducts;
  late List<ProductResponseDTO> products;
  final loginController = Get.find<LoginController>();

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().fetchProductsBySubCategory(widget.productSubCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductWrapperResponseDTO>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(U_Colors.yaleBlue),));
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('No data available'));
          } else {
            products = snapshot.data!.productListResponseDTO;
            if (products.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    U_ProductPrimaryHeaderContainer(
                      child: Column(
                        children: [
                          // App Bar
                          ProductHomeAppBar(
                            title: 'Welcome, ${loginController.userData['name'] ?? 'Guest'}',
                          ),
                          // Search Bar
                          Container(
                            width: 380,
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search, color: Colors.black),
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: U_Sizes.defaultSpace),

                          // Categories
                          Padding(
                            padding: EdgeInsets.only(left: U_Sizes.spaceBtwItems),
                            child: Column(
                              children: [
                                ProductSectionHeading(
                                  title: 'Popular Categories',
                                  showActionButton: false,
                                  textColor: U_Colors.whiteColor,
                                ),
                                const SizedBox(height: U_Sizes.spaceBtwItems),
                                // Categories list
                                ProductHomeCategory(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Product List
                    Padding(
                      padding: EdgeInsets.all(U_Sizes.spaceBwtTwoSections),
                      child: Column(
                        children: [
                          ProductGridLayout(
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ProductCartVertical(product: product);
                            },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
