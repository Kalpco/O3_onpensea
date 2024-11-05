import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/Admin/addProduct.dart';
import 'package:onpensea/features/Admin/addProductActionButton.dart';
import 'package:onpensea/features/product/apiService/productService.dart';
import 'package:onpensea/features/product/models/productResponseDTO.dart';
import 'package:onpensea/features/product/screen/customeFloatingActionButton/custom_floating_action_button.dart';
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
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/constants/images_path.dart';
import '../../../../utils/constants/primary_header_container.dart';
import '../Home/widgets/DividerWithAvatar.dart';
import '../authentication/screens/login/Controller/LoginController.dart';
import '../product/models/products.dart';
import 'adminProductCartVertical.dart';
import 'adminProductHomeCategory.dart';

class AdminProductHomeScreen extends StatefulWidget {
  const AdminProductHomeScreen(
      {super.key, this.productCategory, this.subCategory, this.typeOfStone});

  final String? productCategory;
  final String? subCategory;
  final String? typeOfStone;

  @override
  State<AdminProductHomeScreen> createState() => _AdminProductHomeScreenState();
}

class _AdminProductHomeScreenState extends State<AdminProductHomeScreen> {
  ScrollController scrollController = ScrollController();
  final loginController = Get.find<LoginController>();
  late Future<ProductWrapperResponseDTO> futureProducts;
  late List<ProductResponseDTO> products = [];
  late List<ProductResponseDTO> originalList = List.from(products);
  String? userType;
  int pageNo = 0;
  final int pageSize = 20;
  bool isLoading = false;
  bool hasMoreData = true; // Track if more data is available


  @override
  void initState() {
    super.initState();
    products.clear();
    userType = loginController.userData['userType'];
    print('user type : $userType');
   // futureProducts = ProductService().fetchProducts(widget.productCategory,widget.typeOfStone);
   //  userType = loginController.userData['userType'];
   //  print(widget.typeOfStone);
   //  print("++++++++++++++++++++++++++++++++++++");
    loaderFunction(); // Load the first page of products
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent &&
          !isLoading &&
          hasMoreData) {
        loaderFunction(); // Load more data when at the bottom
      }
    });
  }

  Future<void> loaderFunction() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    try {
      final response = await ProductService().fetchAdminProducts(widget.productCategory,widget.subCategory,widget.typeOfStone,pageNo, pageSize);
      setState(() {
        print("pageNo: $pageNo");
        pageNo++; // Increment page number
        products.addAll(response.productListResponseDTO); // Add new products
        originalList = List.from(products); // Store original list
        // Check if there's more data
        print("products {$products}");
        if (response.productListResponseDTO.length < pageSize) {
          hasMoreData = false;
        }
      });
    } catch (e) {
      print('Error loading products: $e');
      Get.snackbar(
        '${U_TextStrings.noProductAvailable}',
        '',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackStyle: SnackStyle.FLOATING,
        duration: Duration(seconds: 1),

      );
    }
    setState(() {
      isLoading = false;
    });
  }

  // Future<ProductWrapperResponseDTO> fetchProducts(
  //     int pageNo, int pageSize) async {
  //   final String apiUrl =
  //       'http://o3uat.kalpco.in/products/kalpco/v1.0.0/products/merchant/5/U/catalog?pageNo=$pageNo&size=20';
  //   final response = await http.get(Uri.parse(apiUrl));
  //
  //   if (response.statusCode == 200) {
  //     return ProductWrapperResponseDTO.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load products');
  //   }
  //
  // }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
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
                          AdminProductHomeCategory(productCategory:widget.productCategory,typeOfStone:widget.typeOfStone),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Product List
              Padding(
                padding: EdgeInsets.all(U_Sizes.spaceBwtTwoSections),
                child: Container(
                  color: Color(0xFFFFFFFF),
                  child: Column(
                    children: [
                      ProductGridLayout(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return AdminProductCartVertical(product: product);
                        },
                      ),
                      if (isLoading)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Ensure the column takes only the space it needs
                              children: [
                                Text(
                                  "Hang on, loading data...",
                                  style: TextStyle(
                                    fontSize: 16.0, // Adjust the text size as needed
                                    fontWeight: FontWeight.bold,
                                    color: U_Colors.yaleBlue, // Optional: Color to match your theme
                                  ),
                                ),
                                SizedBox(height: 10.0), // Add some space between the text and loader
                                CircularProgressIndicator(
                                  color: U_Colors.yaleBlue,
                                  strokeWidth: 5.0, // Optional: Adjust the thickness
                                ),
                              ],
                            ),
                          ),
                        )

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
        floatingActionButton: addProductActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return Dialog(
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              // The main content of the dialog
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Image
                    Center(
                      child: Image(
                        height: 150,
                        image: AssetImage(U_ImagePath.kalpcoUpdatedLogo),
                      ),
                    ),
                    SizedBox(height: 20), // Space between image and text

                    // Text
                    Text(
                      'Get in Touch',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'For offline assistance, bulk purchase, party wear orders, bridal jewellery orders, corporate discounts & customized jewellery',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    DividerWithAvatar(
                        imagePath: 'assets/logos/KALPCO_splash_1.png'),
                    SizedBox(height: 10.0),
                    // Space between text and buttons
                    Text(
                      'Contact us',
                      style: GoogleFonts.poppins(
                          fontSize: 14, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,

                      children: <Widget>[
                        TextButton.icon(
                          onPressed: () {
                            _launchURL(
                                'tel:+919987734001'); // Replace with actual phone number
                          },
                          icon:
                          Icon(Icons.phone, size: 14, color: Colors.black),
                          label: Text('+919987734001',
                              style: TextStyle(fontSize: 12)),
                        ),
                        // SizedBox(width: 5), // Space between buttons
                        TextButton.icon(
                          onPressed: () {
                            // Action for Email button
                            _launchURL('mailto:support@kalpco.com');
                          },
                          icon:
                          Icon(Icons.email, size: 14, color: Colors.black),
                          label: Text('support@kalpco.com',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Close button
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
