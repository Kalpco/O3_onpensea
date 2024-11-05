
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/features/product/screen/productVideoStreaming/productVideoStreaming.dart';
import 'package:video_player/video_player.dart';

import '../../../utils/constants/colors.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const FullScreenVideoPlayer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Get.offAll(() => ProductVideoStreaming()); // Close the fullscreen player
          },
        ),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
          alignment: Alignment.center,
          children: [
            // The video player
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            // Play/pause button centered on the video
            IconButton(
              iconSize: 64,
              icon: Icon(
                isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                color: Colors.white.withOpacity(0.4),
              ),
              onPressed: () {
                setState(() {
                  if (isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
                  }
                  isPlaying = !isPlaying;
                });
              },
            ),
          ],
        )
            : CircularProgressIndicator(color: U_Colors.yaleBlue,), // Show loader while initializing
      ),
    );
  }
}
