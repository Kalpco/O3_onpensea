import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import '../Controller/product_controller.dart';

import '../Models/Product.dart';
import '../Models/categorical.dart';
import '../Models/numerical.dart';
import '../Models/product_category.dart';
import '../Models/product_size_type.dart';
import '../Utils/AppData.dart';
import '../Widgets/list_item_selector.dart';
import '../Widgets/product_grid_view.dart';
import 'PropertyDetailsScreen.dart';

enum AppbarActionType { leading, trailing }
final ProductController controller = Get.put(ProductController());
class PropertyListScreen extends StatelessWidget {


  final String screenStatus;

  const PropertyListScreen({super.key, required this.screenStatus});

  static List<Product> products = [
    Product(
      name: 'Palava Properties , Navi Mumbai',
      price: 85000,
      about: 'about',
      isAvailable: true,
      off: 60000,
      quantity: 0,
      images: [
        'assets/images/1.png',
        'assets/images/second.png',
        'assets/images/3.png'
      ],
      isFavorite: true,
      rating: 1,
      type: ProductType.mobile,
    ),
    Product(
      name: 'Lodha Properties, Mumbai',
      price: 55000,
      about: 'dummyText',
      isAvailable: false,
      off: 47999,
      quantity: 0,
      images: [
        'assets/images/4.png',
        'assets/images/1.png',
        'assets/images/1.png'
      ],
      isFavorite: false,
      rating: 4,
      type: ProductType.tablet,
    ),
    Product(
      name: 'Jain Properties, Mumbai',
      price: 45000,
      about: 'dummyText',
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/5.png',
        'assets/images/7.png',
        'assets/images/6.png',
      ],
      isFavorite: false,
      rating: 3,
      type: ProductType.tablet,
    ),
    Product(
      name: 'Arihant Properties, Mumabi & Pune',
      price: 99000,
      about: 'dummyText',
      isAvailable: true,
      off: 100000,
      quantity: 0,
      images: [
        'assets/images/second.png',
        'assets/images/3.png',
        'assets/images/10.png',
      ],
      isFavorite: false,
      rating: 5,
      sizes: ProductSizeType(
        categorical: [
          Categorical(CategoricalType.small, true),
          Categorical(CategoricalType.medium, false),
          Categorical(CategoricalType.large, false),
        ],
      ),
      type: ProductType.watch,
    ),
    Product(
      name: 'Matruchaya Complex, Mumbai',
      price: 30000,
      about: 'dummyText',
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/6.png',
        'assets/images/11.png',
        'assets/images/4.png',
      ],
      isFavorite: false,
      rating: 4,
      sizes: ProductSizeType(
        numerical: [Numerical('41', true), Numerical('45', false)],
      ),
      type: ProductType.watch,
    ),
    Product(
        name: 'Talakeri Properties',
        price: 99999,
        about: 'dummyText',
        isAvailable: true,
        off: null,
        quantity: 0,
        images: [
          'assets/images/7.png',
          'assets/images/second.png',
          'assets/images/.png',
          'assets/images/4.png',
        ],
        isFavorite: false,
        rating: 2,
        type: ProductType.headphone),
    Product(
      name: 'RX Proprties, Pune',
      price: 67700,
      about: 'dummyText',
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/8.png',
        'assets/images/6.png',
      ],
      isFavorite: false,
      rating: 3,
      sizes: ProductSizeType(
        numerical: [
          Numerical('43', true),
          Numerical('50', false),
          Numerical('55', false)
        ],
      ),
      type: ProductType.tv,
    ),
    Product(
      name: 'Lodha Properties,Pune',
      price: 65000,
      about: 'dummyText',
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/11.png',
        'assets/images/3.png',
      ],
      isFavorite: false,
      sizes: ProductSizeType(
        numerical: [
          Numerical('50', true),
          Numerical('65', false),
          Numerical('85', false)
        ],
      ),
      rating: 2,
      type: ProductType.tv,
    ),
    Product(
      name: 'Jeeva Properies,Bangalore ',
      price: 89999,
      about: 'dummyText',
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/10.png',
        'assets/images/7.png',
      ],
      isFavorite: false,
      sizes: ProductSizeType(
        numerical: [
          Numerical('50', true),
          Numerical('65', false),
          Numerical('85', false)
        ],
      ),
      rating: 2,
      type: ProductType.tv,
    ),
    Product(
      name: 'TVS Properties,All India ',
      price: 80000,
      about: 'dummyText',
      isAvailable: true,
      off: null,
      quantity: 0,
      images: [
        'assets/images/13.png',
        'assets/images/10.png',
      ],
      isFavorite: false,
      sizes: ProductSizeType(
        numerical: [
          Numerical('50', true),
          Numerical('65', false),
          Numerical('85', false)
        ],
      ),
      rating: 2,
      type: ProductType.tv,
    ),
  ];

  static List<ProductCategory> categories = [
    ProductCategory(
      ProductType.all,
      true,
      Icons.home,
    ),
    ProductCategory(
      ProductType.mobile,
      false,
      FontAwesomeIcons.building,
    ),
    ProductCategory(ProductType.watch, false, Icons.local_mall),
    ProductCategory(
      ProductType.tablet,
      false,
      FontAwesomeIcons.hospital,
    ),
    ProductCategory(
      ProductType.headphone,
      false,
      Icons.token,
    ),
    ProductCategory(
      ProductType.tv,
      false,
      Icons.apartment,
    ),
  ];

  Widget appBarActionButton(AppbarActionType type) {
    IconData icon = Icons.shopping_cart;

    if (type == AppbarActionType.trailing) {
      icon = Icons.search;
    }
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        onPressed: () {},
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       extendBodyBehindAppBar: true,
       appBar: _appBar,
       body: SafeArea(
         child: SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Padding(
             padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello Abhishek',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                screenStatus=='buy'?Text(
                  "Lets Buy something?",
                  style: Theme.of(context).textTheme.headlineSmall,
                ):Text(
                  "Lets Sell something?",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                 _recommendedProductListView(context),

                _topCategoriesHeader(context),
                _topCategoriesListView(context),
                GetBuilder(builder: (ProductController controller) {
                  return ProductGridView(
                    items: products,
                    likeButtonPressed: (index) => controller.isFavorite(index),
                    isPriceOff: (product) => true, screenStatus: screenStatus,
                  );
                }),
              ],
            ),
           ),
         ),
       ),

     );
  }
  Widget _topCategoriesListView(BuildContext context) {
    return ListItemSelector(
      categories: categories,
      onItemPressed: (index) {
        controller.filterItemsByCategory(index);
       /* Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropertyDetailsScreen()),
        );
*/
      },
    );
  }

  Widget _recommendedProductListView(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: AppData.recommendedProducts.length,
          itemBuilder: (_, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Container(
                width: 300,
                decoration: BoxDecoration(
                  color: AppData.recommendedProducts[index].cardBackgroundColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          screenStatus=='sell'?Text(
                            '23 People Intrested to Buy',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall

                                ?.copyWith(color: Colors.white),
                          ): Text(
                            '10% off on Diwali',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall

                                ?.copyWith(color: Colors.white),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppData
                                  .recommendedProducts[index]
                                  .buttonBackgroundColor,
                              elevation: 0,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child:  screenStatus=='buy'? Text(
                              "Buy Now",
                              style: TextStyle(
                                color: AppData.recommendedProducts[index]
                                    .buttonTextColor!,
                              ),
                            ):Text(
                                "Sell Now",
                                style: TextStyle(
                                  color: AppData.recommendedProducts[index]
                                      .buttonTextColor!,
                                ),
                          ))
                        ],
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/shopping.png',
                      height: 125,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  PreferredSize get _appBar {
    return PreferredSize(
      preferredSize: const Size.fromHeight(100),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appBarActionButton(AppbarActionType.leading),
              appBarActionButton(AppbarActionType.trailing),
            ],
          ),
        ),
      ),
    );
  }
}
Widget _topCategoriesHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Top categories",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
          child: Text(
            "SEE ALL",
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.deepOrange.withOpacity(0.7)),
          ),
        )
      ],
    ),
  );
}


