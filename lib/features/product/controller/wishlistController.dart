import 'package:get/get.dart';
import 'package:onpensea/features/product/models/products.dart';

class WishlistController extends GetxController {
  var wishlist = <ProductResponseDTO>[].obs;

  void addToWishlist(ProductResponseDTO product) {
    if (!wishlist.contains(product)) {
      wishlist.add(product);
    }
  }

  void removeFromWishlist(ProductResponseDTO product) {
    wishlist.remove(product);
  }

  bool isInWishlist(ProductResponseDTO product) {
    return wishlist.contains(product);
  }
}
