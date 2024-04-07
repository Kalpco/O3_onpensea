import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../Controller/product_controller.dart';
import '../Models/Product.dart';
import '../Utils/app_color.dart';
import '../Widgets/carousel_slider.dart';
import '../Widgets/page_wrapper.dart';

final ProductController controller = Get.put(ProductController());

class PropertyDetailsScreen extends StatelessWidget {
  final Product product;
  final String screenStatus;

  const PropertyDetailsScreen(this.product,  {super.key, required this.screenStatus });

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
    );
  }

  Widget productPageView(double width, double height) {
    return Container(
      height: height * 0.42,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xFFE5E6E8),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(200),
          bottomLeft: Radius.circular(200),
        ),
      ),
      child: CarouselSlider(items: product.images),
    );
  }
  Widget _ratingBar(BuildContext context) {
    return Wrap(
      spacing: 30,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: product.rating,
          direction: Axis.horizontal,
          itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (_) {},
        ),
        Text(
          "(4500 Reviews)",
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w300),
        )
      ],
    );
  }
  Widget productSizesListView() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: controller.sizeType(product).length,
      itemBuilder: (_, index) {
        return InkWell(
          onTap: () => controller.switchBetweenProductSizes(product, index),
          child: AnimatedContainer(
            margin: const EdgeInsets.only(right: 5, left: 5),
            alignment: Alignment.center,
            width: controller.isNominal(product) ? 40 : 70,
            decoration: BoxDecoration(
              color: controller.sizeType(product)[index].isSelected == false
                  ? Colors.white
                  : AppColor.lightOrange,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey, width: 0.4),
            ),
            duration: const Duration(milliseconds: 300),
            child: FittedBox(
              child: Text(
                controller.sizeType(product)[index].numerical,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                productPageView(width, height),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: Theme.of(context).textTheme.titleLarge,

                      ),
                      const SizedBox(height: 10),
                      _ratingBar(context),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            product.off != null
                                ? "\u{20B9}${product.off}"
                                : "\u{20B9}${product.price}",
                            style: Theme.of(context).textTheme.titleLarge,

                          ),
                          const SizedBox(width: 1),
                          Visibility(
                            visible: product.off != null ? true : false,
                            child: Text(
                              "\u{20B9}${product.price}",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            product.isAvailable
                                ? "Available in stock"
                                : "Not available",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Token Name : PALAVA ",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Token Symbol : PAL ",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Token Available : 150000 ",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                     /* const SizedBox(height: 10),

                      Text(product.about),
                     */ const SizedBox(height: 20),
                      Text('Owner Name : Lodha Properties '),
                      const SizedBox(height: 20),
                      Text('Property Id : O3-123231 '),

                      const SizedBox(height: 20),
                      Text('Properties Registred Date: 02-August-2023'),
                      const SizedBox(height: 20),
                      Text('Address: Near Lodha World School, Kalyan - Shilphata Rd, Dombivli, Maharashtra 421204'),
                     /* SizedBox(
                        height: 40,
                        child: GetBuilder<ProductController>(
                          builder: (_) => productSizesListView(),
                        ),
                      ),
       */               const SizedBox(height: 20),
                      new TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                          hintText: '1234',
                          labelText: 'TOKEN COUNT'
                        ),
                      ),
                      new TextFormField(
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                            hintText: 'Any Remarks by Buyer',
                            labelText: 'REMARKS'
                        ),
                      ),
                      const SizedBox(height: 10),



                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: product.isAvailable
                              ? () => controller.addToCart(product)
                              : null,
                          child:  screenStatus=='sell'?Text("Sell"):Text('Buy'),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
