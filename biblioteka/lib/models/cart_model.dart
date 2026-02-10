class CartModel {
  final String cartId;
  final String productId;
  final String title;
  final String price;
  final String imageUrl;
  final int quantity;

  const CartModel({
    required this.cartId,
    required this.productId,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  CartModel copyWith({
    String? cartId,
    String? productId,
    String? title,
    String? price,
    String? imageUrl,
    int? quantity,
  }) {
    return CartModel(
      cartId: cartId ?? this.cartId,
      productId: productId ?? this.productId,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
    );
  }
}
