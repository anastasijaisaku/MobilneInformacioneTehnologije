import 'package:flutter/material.dart';
import 'package:biblioteka/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartModel> _cartItems = {};

  Map<String, CartModel> get getCartItems => _cartItems;

  bool isInCart(String productId) {
    return _cartItems.containsKey(productId);
  }

  void addToCart({
    required String productId,
    required String title,
    required String price, // cuvas kao string u modelu
    required String imageUrl,
  }) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existing) => existing.copyWith(
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartModel(
          cartId: DateTime.now().microsecondsSinceEpoch.toString(),
          productId: productId,
          title: title,
          price: price,
          imageUrl: imageUrl,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity({
    required String productId,
    required int quantity,
  }) {
    if (!_cartItems.containsKey(productId)) return;

    if (quantity <= 0) {
      _cartItems.remove(productId);
    } else {
      _cartItems.update(
        productId,
        (existing) => existing.copyWith(quantity: quantity),
      );
    }
    notifyListeners();
  }

  void removeOneItem(String productId) {
    if (!_cartItems.containsKey(productId)) return;

    final current = _cartItems[productId]!;
    if (current.quantity <= 1) {
      _cartItems.remove(productId);
    } else {
      _cartItems.update(
        productId,
        (existing) => existing.copyWith(quantity: existing.quantity - 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get totalItems {
    int total = 0;
    for (final item in _cartItems.values) {
      total += item.quantity;
    }
    return total;
  }

  double get totalPrice {
    double total = 0.0;
    for (final item in _cartItems.values) {
      final p = double.tryParse(item.price) ?? 0.0;
      total += p * item.quantity;
    }
    return total;
  }

  int get totalProducts => _cartItems.length;
}
