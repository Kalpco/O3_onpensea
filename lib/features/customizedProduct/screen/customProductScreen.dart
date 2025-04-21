import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/Admin/addProduct.dart';
import 'package:onpensea/features/Admin/addProductActionButton.dart';
import 'package:onpensea/features/customizedProduct/models/customizedProductResponseDTO.dart';
import 'package:onpensea/features/customizedProduct/models/customizedWrapperResponseDTO.dart';
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
import '../../Home/widgets/DividerWithAvatar.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import 'customProductCartVertical.dart';
import 'customProductSubCategory.dart';


class CustomProductScreen extends StatefulWidget {
  const CustomProductScreen(
      {super.key, this.subCategory});

  final String? subCategory;

  @override
  State<CustomProductScreen> createState() => _CustomProductScreenState();
}

class _CustomProductScreenState extends State<CustomProductScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  final loginController = Get.find<LoginController>();
  late Future<CustomizedProductWrapperResponseDTO> futureProducts;
  late List<CustomizedProductResponseDTO> customProducts = [];
  late List<CustomizedProductResponseDTO> originalList = List.from(customProducts);
  String? userType;
  int pageNo = 0;
  final int pageSize = 20;
  bool isLoading = false;
  bool hasMoreData = true; // Track if more data is available


  @override
  void initState() {
    super.initState();
    customProducts.clear();
    userType = loginController.userData['userType'];
    print('user type : $userType');
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
      final response = await ProductService().fetchCustomProducts(widget.subCategory,pageNo, pageSize);
      setState(() {
        print("pageNo: $pageNo");
        pageNo++; // Increment page number
        customProducts.addAll(response.customizedProductResponseDTOList); // Add new products
        originalList = List.from(customProducts); // Store original list
        // Check if there's more data
        print("Custom Products :- {$customProducts}");
        if (response.customizedProductResponseDTOList.length < pageSize) {
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

  void onSearch() {
    if (searchController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Search Something..."),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Perform search action
      print("Searching for: ${searchController.text}");
      // Call your API or perform navigation here
    }
  }

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
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search, color: Colors.black),
                            onPressed: onSearch, // Call the search function
                          ),
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
                          CustomProductSubCategory(productSubCategory:widget.subCategory),
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
                        itemCount: customProducts.length,
                        itemBuilder: (context, index) {
                          final customProduct = customProducts[index];
                          return CustomProductCartVertical(customProduct: customProduct);
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
      floatingActionButton:
      CustomFloatingActionButton(onPressed: () => _showDialog(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }

  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   super.dispose();
  // }

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
