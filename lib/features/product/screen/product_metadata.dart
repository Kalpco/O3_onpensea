import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onpensea/features/product/models/products.dart';
import 'package:onpensea/utils/constants/colors.dart';
import 'package:onpensea/utils/constants/product_price.dart';
import 'package:onpensea/utils/constants/product_title.dart';
import 'package:onpensea/utils/constants/rounded_container.dart';
import 'package:onpensea/utils/constants/sizes.dart';
import 'package:onpensea/utils/helper/helper_functions.dart';

class ProductMetaData extends StatelessWidget{
   
  ProductMetaData({super.key,required this.product});
  
  ProductResponseDTO product;
 
  @override
  Widget build(BuildContext context) {

    final dark = U_Helper.isDarkMode(context);
  

    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Row(
          children: [
            //sale tag
            // RoundedContainer(
            //   radius: U_Sizes.sm,
            //   backgroundColor: U_Colors.secondaryColor.withOpacity(0.8),
            //   padding: const EdgeInsets.symmetric(horizontal: U_Sizes.sm,vertical: U_Sizes.xs),
            //   child: Text('12%',style: Theme.of(context).textTheme.labelLarge!.apply(color:U_Colors.black)),
            // ),
           // const SizedBox(width: U_Sizes.spaceBtwItems),
            //price
           // Text('\₹99999',style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough)),
           // const SizedBox(width: U_Sizes.spaceBtwItems),
             ProductPrice(price: product.productPrice!.toStringAsFixed(2),isLarge: true,),
          ],
        ),
        //title
        const SizedBox(height: U_Sizes.spaceBtwItems / 1.5),
        ProductTitleText(title: product.productName! ,smallSize:false),

        //const SizedBox(height: U_Sizes.spaceBtwItems / 1.5),
        //stock
        // Row(
        //   children: [
        //     const ProductTitleText(title: 'Purity'),
        //      const SizedBox(width: U_Sizes.spaceBtwItems),
        //      Text(' 22 K',style: Theme.of(context).textTheme.titleMedium),
        //   ],
        // ),
       
      ],
    );
  }

}