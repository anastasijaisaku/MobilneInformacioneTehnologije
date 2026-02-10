import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:biblioteka/models/product_model.dart';

class ProductsProvider with ChangeNotifier {
  final _db = FirebaseFirestore.instance;

  List<ProductModel> _products = [];
  List<ProductModel> get getProducts => _products;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    final snap = await _db.collection('books').get();

    _products = snap.docs
        .map((d) => ProductModel.fromFirestore(d.data(), d.id))
        .toList();

    _isLoading = false;
    notifyListeners();
  }

  ProductModel? findByProductId(String productId) {
    try {
      return _products.firstWhere((e) => e.productId == productId);
    } catch (_) {
      return null;
    }
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    final c = categoryName.toLowerCase().trim();
    return _products
        .where((e) => e.productCategory.toLowerCase().trim() == c)
        .toList();
  }

  List<ProductModel> searchQuery({required String searchText}) {
    final q = searchText.toLowerCase().trim();
    if (q.isEmpty) return _products;
    return _products
        .where((e) => e.productTitle.toLowerCase().contains(q))
        .toList();
  }
}
