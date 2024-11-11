import 'package:flutter/material.dart';
import 'package:onpensea/features/product/screen/productImageText/product_vertical_image_text.dart';
import 'package:onpensea/utils/constants/images_path.dart';

import 'adminProductSubCategoryPage.dart';


class AdminProductHomeCategory extends StatefulWidget {
  final String? productCategory,typeOfStone;

  AdminProductHomeCategory({required this.productCategory, required this.typeOfStone});


  @override
  State<AdminProductHomeCategory> createState() => _AdminProductHomeCategoryState();
}

class _AdminProductHomeCategoryState extends State<AdminProductHomeCategory> {
  @override
  Widget build(BuildContext context) {

        final List<Map<String, dynamic>> categoryItems = [
      {'image': U_ImagePath.ring, 'title': 'Ring', 'productSubCategory':  'Ring'},
      {'image': U_ImagePath.necklace, 'title': 'Necklace','productSubCategory':  'Necklace' },
      {'image': U_ImagePath.bracelet, 'title': 'Bracelet','productSubCategory':  'Bracelet' },
      {'image': U_ImagePath.earings, 'title': 'Earing','productSubCategory':  'Earing' },
      {'image': U_ImagePath.pendant, 'title': 'Pendant','productSubCategory':  'Pendant' },
      {'image': U_ImagePath.bangles, 'title': 'Bangle','productSubCategory':  'Bangle' },
          {'image': U_ImagePath.chain, 'title': 'Chain','productSubCategory':  'Chain' },

        ];

    return SizedBox(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: categoryItems.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_,index){
          final myCategory = categoryItems[index];
          return ProductVerticalImageText(image: myCategory['image'],title: myCategory['title'],onTap: () => _handleTap(context,myCategory['productSubCategory']),);
        }),
    );
  }

    void _handleTap(BuildContext context, String param) async {
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => AdminProductSubCategoryDetailPage(productCategory:widget.productCategory,typeOfStone:widget.typeOfStone,productSubCategory: param.toUpperCase()),
      //   ),(Route<dynamic> route)=>false,
      // );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminProductSubCategoryDetailPage(productCategory:widget.productCategory,typeOfStone:widget.typeOfStone,productSubCategory: param),)
      );




      //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$category tapped!')));
  }
}