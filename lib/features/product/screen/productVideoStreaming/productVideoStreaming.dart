import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:onpensea/navigation_menu.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/jwt/services/jwt_service.dart';
import '../productGridLayout/product_grid_layout.dart';
import '../video_Full_Screen.dart';
import 'package:onpensea/commons/config/api_constants.dart';

class ProductVideoStreaming extends StatefulWidget {
  const ProductVideoStreaming({super.key});

  @override
  State<ProductVideoStreaming> createState() => _ProductVideoStreamingState();
}

class _ProductVideoStreamingState extends State<ProductVideoStreaming> {
  List<String> videoUrls = [];
  List<VideoPlayerController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _fetchVideoUrlsWithToken(); // Load video URLs with JWT
  }

  /// **🔹 Fetch Video URLs with JWT Token**
  Future<void> _fetchVideoUrlsWithToken() async {
    String? token = await JwtService.getToken();
    if (token == null) {
      print("❌ No JWT Token found! Cannot fetch videos.");
      return;
    }

    // Append JWT token to URLs
    List<String> rawUrls = [
      '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_01.mp4',
      '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_03.mp4',
      '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_04.mp4',
      '${ApiConstants.INVESTMENTMS_URL}/api/videos/download/videos/bangle_necklace_earing_05.mp4',
    ];

    videoUrls = rawUrls.map((url) => '$url?token=$token').toList();

    // ✅ Use `networkUrl(Uri.parse(videoUrl))` instead of `network(videoUrl)`
    _controllers = videoUrls.map((videoUrl) {
      return VideoPlayerController.networkUrl(Uri.parse(videoUrl))
        ..initialize().then((_) {
          setState(() {}); // Update UI after initialization
        });
    }).toList();

    setState(() {}); // Trigger UI update
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.offAll(() => NavigationMenu());
          },
        ),
        title: const Text(
          "Jewellery Collection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: U_Colors.yaleBlue,
      ),
      body: videoUrls.isEmpty
          ? const Center(child: CircularProgressIndicator(color: U_Colors.yaleBlue)) // Show loading until URLs are ready
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(U_Sizes.spaceBwtTwoSections),
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
                          boxShadow: const [
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
                            // Display video player thumbnail (first frame)
                            _controllers[index].value.isInitialized
                                ? AspectRatio(
                              aspectRatio: _controllers[index].value.aspectRatio,
                              child: VideoPlayer(_controllers[index]),
                            )
                                : Container(
                              width: double.infinity,
                              height: 250,
                              color: Colors.black.withOpacity(0.4),
                              child: const Center(
                                child: CircularProgressIndicator(color: U_Colors.yaleBlue),
                              ),
                            ),
                            // Play button overlay
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
                  mainAxisExtent: 250, // Adjust height of each grid item
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
