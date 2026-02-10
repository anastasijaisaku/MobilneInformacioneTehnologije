import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:biblioteka/models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription<User?>? _authSub;

  String? _uid;

  final Map<String, CartModel> _cartItems = {};
  Map<String, CartModel> get getCartItems => _cartItems;

  CartProvider() {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        _uid = null;
        _cartItems.clear();
        notifyListeners();
      } else {
        _uid = user.uid;
        await loadCartFromFirestore();
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  bool get isLoggedIn => _uid != null;

  bool isInCart(String productId) => _cartItems.containsKey(productId);

  DocumentReference<Map<String, dynamic>> _cartDoc() {
    // carts/{uid}
    return _db.collection('carts').doc(_uid!);
  }

  CollectionReference<Map<String, dynamic>> _itemsCol() {
    // carts/{uid}/items
    return _cartDoc().collection('items');
  }

  Future<void> loadCartFromFirestore() async {
    if (_uid == null) return;

    final snap = await _itemsCol().get();
    _cartItems.clear();

    for (final d in snap.docs) {
      final data = d.data();

      final qtyRaw = data['quantity'];
      final int qty = (qtyRaw is num) ? qtyRaw.toInt() : 1;

      _cartItems[d.id] = CartModel(
        cartId: (data['cartId'] ?? '').toString(),
        productId: d.id,
        title: (data['title'] ?? '').toString(),
        price: (data['price'] ?? '0').toString(),
        imageUrl: (data['imageUrl'] ?? '').toString(),
        quantity: qty,
      );
    }

    notifyListeners();
  }

  Future<void> addToCart({
    required String productId,
    required String title,
    required String price, // string
    required String imageUrl,
  }) async {
    // guest: lokalno
    if (_uid == null) {
      if (_cartItems.containsKey(productId)) {
        _cartItems.update(
          productId,
          (existing) => existing.copyWith(quantity: existing.quantity + 1),
        );
      } else {
        _cartItems[productId] = CartModel(
          cartId: DateTime.now().microsecondsSinceEpoch.toString(),
          productId: productId,
          title: title,
          price: price,
          imageUrl: imageUrl,
          quantity: 1,
        );
      }
      notifyListeners();
      return;
    }

    // logged-in
    final nowId = DateTime.now().microsecondsSinceEpoch.toString();

    //upiši/refreshuj root doc carts/{uid}
    await _cartDoc().set({
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    if (_cartItems.containsKey(productId)) {
      final current = _cartItems[productId]!;
      final newQty = current.quantity + 1;

      _cartItems[productId] = current.copyWith(quantity: newQty);
      notifyListeners();

      await _itemsCol().doc(productId).set({
        "cartId": current.cartId,
        "title": current.title,
        "price": current.price,
        "imageUrl": current.imageUrl,
        "quantity": newQty,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } else {
      final item = CartModel(
        cartId: nowId,
        productId: productId,
        title: title,
        price: price,
        imageUrl: imageUrl,
        quantity: 1,
      );

      _cartItems[productId] = item;
      notifyListeners();

      await _itemsCol().doc(productId).set({
        "cartId": item.cartId,
        "title": item.title,
        "price": item.price,
        "imageUrl": item.imageUrl,
        "quantity": item.quantity,
        "createdAt": FieldValue.serverTimestamp(),
        "addedAt": FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateQuantity({
    required String productId,
    required int quantity,
  }) async {
    if (!_cartItems.containsKey(productId)) return;

    if (quantity <= 0) {
      await removeItem(productId);
      return;
    }

    final existing = _cartItems[productId]!;
    _cartItems[productId] = existing.copyWith(quantity: quantity);
    notifyListeners();

    if (_uid == null) return;

    await _cartDoc().set({
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _itemsCol().doc(productId).set({
      "quantity": quantity,
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeOneItem(String productId) async {
    if (!_cartItems.containsKey(productId)) return;

    final current = _cartItems[productId]!;
    if (current.quantity <= 1) {
      await removeItem(productId);
    } else {
      final newQty = current.quantity - 1;
      _cartItems[productId] = current.copyWith(quantity: newQty);
      notifyListeners();

      if (_uid != null) {
        await _cartDoc().set({
          "updatedAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        await _itemsCol().doc(productId).set({
          "quantity": newQty,
          "updatedAt": FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }
  }

  Future<void> removeItem(String productId) async {
    _cartItems.remove(productId);
    notifyListeners();

    if (_uid == null) return;

    await _cartDoc().set({
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await _itemsCol().doc(productId).delete();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    notifyListeners();

    if (_uid == null) return;

    final snap = await _itemsCol().get();
    final batch = _db.batch();
    for (final d in snap.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();

    await _cartDoc().set({
      "updatedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  int get totalItems {
    int total = 0;
    for (final item in _cartItems.values) {
      total += item.quantity;
    }
    return total;
  }

  int get totalProducts => _cartItems.length;

  double get totalPrice {
    double total = 0.0;
    for (final item in _cartItems.values) {
      final p = double.tryParse(item.price) ?? 0.0;
      total += p * item.quantity;
    }
    return total;
  }
}
