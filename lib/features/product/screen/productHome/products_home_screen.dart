import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/features/product/apiService/productService.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';
import 'package:onpensea/features/product/screen/productCartCounter/cart_counter_icon.dart';
import 'package:onpensea/features/product/screen/productCategory/product_home_category.dart';
import 'package:onpensea/features/product/screen/productContainer/product_search_container.dart';
import 'package:onpensea/features/product/screen/productGridLayout/product_grid_layout.dart';
import 'package:onpensea/features/product/screen/productHeading/product_section_heading.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/home_app_bar.dart';
import 'package:onpensea/features/product/screen/productImageText/product_vertical_image_text.dart';
import 'package:onpensea/features/product/screen/productWidget/product_cart_vertical.dart';
import 'package:onpensea/utils/constants/appBar.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/constants/text_strings.dart';

import '../../../../utils/constants/primary_header_container.dart';
import '../../../authentication/screens/login/Controller/LoginController.dart';
import '../../models/products.dart';

class ProductHomeScreen extends StatefulWidget {
  const ProductHomeScreen({super.key, this.category, this.subCategory});

  final String? category;
  final String? subCategory;

  @override
  State<ProductHomeScreen> createState() => _ProductHomeScreenState();
}

class _ProductHomeScreenState extends State<ProductHomeScreen> {
  final loginController = Get.find<LoginController>();

  late Future<ProductWrapperResponseDTO> futureProducts;
  late List<ProductResponseDTO> products;
  late List<ProductResponseDTO> originalList = List.from(products);

  List<ProductResponseDTO> filterPropertiesByActor(
      List<ProductResponseDTO> productList, String productSubCategory) {
    return productList
        .where((product) => product.productSubCategory == productSubCategory)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    futureProducts = ProductService().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductWrapperResponseDTO>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            products = snapshot.data!.productListResponseDTO;
            originalList = List.from(products); // Store the original list
            return SingleChildScrollView(
              child: Container(
                color: Color(0xFFFFFFF),
                child: Column(
                  children: [
                    U_ProductPrimaryHeaderContainer(
                      child: Column(
                        children: [
                          // App Bar
                          ProductHomeAppBar(
                            title:
                                'Welcome, ${loginController.userData['name'] ?? 'Guest'}',
                          ),
                          // const SizedBox(height: U_Sizes.spaceBwtSections),
                          // Search Bar
                          // ProductSearchContainer(
                          //   text: 'Search products ...',
                          //   onTap: () {},
                          // ),
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
                            padding:
                                EdgeInsets.only(left: U_Sizes.spaceBtwItems),
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
                      child: Container(
                        color: Color(0xFFFFFFFF),
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
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
