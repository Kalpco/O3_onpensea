import 'package:flutter/material.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class ProductVerticalImageText extends StatelessWidget {
  const ProductVerticalImageText({
    super.key, required this.image, required this.title,  this.textColor=U_Colors.whiteColor, this.backgroundColor=Colors.transparent, this.onTap,
  });


  final String image,title;
  final Color textColor;
  final Color ? backgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = U_Helper.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: U_Sizes.iconSm),
        child: Column(children: [
          //circular icon
          Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(U_Sizes.sm),
            decoration: BoxDecoration(
              color: backgroundColor ?? (dark? U_Colors.black : U_Colors.satinSheenGold),
              borderRadius: BorderRadius.circular(120),
              border: Border.all(color: U_Colors.yaleBlue)
                                  
            ),
            child: ClipOval(child: Image(image: AssetImage(image),fit: BoxFit.cover,)),
            
                                  
          ),
          //const SizedBox(height: U_Sizes.spaceBtwItems / 2,),
          SizedBox(width: 55, child: Center(
            child: Text(title,style: Theme.of(context).textTheme.labelMedium!.apply(color: textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,),
          ))
        ],),
      ),
    );
  }
}