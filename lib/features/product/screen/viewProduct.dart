import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewProductPage extends StatefulWidget {
   @override
  _ViewProductPage createState() => _ViewProductPage();
}
class _ViewProductPage extends State<ViewProductPage>{
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
      appBar: AppBar(
        title: Text('Product Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 200,
              width: double.infinity,
              child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 16 / 9,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: false,
          ),
          items: _carouselItems,
        ),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8.0),
              //   image: DecorationImage(
              //     image: NetworkImage('https://via.placeholder.com/150'),
              //     fit: BoxFit.cover,
              //   ),
              // ),

            ),
            SizedBox(height: 16),
            
            // Product Description
            Text(
              'Product Description',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This is a great product that you will love to have. It has many features and benefits that make it worth the price.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),

            // Product Owner Name
            Text(
              'Owner: John Doe',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16),

            // Price
            Text(
              '\$99.99',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            Spacer(),
            
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle add to cart action
                  },
                  child: Text('Add to Cart'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle pay action
                  },
                  child: Text('Pay'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}