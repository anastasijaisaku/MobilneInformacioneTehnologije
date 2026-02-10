import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:biblioteka/providers/cart_provider.dart';

class OrdersService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createOrderFromCart(CartProvider cart) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }
    if (cart.getCartItems.isEmpty) {
      throw Exception("Cart is empty");
    }

    final items = cart.getCartItems.values.map((e) {
      return {
        "productId": e.productId,
        "title": e.title,
        "price": double.tryParse(e.price) ?? 0.0, 
        "imageUrl": e.imageUrl,
        "quantity": e.quantity,
      };
    }).toList();

    final doc = await _db.collection('orders').add({
      "uid": user.uid,
      "items": items,
      "totalPrice": cart.totalPrice, 
      "totalItems": cart.totalItems,
      "totalProducts": cart.totalProducts,
      "status": "created",
      "createdAt": FieldValue.serverTimestamp(),
    });

    return doc.id;
  }
}
