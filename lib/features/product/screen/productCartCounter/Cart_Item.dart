class CartItem {
  final String productId;
  final String image;
  final String description;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.image,
    required this.description,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      image: json['image'],
      description: json['description'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
    );
  }
}

class Cart {
  final String cartId;
  final List<CartItem> items;

  Cart({
    required this.cartId,
    required this.items,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<CartItem> itemsList = itemsJson.map((i) => CartItem.fromJson(i)).toList();

    return Cart(
      cartId: json['cartId'],
      items: itemsList,
    );
  }
}
