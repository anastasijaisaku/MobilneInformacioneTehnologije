import 'package:flutter/material.dart';
import 'package:biblioteka/models/product_model.dart';
import 'package:uuid/uuid.dart';

class ProductsProvider with ChangeNotifier {
  final List<ProductModel> _products = [
    // ===================== Udzbenici =====================
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Uvod u programiranje",
      productPrice: "1200.00",
      productCategory: "Udzbenici",
      productDescription: "Osnovni pojmovi programiranja, algoritmi i primeri.",
      productImage: "",
      productQuantity: "10",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Baze podataka 1",
      productPrice: "1350.00",
      productCategory: "Udzbenici",
      productDescription: "Modelovanje podataka, SQL osnove i normalizacija.",
      productImage: "",
      productQuantity: "12",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Uvod u mikroprocesorske sisteme",
      productPrice: "1400.00",
      productCategory: "Udzbenici",
      productDescription: "Arhitektura, instrukcijski setovi i primeri primene.",
      productImage: "",
      productQuantity: "8",
    ),

    // ===================== Romani =====================
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Zlocin i kazna",
      productPrice: "990.00",
      productCategory: "Romani",
      productDescription: "Klasik svetske knjizevnosti o moralu i posledicama.",
      productImage: "",
      productQuantity: "7",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Mali princ",
      productPrice: "650.00",
      productCategory: "Romani",
      productDescription: "Topla prica o prijateljstvu i zivotnim vrednostima.",
      productImage: "",
      productQuantity: "20",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Na Drini cuprija",
      productPrice: "1100.00",
      productCategory: "Romani",
      productDescription: "Roman o istoriji, ljudima i vremenu.",
      productImage: "",
      productQuantity: "9",
    ),

    // ===================== Strucna literatura =====================
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Clean Code",
      productPrice: "2500.00",
      productCategory: "Strucna literatura",
      productDescription: "Pravila i primeri za citljiv i odrziv kod.",
      productImage: "",
      productQuantity: "6",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Projektovanje softvera",
      productPrice: "2100.00",
      productCategory: "Strucna literatura",
      productDescription: "Arhitektura, obrasci dizajna i najbolja praksa.",
      productImage: "",
      productQuantity: "5",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Upravljanje projektima",
      productPrice: "1900.00",
      productCategory: "Strucna literatura",
      productDescription: "Planiranje, WBS, gantogram, rizici i pracenje.",
      productImage: "",
      productQuantity: "4",
    ),

    // ===================== Decije knjige =====================
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Bajke (izbor)",
      productPrice: "800.00",
      productCategory: "Decije knjige",
      productDescription: "Kratke bajke za citanje pred spavanje.",
      productImage: "",
      productQuantity: "15",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Pinokio",
      productPrice: "750.00",
      productCategory: "Decije knjige",
      productDescription: "Avanture drvenog decaka i vazne zivotne lekcije.",
      productImage: "",
      productQuantity: "11",
    ),
    ProductModel(
      productId: const Uuid().v4(),
      productTitle: "Matematika kroz igru",
      productPrice: "950.00",
      productCategory: "Decije knjige",
      productDescription: "Zadaci i igre za ucenje kroz zabavu.",
      productImage: "",
      productQuantity: "13",
    ),
  ];

  List<ProductModel> get getProducts => _products;

  String _normalize(String s) {
    return s
        .toLowerCase()
        .replaceAll('č', 'c')
        .replaceAll('ć', 'c')
        .replaceAll('ž', 'z')
        .replaceAll('š', 's')
        .replaceAll('đ', 'dj')
        .trim();
  }

  ProductModel? findByProductId(String productId) {
    final list = _products.where((e) => e.productId == productId);
    if (list.isEmpty) return null;
    return _products.firstWhere((e) => e.productId == productId);
  }

  List<ProductModel> findByCategory({required String categoryName}) {
    final cat = _normalize(categoryName);
    return _products
        .where((e) => _normalize(e.productCategory) == cat)
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
