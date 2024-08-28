import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:onpensea/features/product/apiService/productService.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/primary_header_container.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../models/products.dart';
import '../productCategory/product_home_category.dart';
import '../productContainer/product_search_container.dart';
import '../productGridLayout/product_grid_layout.dart';
import '../productHeading/product_section_heading.dart';
import '../productHomeAppBar/home_app_bar.dart';
import '../productWidget/product_cart_vertical.dart';

class ProductSubCategoryDetailPage extends StatefulWidget {
  final String productSubCategory;

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
      // appBar: AppBar(
      //   title: Text('Products - ${widget.productSubCategory}'),
      // ),
      body: FutureBuilder<ProductWrapperResponseDTO>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }  else {
            products = snapshot.data!.productListResponseDTO;
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
                        // const SizedBox(height: U_Sizes.spaceBwtSections),
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
                              ProductHomeCategory(
                                // onItemPressed: (index) {
                                //   if (index == 0) {
                                //     setState(() {
                                //       products = List.from(originalList); // Reset to original list
                                //     });
                                //   } else if (index == 1) {
                                //     setState(() {
                                //       products = filterPropertiesByActor(
                                //           originalList, "Ring");
                                //     });
                                //   }
                                // },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // Product List
                  Padding(
                    padding: EdgeInsets.all(U_Sizes.spaceBwtTwoSections),
                    child: Column(children: [
                      ProductGridLayout(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCartVertical(product: product);
                        },
                      )
                    ]),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
