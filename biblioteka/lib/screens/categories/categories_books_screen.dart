import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/models/product_model.dart';
import 'package:biblioteka/providers/products_provider.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/products/product_widget.dart';

class CategoryBooksScreen extends StatelessWidget {
  static const routeName = "/CategoryBooksScreen";
  const CategoryBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String categoryName = (args?["categoryName"] ?? "").toString();

    final productsProvider = Provider.of<ProductsProvider>(context);
    final List<ProductModel> categoryBooks =
        productsProvider.findByCategory(categoryName: categoryName);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage("${AssetsManager.imagePath}/logo.png"),
          ),
        ),
        title: Text(categoryName.isEmpty ? "Category" : categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: categoryBooks.isEmpty
            ? const Center(child: Text("No books in this category"))
            : DynamicHeightGridView(
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemCount: categoryBooks.length,
                crossAxisCount: 2,
                builder: (context, index) {
                  final p = categoryBooks[index];
                  return ProductWidget(
                    bookId: p.productId,
                    bookTitle: p.productTitle,
                    bookImage: (p.productImage.isEmpty)
                        ? AppConstants.imageUrl
                        : p.productImage,
                    bookPrice: "${p.productPrice} RSD",
                    bookCategory: p.productCategory,
                    bookDescription: p.productDescription,
                  );
                },
              ),
      ),
    );
  }
}
