import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';

class U_RoundedImage extends StatelessWidget {
  U_RoundedImage( {
    super.key,
    this.border,
    this.padding,
    this.onPressed,
    this.width,
    this.height,
    this.applyImageRadius = true,
    required this.imageUrl,
    this.fit = BoxFit.contain,
    this.backgroundColor,
    this.isNetworkImage = true,
    this.borderRadius = U_Sizes.md,
    this.isSelected = false,
  });

  final double? width,height;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry?padding;
  final bool isNetworkImage;
  final VoidCallback?onPressed;
  final double borderRadius;
  final bool isSelected;


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(border: border ?? (isSelected ? Border.all(color:U_Colors.satinSheenGold, width: 3) : null),color: backgroundColor,borderRadius: BorderRadius.circular(borderRadius)),
        child: ClipRRect(
          borderRadius: applyImageRadius ? BorderRadius.circular(borderRadius):BorderRadius.zero,
          // child: Image(fit:fit,image: isNetworkImage ? NetworkImage(imageUrl):AssetImage(imageUrl) as ImageProvider),
          child: isNetworkImage ? CachedNetworkImage(imageUrl: imageUrl,fit: fit,
            progressIndicatorBuilder: (context,url,downloadProgress) => Center(
              child: CircularProgressIndicator(value: downloadProgress?.progress,color: U_Colors.yaleBlue),
            ),
            errorWidget: (context,url,error) => Icon(Icons.error),
          )
              : Image.asset(imageUrl, fit: fit),
        ),
      ),
    );
  }
}