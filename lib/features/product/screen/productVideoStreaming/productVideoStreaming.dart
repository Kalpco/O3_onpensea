import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/commons/config/api_constants.dart';
import 'package:onpensea/navigation_menu.dart';
import 'package:video_player/video_player.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../productGridLayout/product_grid_layout.dart';
import '../video_Full_Screen.dart';

class ProductVideoStreaming extends StatefulWidget {
  const ProductVideoStreaming({super.key});

  @override
  State<ProductVideoStreaming> createState() => _ProductVideoStreamingState();
}

class _ProductVideoStreamingState extends State<ProductVideoStreaming> {
  final List<String> videoUrls = [
    '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_01.mp4',
    // 'http://o3api.kalpco.in/investments/kalpco/v1.0.0/investments/api/videos/download/videos/bangle_necklace_earing_02.mp4',
    '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_03.mp4',
    '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_04.mp4',
    '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_05.mp4',
  ];

  late List<VideoPlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = videoUrls
        .map((videoUrl) => VideoPlayerController.network(videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Rebuild UI when the video is initialized
      }))
        .toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose(); // Dispose of all controllers when the widget is disposed
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAll(() => NavigationMenu());
          },
        ),
        title: Text(
          "Jewellery Collection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(U_Sizes.spaceBwtTwoSections),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                ProductGridLayout(
                  itemCount: videoUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // Navigate to full-screen video player
                        Get.to(() => FullScreenVideoPlayer(
                          videoUrl: videoUrls[index],
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10.0,
                              spreadRadius: 2.0,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Display video player thumbnail (the first frame of the video)
                            _controllers[index].value.isInitialized
                                ? AspectRatio(
                              aspectRatio: _controllers[index].value.aspectRatio,
                              child: VideoPlayer(_controllers[index]),
                            )
                                : Container(
                              width: double.infinity,
                              height: 250,
                              color: Colors.black.withOpacity(0.4),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: U_Colors.yaleBlue,), // Show a loading indicator while initializing
                              ),
                            ),
                            // Play button icon overlay
                            Icon(
                              Icons.play_circle_filled,
                              color: Colors.white.withOpacity(0.4),
                              size: 64,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  mainAxisExtent: 250, // Adjust the height of each grid item
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
