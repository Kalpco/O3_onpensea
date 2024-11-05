

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/common_top_bar.dart';
import 'package:onpensea/features/product/screen/productVideoStreaming/productVideoStreaming.dart';
import 'package:onpensea/features/scheme/Screens/all_scheme_screen.dart';
import 'package:onpensea/navigation_menu.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import '../../product/screen/productHome/products_home_screen.dart';
import '../../product/screen/video_Full_Screen.dart';
import '../widgets/DividerWithAvatar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? profileImageUrl;
  List<String> imgList = [];
  List<String> goldCollectionImages = [];
  List<String> diamondCollectionImages = [];
  List<String> customJewelryImages = [];
  List<String> menCollectionImages = [];
  List<String> womenCollectionImages = [];
  List<String> kidsCollectionImages = [];
  final loginController = Get.find<LoginController>();
  bool isLoading = true;
  int _currentPage = 0;
  Timer? _timer;
  final Map<String, Image> imageCache = {};

  final PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    fetchImages();
    _startAutoPlay();
    final loginController = Get.find<LoginController>();
    _setProfileImage();
  }



  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _setProfileImage() {
    final loginController = Get.find<LoginController>();

    if (loginController.userData['photoUrl'] != null) {
      String photoUrl = loginController.userData['photoUrl'];
      profileImageUrl = '${ApiConstants.USERS_URL}$photoUrl';
      print("profile image: " + profileImageUrl!);
    } else {
      profileImageUrl = "";
    }

    setState(() {});
  }

  Future<void> fetchImages() async {
    try {
      final cacheManager = DefaultCacheManager();
      final file = await cacheManager
          .getSingleFile('${ApiConstants.USERS_URL}/pictures?userType=U');

      print("api: ${ApiConstants.USERS_URL}/pictures?userType=U')");
      if (file != null) {
        final response = await file.readAsString();
        List<dynamic> jsonResponse = json.decode(response);
        List<String> fetchedImages = List<String>.from(jsonResponse);

        // Assuming the response contains exactly 10 images
        if (fetchedImages.length >= 10) {
          setState(() {
            print("Image List aasfsd: ");
            print(fetchedImages.toString());

            // Assign specific images to imgList by their indices
            imgList = [
              fetchedImages[8], // First image
              // fetchedImages[8], // Fourth image
              fetchedImages[9],
              fetchedImages[4], // Seventh image
            ];

            // Assign specific images to other collections
            goldCollectionImages = [fetchedImages[2]]; // Second image
            diamondCollectionImages = [fetchedImages[1]]; // Ninth image
            customJewelryImages = [fetchedImages[10]]; // Fifth image
            menCollectionImages = [fetchedImages[0]]; // Tenth image
            womenCollectionImages = [fetchedImages[6]]; // Eighth image
            kidsCollectionImages = [fetchedImages[9]]; // Third image

            isLoading = false;
          });

          // Pre-cache images
          for (var image in fetchedImages) {
            imageCache[image] =
                Image.memory(base64Decode(image), fit: BoxFit.cover);
          }
        }
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  final List<String> shopByImages = [
    'assets/gold/rings.jpg',
    'assets/gold/angles.jpg',
    //'assets/gold/category_earings.png',
    'assets/gold/category_pendant.png',
    'assets/gold/category_earings.png',
  ];

  void _startAutoPlay() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % imgList.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _previousImage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(imgList.length - 1);
    }
  }

  void _nextImage() {
    if (_currentPage < imgList.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _pageController.jumpToPage(0);
    }
  }

  Widget buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        height: 200,
      ),
    );
  }

  Widget buildImage(String base64Image) {
    return imageCache[base64Image] ?? Container();
  }

  @override
  Widget build(BuildContext context) {
    final loginController = Get.find<LoginController>();
    return CommonTopAppBar(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              height: 200, // Ensuring the height is fixed for the PageView
              child: Stack(
                alignment: Alignment.center,
                children: [
                  isLoading
                      ? buildShimmer()
                      : PageView.builder(
                          controller: _pageController,
                          itemCount: imgList.length,
                          onPageChanged: _onPageChanged,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (index == 1) {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => LoansScreen()));
                                } else {
                                  // Handle the navigation based on the index
                                  final navController =
                                      Get.find<NavigationController>();

                                  switch (index) {
                                    case 0:
                                      navController.selectIndex.value =
                                          1; // Home Screen
                                      break;
                                    // case 1:
                                    //   navController.selectIndex.value =
                                    //   1; // Explore Screen (this will redirect to investment)
                                    //   break;
                                    case 2:
                                      navController.selectIndex.value =
                                          2; // AllInvestmentScreen (this will redirect to investment)
                                      break;
                                    case 3:
                                      navController.selectIndex.value =
                                          2; // Profile Screen
                                      break;
                                    // Add more cases as needed
                                  }

                                  // Navigate to the NavigationMenu with the updated index
                                  Get.to(() => NavigationMenu());
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                // decoration: BoxDecoration(
                                //   borderRadius: BorderRadius.circular(20),
                                //   // boxShadow: [
                                //   //   BoxShadow(
                                //   //     color: Colors.black26,
                                //   //     blurRadius: 10.0,
                                //   //     spreadRadius: 2.0,
                                //   //     offset: Offset(2.0, 2.0),
                                //   //   ),
                                //   // ],
                                // ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.memory(
                                    base64Decode(imgList[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                  Positioned(
                    left: 10,
                    child: IconButton(
                      icon:
                          Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      onPressed: _previousImage,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    child: IconButton(
                      icon: Icon(Icons.arrow_forward,
                          color: Colors.white, size: 30),
                      onPressed: _nextImage,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            //Video Banner code Starts
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Text(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: U_Colors.yaleBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  "Virtual Gallery",
                ),
              ],
            ),
            //SizedBox(height: U_Sizes.spaceBtwItems),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 2.5, bottom: 5),
              child: DividerWithAvatar(
                  dividerThickness: 0.2,
                  dividerColor: U_Colors.yaleBlue,
                  imagePath: 'assets/logos/KALPCO_splash.png'),
            ),
            SizedBox(height: U_Sizes.spaceBtwItems),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child:ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/videobanner.png', // Replace with your actual asset path
                    fit: BoxFit.cover,
                    // Optional: adjust as needed
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductVideoStreaming()),
                );
              },
            ),
            SizedBox(height: U_Sizes.spaceBtwItems),
            //Video Banner code Ends
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Text(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: U_Colors.yaleBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  "Gold Collection",
                ),
              ],
            ),
            //SizedBox(height: U_Sizes.spaceBtwItems),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 2.5, bottom: 5),
              child: DividerWithAvatar(
                  dividerThickness: 0.2,
                  dividerColor: U_Colors.yaleBlue,
                  imagePath: 'assets/logos/KALPCO_splash.png'),
            ),
            SizedBox(height: U_Sizes.spaceBtwItems),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: goldCollectionImages.isNotEmpty
                      ? buildImage(goldCollectionImages[0])
                      : Container(),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductHomeScreen(productCategory:"Custom",
                      subCategory:"Ring",typeOfStone:"")),
                );
              },
            ),
            SizedBox(height: U_Sizes.spaceBtwItems),
            // IconButton(
            //   icon: Icon(Icons.arrow_forward, size: 32, color: Colors.blue), // Icon
            //   onPressed: () {
            //     // OnTap: Navigate to a new page
            //     Get.to(() => ProductVideoStreaming());
            //   },
            // ),
            // Center(
            //   child: _controller.value.isInitialized
            //       ? Container(
            //     width: 500,
            //     height: 200,
            //     child: Stack(
            //       alignment: Alignment.center,
            //       children: [
            //         // The video player
            //         AspectRatio(
            //           aspectRatio: _controller.value.aspectRatio,
            //           child: VideoPlayer(_controller),
            //         ),
            //         // Play/pause button centered on the video
            //         IconButton(
            //           iconSize: 64,
            //           icon: Icon(
            //             isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
            //             color: Colors.white.withOpacity(0.7),
            //           ),
            //           onPressed: () {
            //             setState(() {
            //               if (isPlaying) {
            //                 _controller.pause();
            //               } else {
            //                 _controller.play();
            //               }
            //               isPlaying = !isPlaying;
            //             });
            //           },
            //         ),
            //         Positioned(bottom:5,right:160,
            //             child: IconButton(onPressed: _toggleFullScreen, icon: Icon(Icons.fullscreen,color: Colors.black.withOpacity(0.7),
            //                 size: 32,)
            //             ))
            //       ],
            //     ),
            //   )
            //       : CircularProgressIndicator(), // Show loader while initializing
            // ),
            // SizedBox(height: 20),
            // // Video selection buttons
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: List.generate(videoUrls.length, (index) {
            //     return Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //       child: ElevatedButton(
            //         onPressed: () => _switchVideo(index),
            //         child: Text('Video ${index + 1}'),
            //       ),
            //     );
            //   }),
            // ),

            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                height: 100, // Height of each square image
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: shopByImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Show 2 boxes per row
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductHomeScreen(productCategory:"Custom",
                                  subCategory:"Ring",typeOfStone:"")),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            shopByImages[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ),

            SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Text(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: U_Colors.yaleBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  "Diamond Collection",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 2.5, bottom: 5),
              child: DividerWithAvatar(
                  dividerThickness: 0.2,
                  dividerColor: U_Colors.yaleBlue,
                  imagePath: 'assets/logos/KALPCO_splash.png'),
            ),
            SizedBox(height: U_Sizes.spaceBtwItems),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: diamondCollectionImages.isNotEmpty
                      ? buildImage(diamondCollectionImages[0])
                      : Container(),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductHomeScreen(productCategory:"Diamond",
                      subCategory:"Ring",typeOfStone:"Natural Diamond")),
                );
              },
            ),

            SizedBox(height: U_Sizes.spaceBtwItems),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                height: 100, // Height of each square image
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: shopByImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Show 2 boxes per row
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductHomeScreen(productCategory:"Diamond",
                                  subCategory:"Ring",typeOfStone:"Natural Diamond")),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            shopByImages[index],
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ),
            SizedBox(
              height: 70,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 20),
                Text(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: U_Colors.yaleBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  "Lab Grown Diamond Collection",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 2.5, bottom: 5),
              child: DividerWithAvatar(
                  dividerThickness: 0.2,
                  dividerColor: U_Colors.yaleBlue,
                  imagePath: 'assets/logos/KALPCO_splash.png'),
            ),
            SizedBox(height: U_Sizes.spaceBtwItems),
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: customJewelryImages.isNotEmpty
                      ? buildImage(customJewelryImages[0])
                      : Container(),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductHomeScreen(productCategory:"Diamond",
                      subCategory:"Ring",typeOfStone:"Lab Grown")),
                );
              },
            ),

            SizedBox(height: U_Sizes.spaceBtwItems),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: SizedBox(
                height: 100, // Height of each square image
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: shopByImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, // Show 2 boxes per row
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductHomeScreen(productCategory:"Diamond",
                                  subCategory:"Ring",typeOfStone:"Lab Grown")),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12, width: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            shopByImages[index],
                            fit: BoxFit.fill,
                            width: double.infinity,
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
            ),
            // SizedBox(
            //   height: 70,
            // ),

            //             // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(width: 20),
            //     Text(
            //       style: GoogleFonts.poppins(
            //         fontSize: 16,
            //         color: U_Colors.yaleBlue,
            //         fontWeight: FontWeight.w600,
            //       ),
            //       "Custom Jewellery",
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 35.0, right: 35.0, top: 2.5, bottom: 5),
            //   child: DividerWithAvatar(
            //       dividerThickness: 0.2,
            //       dividerColor: U_Colors.yaleBlue,
            //       imagePath: 'assets/logos/KALPCO_splash.png'),
            // ),
            // SizedBox(height: U_Sizes.spaceBtwItems),
            // GestureDetector(
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black26,
            //           blurRadius: 10.0,
            //           spreadRadius: 2.0,
            //           offset: Offset(2.0, 2.0),
            //         ),
            //       ],
            //     ),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //       child: customJewelryImages.isNotEmpty
            //           ? buildImage(customJewelryImages[0])
            //           : Container(),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ProductHomeScreen(
            //               category: "custom", subCategory: "*")),
            //     );
            //   },
            // ),
            // SizedBox(height: 70),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(width: 20),
            //     Text(
            //       style: GoogleFonts.poppins(
            //         fontSize: 16,
            //         color: U_Colors.yaleBlue,
            //         fontWeight: FontWeight.w600,
            //       ),
            //       "Women Collection",
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 35.0, right: 35.0, top: 2.5, bottom: 5),
            //   child: DividerWithAvatar(
            //       dividerThickness: 0.3,
            //       dividerColor: U_Colors.yaleBlue,
            //       imagePath: 'assets/logos/KALPCO_splash.png'),
            // ),
            // SizedBox(height: U_Sizes.spaceBtwItems),
            // GestureDetector(
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black26,
            //           blurRadius: 10.0,
            //           spreadRadius: 2.0,
            //           offset: Offset(2.0, 2.0),
            //         ),
            //       ],
            //     ),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //       child: womenCollectionImages.isNotEmpty
            //           ? buildImage(womenCollectionImages[0])
            //           : Container(),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ProductHomeScreen(
            //               category: "women", subCategory: "*")),
            //     );
            //   },
            // ),
            // SizedBox(
            //   height: 70,
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(width: 20),
            //     Text(
            //       style: GoogleFonts.poppins(
            //         fontSize: 16,
            //         color: U_Colors.yaleBlue,
            //         fontWeight: FontWeight.w600,
            //       ),
            //       "Men Collection",
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 35.0, right: 35.0, top: 2.5, bottom: 5),
            //   child: DividerWithAvatar(
            //       dividerThickness: 0.3,
            //       dividerColor: U_Colors.yaleBlue,
            //       imagePath: 'assets/logos/KALPCO_splash.png'),
            // ),
            // SizedBox(height: U_Sizes.spaceBtwItems),
            // GestureDetector(
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black26,
            //           blurRadius: 10.0,
            //           spreadRadius: 2.0,
            //           offset: Offset(2.0, 2.0),
            //         ),
            //       ],
            //     ),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //       child: menCollectionImages.isNotEmpty
            //           ? buildImage(menCollectionImages[0])
            //           : Container(),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               ProductHomeScreen(category: "men", subCategory: "*")),
            //     );
            //   },
            // ),
            // SizedBox(
            //   height: 70,
            // ),

            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     SizedBox(width: 20),
            //     Text(
            //       style: GoogleFonts.poppins(
            //         fontSize: 16,
            //         color: U_Colors.yaleBlue,
            //         fontWeight: FontWeight.w600,
            //       ),
            //       "Kids Collection",
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 35.0, right: 35.0, top: 2.5, bottom: 5),
            //   child: DividerWithAvatar(
            //       dividerThickness: 0.2,
            //       dividerColor: U_Colors.yaleBlue,
            //       imagePath: 'assets/logos/KALPCO_splash.png'),
            // ),
            // SizedBox(height: U_Sizes.spaceBtwItems),
            // GestureDetector(
            //   child: Container(
            //     margin: EdgeInsets.symmetric(horizontal: 10),
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(20),
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black26,
            //           blurRadius: 10.0,
            //           spreadRadius: 2.0,
            //           offset: Offset(2.0, 2.0),
            //         ),
            //       ],
            //     ),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //       child: kidsCollectionImages.isNotEmpty
            //           ? buildImage(kidsCollectionImages[0])
            //           : Container(),
            //     ),
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => ProductHomeScreen(
            //                 category: "Kids",
            //                 subCategory: "*",
            //               )),
            //     );
            //   },
            // ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }


}
