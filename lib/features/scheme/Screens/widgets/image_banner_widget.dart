import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:onpensea/commons/config/api_constants.dart";

import "../../../../commons/styles/custom_border_radius.dart";
import "../../../scheme/Widgets/Skeleton.dart";

class ImageBannerWidget extends StatelessWidget {
  const ImageBannerWidget({super.key, required this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: CustomBorderRadius.borderRadius32,
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: CachedNetworkImage(
        imageUrl: "${ApiConstants.INVESTMENTMS_URL}${image}",
        placeholder: (context, url) => const Skeleton(
          width: double.infinity,
          height: 189,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.contain,
      ),
    );
  }
}
