// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kalpco/features/product/models/products.dart';
// import 'package:kalpco/utils/constants/sizes.dart';
// import 'package:photo_view/photo_view.dart';

// class ImageSliderController extends GetxController{
//   static ImageSliderController get instance => Get.find();


//   void showEnlargedImage(String image){
//     Get.to(
//       fullscreenDialog: true,
//       () => Dialog.fullscreen(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Padding(padding: const EdgeInsets.symmetric(vertical: U_Sizes.defaultSpace * 2,horizontal: U_Sizes.defaultSpace),
//             // child: CachedNetworkImage(imageUrl: image,),),
//             PhotoView(imageProvider: CachedNetworkImageProvider(image), backgroundDecoration: BoxDecoration(color: Colors.black),),
//             const SizedBox(height: U_Sizes.spaceBwtSections,),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: SizedBox(width: 150,child: OutlinedButton(onPressed: ()=> Get.back(), child: const Text('Close')),),
//             )
//           ],
//         ),
//       )
//     );
//   }
// }