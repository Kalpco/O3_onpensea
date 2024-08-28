// import 'dart:async';
// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
//
// import '../../../utils/constants/colors.dart';
// import '../../../utils/constants/sizes.dart';
// import '../../authentication/screens/login/Controller/LoginController.dart';
// import '../../product/screen/productHome/products_home_screen.dart';
// import '../widgets/DividerWithAvatar.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   String? profileImageUrl;
//   List<String> imgList = [];
//   List<String> goldCollectionImages = [];
//   List<String> diamondCollectionImages = [];
//   List<String> customJewelryImages = [];
//   List<String> menCollectionImages = [];
//   List<String> womenCollectionImages = [];
//   List<String> kidsCollectionImages = [];
//
//   bool isLoading = true;
//   int _currentPage = 0;
//   Timer? _timer;
//   final Map<String, Image> imageCache = {};
//
//   final PageController _pageController = PageController(initialPage: 0);
//
//   @override
//   void initState() {
//     super.initState();
//     fetchImages();
//     _startAutoPlay();
//     final loginController = Get.find<LoginController>();
//
//     _setProfileImage();
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }
//   void _setProfileImage() {
//     final loginController = Get.find<LoginController>();
//     String photoUrl = loginController.userData['photoUrl'];
//     profileImageUrl = 'http://103.108.12.222:11000/kalpco/version/v0.01$photoUrl';
//     setState(() {});
//   }
//   Future<void> fetchImages() async {
//     try {
//       final cacheManager = DefaultCacheManager();
//       final file = await cacheManager.getSingleFile('http://103.108.12.222:11000/kalpco/version/v0.01/users/pictures?userType=U');
//
//       if (file != null) {
//         final response = await file.readAsString();
//         List<dynamic> jsonResponse = json.decode(response);
//         List<String> fetchedImages = List<String>.from(jsonResponse);
//
//         // Assuming the response contains exactly 10 images
//         if (fetchedImages.length >= 10) {
//           setState(() {
//             print("Image List: ");
//             print(fetchedImages.toString());
//
//             // Assign specific images to imgList by their indices
//             imgList = [
//               fetchedImages[0], // First image
//               fetchedImages[3], // Fourth image
//               fetchedImages[6],
//               fetchedImages[5],// Seventh image
//             ];
//
//             // Assign specific images to other collections
//             goldCollectionImages = [fetchedImages[1]]; // Second image
//             diamondCollectionImages = [fetchedImages[8]]; // Ninth image
//             customJewelryImages = [fetchedImages[4]]; // Fifth image
//             menCollectionImages = [fetchedImages[9]]; // Tenth image
//             womenCollectionImages = [fetchedImages[7]]; // Eighth image
//             kidsCollectionImages = [fetchedImages[2]]; // Third image
//
//             isLoading = false;
//           });
//
//           // Pre-cache images
//           for (var image in fetchedImages) {
//             imageCache[image] = Image.memory(base64Decode(image), fit: BoxFit.cover);
//           }
//         }
//       }
//     } catch (e) {
//       print('Error fetching images: $e');
//     }
//   }
//   final List<String> shopByImages = [
//     'assets/gold/rings.jpg',
//     'assets/gold/angles.jpg',
//     'assets/gold/3.jpg',
//     'assets/gold/8.jpg',
//     'assets/gold/9.jpg',
//   ];
//   void _startAutoPlay() {
//     _timer = Timer.periodic(Duration(seconds: 3), (timer) {
//       if (_pageController.hasClients) {
//         _currentPage = (_currentPage + 1) % imgList.length;
//         _pageController.animateToPage(
//           _currentPage,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//         );
//       }
//     });
//   }
//
//   void _onPageChanged(int index) {
//     setState(() {
//       _currentPage = index;
//     });
//   }
//
//   void _previousImage() {
//     if (_currentPage > 0) {
//       _pageController.previousPage(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _pageController.jumpToPage(imgList.length - 1);
//     }
//   }
//
//   void _nextImage() {
//     if (_currentPage < imgList.length - 1) {
//       _pageController.nextPage(
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     } else {
//       _pageController.jumpToPage(0);
//     }
//   }
//
//   Widget buildShimmer() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           color: Colors.white,
//         ),
//         height: 200,
//       ),
//     );
//   }
//
//   Widget buildImage(String base64Image) {
//     return imageCache[base64Image] ?? Container();
//   }
//
//   void _showFullScreenImage(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           insetPadding: EdgeInsets.all(10),
//           child: Stack(
//             children: [
//               CachedNetworkImage(
//                 imageUrl: profileImageUrl!,
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//                 errorWidget: (context, url, error) => Icon(Icons.error),
//                 placeholder: (context, url) => CircularProgressIndicator(),
//               ),
//               Positioned(
//                 top: 30,
//                 right: 30,
//                 child: IconButton(
//                   icon: Icon(Icons.close, color: Colors.white, size: 30),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final loginController = Get.find<LoginController>();
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: Container(
//           color: U_Colors.whiteColor,
//           child: AppBar(
//             title: Obx(() => Text('Welcome, ${loginController.userData['name'] ?? 'Guest'}')),
//             backgroundColor: Colors.transparent,
//             actions: [
//               IconButton(
//                 icon: Image.asset(
//                   'assets/logos/shopcart.png',
//                   height: 24,
//                   width: 24,
//                   color: U_Colors.chataccentColor,
//                 ),
//                 onPressed: () {
//                   // Action for cart button
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//
//               decoration: BoxDecoration(
//                 color: U_Colors.chatprimaryColor  ,
//               ),
//               child:  GestureDetector(
//                 onLongPress: () => _showFullScreenImage(context),
//                 child: profileImageUrl != null
//                     ? CachedNetworkImage(
//                   imageUrl: profileImageUrl!,
//                   imageBuilder: (context, imageProvider) => CircleAvatar(
//                     radius: 50,
//                     backgroundImage: imageProvider,
//                   ),
//                   placeholder: (context, url) => CircularProgressIndicator(),
//                   errorWidget: (context, url, error) => Icon(Icons.error),
//                 )
//                     : CircleAvatar(
//                   radius: 50,
//                   child: CircularProgressIndicator(),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: Icon(Icons.home),
//               title: Text('Home'),
//               onTap: () {
//                 // Handle Home tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.account_circle),
//               title: Text('Profile'),
//               onTap: () {
//                 // Handle Profile tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Settings'),
//               onTap: () {
//                 // Handle Settings tap
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('Logout'),
//               onTap: () {
//                 // Handle Logout tap
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 30),
//             Container(
//               height: 80,
//               width: 350,
//               margin: EdgeInsets.fromLTRB(1, 1, 1, 5),
//               padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
//               color: Colors.white,
//               child: Row(
//                 children: [
//                   SizedBox(width: 0),
//                   Expanded(
//                     child: Container(
//                       color: Colors.white,
//                       child: TextField(
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.search, color: Colors.black),
//                           hintText: 'Search',
//                           hintStyle: TextStyle(color: Colors.black),
//                           border: InputBorder.none,
//                         ),
//                         style: TextStyle(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: U_Sizes.spaceBwtSections,
//             ),
//             Container(
//               height: 200, // Ensuring the height is fixed for the PageView
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   isLoading
//                       ? buildShimmer()
//                       : PageView.builder(
//                     controller: _pageController,
//                     itemCount: imgList.length,
//                     onPageChanged: _onPageChanged,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black26,
//                               blurRadius: 10.0,
//                               spreadRadius: 2.0,
//                               offset: Offset(2.0, 2.0),
//                             ),
//                           ],
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(20),
//                           child: buildImage(imgList[index]),
//
//                         ),
//                       );
//                     },
//                   ),
//                   Positioned(
//                     left: 10,
//                     child: IconButton(
//                       icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
//                       onPressed: _previousImage,
//                     ),
//                   ),
//                   Positioned(
//                     right: 10,
//                     child: IconButton(
//                       icon: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
//                       onPressed: _nextImage,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: U_Sizes.spaceBwtSections,
//             ),
//             DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
//
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(width: 20),
//                 Text(
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                   "Gold Collection",
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             GestureDetector(
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10.0,
//                       spreadRadius: 2.0,
//                       offset: Offset(2.0, 2.0),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: goldCollectionImages.isNotEmpty
//                       ? buildImage(goldCollectionImages[0])
//                       : Container(),
//                 ),
//               ),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ProductHomeScreen()),
//                 );
//               },
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             SizedBox(
//               height: 100, // Height of each square image
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: shopByImages.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     width: 100, // Width of each square image
//                     margin: EdgeInsets.symmetric(horizontal: 5),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black45, width: 0.1),
//                       borderRadius: BorderRadius.circular(0),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(5),
//                       child: Image.asset(
//                         shopByImages[index],
//                         fit: BoxFit.fill,
//                         width: double.infinity,
//                         height: 150,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
//
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(width: 20),
//                 Text(
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                   "Diamond Collection",
//                 ),
//               ],
//             ),
//             SizedBox(height: U_Sizes.spaceBwtSections),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0,
//                     offset: Offset(2.0, 2.0),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: diamondCollectionImages.isNotEmpty
//                     ? buildImage(diamondCollectionImages[0])
//                     : Container(),
//               ),
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             SizedBox(
//               height: 100, // Height of each square image
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: shopByImages.length,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     width: 100, // Width of each square image
//                     margin: EdgeInsets.symmetric(horizontal: 5),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.black45, width: 0.1),
//                       borderRadius: BorderRadius.circular(0),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(5),
//                       child: Image.asset(
//                         shopByImages[index],
//                         fit: BoxFit.fill,
//                         width: double.infinity,
//                         height: 150,
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
//
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(width: 20),
//                 Text(
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                   "Custom Jewellery",
//                 ),
//               ],
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0,
//                     offset: Offset(2.0, 2.0),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: customJewelryImages.isNotEmpty
//                     ? buildImage(customJewelryImages[0])
//                     : Container(),
//               ),
//             ),
//             SizedBox(height: 20),
//             DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
//
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(width: 20),
//                 Text(
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                   "Women Collection",
//                 ),
//               ],
//             ),
//             SizedBox(height: 5),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0,
//                     offset: Offset(2.0, 2.0),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: womenCollectionImages.isNotEmpty
//                     ? buildImage(womenCollectionImages[0])
//                     : Container(),
//               ),
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
//
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(width: 20),
//                 Text(
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                   "Men Collection",
//                 ),
//               ],
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0,
//                     offset: Offset(2.0, 2.0),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: menCollectionImages.isNotEmpty
//                     ? buildImage(menCollectionImages[0])
//                     : Container(),
//               ),
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             DividerWithAvatar(imagePath: 'assets/logos/KALPCO_splash.png'),
//
//             const Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 SizedBox(width: 20),
//                 Text(
//                   style: TextStyle(
//                     fontWeight: FontWeight.w500,
//                     fontSize: 18,
//                   ),
//                   "Kids Collection",
//                 ),
//               ],
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(horizontal: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10.0,
//                     spreadRadius: 2.0,
//                     offset: Offset(2.0, 2.0),
//                   ),
//                 ],
//               ),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: kidsCollectionImages.isNotEmpty
//                     ? buildImage(kidsCollectionImages[0])
//                     : Container(),
//               ),
//             ),
//             SizedBox(height: U_Sizes.spaceBtwItems),
//             SizedBox(height: 10),
//             Row(
//               children: [
//                 SizedBox(width: 10),
//                 SizedBox(width: 5),
//               ],
//             ),
//             SizedBox(height: 10),
//             Center(
//               child: Text('Home Screen Content'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/features/product/screen/productHomeAppBar/common_top_bar.dart';
import 'package:onpensea/features/scheme/Screens/all_scheme_screen.dart';
import 'package:onpensea/navigation_menu.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../authentication/screens/login/Controller/LoginController.dart';
import '../../product/screen/productHome/products_home_screen.dart';
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
    String photoUrl = loginController.userData['photoUrl'];
    profileImageUrl =
        'http://103.108.12.222:11000/kalpco/version/v0.01$photoUrl';
    setState(() {});
  }

  Future<void> fetchImages() async {
    try {
      final cacheManager = DefaultCacheManager();
      final file = await cacheManager.getSingleFile(
          'http://103.108.12.222:11000/kalpco/version/v0.01/users/pictures?userType=U');

      if (file != null) {
        final response = await file.readAsString();
        List<dynamic> jsonResponse = json.decode(response);
        List<String> fetchedImages = List<String>.from(jsonResponse);

        // Assuming the response contains exactly 10 images
        if (fetchedImages.length >= 10) {
          setState(() {
            print("Image List: ");
            print(fetchedImages.toString());

            // Assign specific images to imgList by their indices
            imgList = [
              fetchedImages[0], // First image
              fetchedImages[3], // Fourth image
              fetchedImages[6],
              fetchedImages[5], // Seventh image
            ];

            // Assign specific images to other collections
            goldCollectionImages = [fetchedImages[1]]; // Second image
            diamondCollectionImages = [fetchedImages[8]]; // Ninth image
            customJewelryImages = [fetchedImages[4]]; // Fifth image
            menCollectionImages = [fetchedImages[9]]; // Tenth image
            womenCollectionImages = [fetchedImages[7]]; // Eighth image
            kidsCollectionImages = [fetchedImages[2]]; // Third image

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

  void _showFullScreenImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(10),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: profileImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) => Icon(Icons.error),
                placeholder: (context, url) => CircularProgressIndicator(),
              ),
              Positioned(
                top: 30,
                right: 30,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
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
                                // Handle the navigation based on the index
                                final navController =
                                    Get.find<NavigationController>();

                                switch (index) {
                                  case 0:
                                    navController.selectIndex.value =
                                        0; // Home Screen
                                    break;
                                  case 1:
                                    navController.selectIndex.value =
                                        2; // Explore Screen (this will redirect to investment)
                                    break;
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
                  MaterialPageRoute(
                      builder: (context) => ProductHomeScreen(
                          category: "gold", subCategory: "*")),
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
                              builder: (context) => ProductHomeScreen(
                                  category: "gold", subCategory: "*")),
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
                  MaterialPageRoute(
                      builder: (context) => ProductHomeScreen(
                          category: "diamond", subCategory: "*")),
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
                              builder: (context) => ProductHomeScreen(
                                  category: "gold", subCategory: "*")),
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
                  "Custom Jewellery",
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
                  MaterialPageRoute(
                      builder: (context) => ProductHomeScreen(
                          category: "custom", subCategory: "*")),
                );
              },
            ),
            SizedBox(height: 70),

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
                  "Women Collection",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 2.5, bottom: 5),
              child: DividerWithAvatar(
                  dividerThickness: 0.3,
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
                  child: womenCollectionImages.isNotEmpty
                      ? buildImage(womenCollectionImages[0])
                      : Container(),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductHomeScreen(
                          category: "women", subCategory: "*")),
                );
              },
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
                  "Men Collection",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 35.0, right: 35.0, top: 2.5, bottom: 5),
              child: DividerWithAvatar(
                  dividerThickness: 0.3,
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
                  child: menCollectionImages.isNotEmpty
                      ? buildImage(menCollectionImages[0])
                      : Container(),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProductHomeScreen(category: "men", subCategory: "*")),
                );
              },
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
                  "Kids Collection",
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
                  child: kidsCollectionImages.isNotEmpty
                      ? buildImage(kidsCollectionImages[0])
                      : Container(),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductHomeScreen(
                            category: "Kids",
                            subCategory: "*",
                          )),
                );
              },
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
