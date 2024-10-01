import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:iconsax/iconsax.dart';

import 'package:onpensea/features/product/screen/product_list.dart';
import 'package:onpensea/utils/constants/sizes.dart';


class RatingnShare extends StatelessWidget {
  const RatingnShare({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Iconsax.star5,color: Colors.amber,size: 24),
            SizedBox(width: U_Sizes.spaceBtwItems/2),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '5.0',style: Theme.of(context).textTheme.bodyLarge),
                  const TextSpan(text: '(199)'),
                ]
              )
            )
          ],
        ),
        IconButton(onPressed: (){
          _showShareDialog(context);
        }, icon: const Icon(Icons.share,size:U_Sizes.iconMd))
      ],
    );
  }

  Future<void> _showShareDialog(BuildContext context) async {
    final String appLink = 'https://play.google.com/store/apps/details?id=com.intech.onpensea&hl=en';
    final String message = 'Check out Kalpco app';

    // Share the app link and message using the share dialog
    await FlutterShare.share(title: 'Share App', text: message, linkUrl: appLink);
  }
  }
