import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:onpensea/features/product/screen/viewProduct.dart';
import 'package:video_player/video_player.dart';

class CarouselWithImagesAndVideos extends StatefulWidget {
  @override
  _CarouselWithImagesAndVideosState createState() => _CarouselWithImagesAndVideosState();
}

class _CarouselWithImagesAndVideosState extends State<CarouselWithImagesAndVideos> {
  late List<Widget> _carouselItems;
  late VideoPlayerController _videoController;
   bool _isVideoPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/gold/4.mp4')
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after the video is initialized
      })
       ..addListener(() {
        setState(() {
          _isVideoPlaying = _videoController.value.isPlaying;
        });
      });

    _carouselItems = [
      Image.asset('assets/gold/1.jpg', fit: BoxFit.cover),
      Image.asset('assets/gold/2.jpg', fit: BoxFit.cover),
       Image.asset('assets/gold/3.jpg', fit: BoxFit.cover),
        
      _buildVideoPlayer(),
    ];
  }

  Widget _buildVideoPlayer() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _videoController.value.isPlaying ? _videoController.pause() : _videoController.play();
              });
            },
            child: VideoPlayer(_videoController),
          ),
        ),
        if (!_videoController.value.isPlaying)
          Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 100.0,
          ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Products with Images and Videos'),
    //     actions: <Widget>[
    //      IconButton(
    //    onPressed: () => Navigator.of(context)
    //           .push(MaterialPageRoute(builder: (context) =>  ViewProductPage())),
    //    icon: Icon(Icons.code),
    //  ),
    //     ]
    //   ),
      body: Center(
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: false,
          ),
          items: _carouselItems,
        ),
      ),
    );
  }
}