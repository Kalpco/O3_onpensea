import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onpensea/commons/config/ApiUrl.dart';
import 'package:video_player/video_player.dart';

class AboutWidget extends StatefulWidget {
  late VideoPlayerController controller;
  late List<String> aboutScheme;
  late String investmentType;
  String? imageUrl;

  AboutWidget({
    super.key,
    required String imageUrl,
    required this.controller,
    required this.aboutScheme,
    required this.investmentType,
  });

  @override
  State<AboutWidget> createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xffEEEEEE), width: 1.2),
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                widget.controller.value.isPlaying
                    ? widget.controller.pause()
                    : widget.controller.play();
              });
            },
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: AspectRatio(
                aspectRatio: widget.controller.value.isInitialized
                    ? widget.controller.value.aspectRatio
                    : 16 / 9,
                child: widget.investmentType == "scheme"
                    ? Image.network(
                        '${ApiUrl.INVESTMENT_SCHEME}${widget.imageUrl}',
                        // Replace with your image asset
                        fit: BoxFit.cover,
                      )
                    : widget.controller.value.isInitialized
                        ? VideoPlayer(widget.controller)
                        : const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // About scheme text
          Text(
            widget.investmentType == "scheme"
                ? "About Scheme"
                : "About Property",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 8),
          AboutMapWidget(
            listOfAbout: widget.aboutScheme,
          )
        ],
      ),
    );
  }
}

class AboutMapWidget extends StatelessWidget {
  const AboutMapWidget({super.key, required this.listOfAbout});

  final List<String> listOfAbout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listOfAbout.asMap().entries.map((example) {
        int index = example.key;
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Text(
            example.value,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade800,
            ),
          ),
        );
      }).toList(),
    );
  }
}
