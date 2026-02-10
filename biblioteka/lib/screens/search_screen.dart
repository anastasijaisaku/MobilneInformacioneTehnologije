import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/providers/products_provider.dart';
import 'package:biblioteka/models/product_model.dart';
import 'package:biblioteka/widgets/products/product_widget.dart';

class SearchScreen extends StatefulWidget {
  static const routName = "/SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    super.initState();
    searchTextController = TextEditingController();

    // ✅ Ucitaj knjige iz Firestore čim ekran krene (jednom)
    Future.microtask(() async {
      final productsProvider =
          Provider.of<ProductsProvider>(context, listen: false);

      // Ako već ima liste (npr. prethodno učitano), ne mora opet
      if (productsProvider.getProducts.isEmpty) {
        await productsProvider.fetchProducts();
      }
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);

    final List<ProductModel> productsList = productsProvider.searchQuery(
      searchText: searchTextController.text,
    );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage("${AssetsManager.imagePath}/logo.png"),
            ),
          ),
          title: const Text("Biblioteka"),
          actions: [
            IconButton(
              tooltip: "Refresh",
              onPressed: () async {
                FocusScope.of(context).unfocus();
                await productsProvider.fetchProducts();
                if (mounted) setState(() {});
              },
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 15.0),
              TextField(
                controller: searchTextController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search books...",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      searchTextController.clear();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.clear,
                      color: AppColors.darkPrimary,
                    ),
                  ),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => setState(() {}),
              ),
              const SizedBox(height: 15.0),

              Expanded(
                child: productsProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : productsList.isEmpty
                        ? const Center(child: Text("No results"))
                        : DynamicHeightGridView(
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            itemCount: productsList.length,
                            crossAxisCount: 2,
                            builder: (context, index) {
                              final p = productsList[index];

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
            ],
          ),
        ),
      ),
    );
  }
}
