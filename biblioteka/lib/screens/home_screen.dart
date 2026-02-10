import 'package:biblioteka/screens/categories/categories_books_screen.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/providers/products_provider.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/products/product_widget.dart';
import 'package:biblioteka/widgets/title_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
      _loaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final productsProvider = Provider.of<ProductsProvider>(context);
    final allProducts = productsProvider.getProducts;
    final recommended =
        allProducts.length >= 4 ? allProducts.take(4).toList() : allProducts;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage("${AssetsManager.imagePath}/logo.png"),
          ),
        ),
        title: const Text("Biblioteka"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.cover,
                      );
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: const SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        activeColor: AppColors.darkPrimary,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              const TitelesTextWidget(label: "Categories"),
              const SizedBox(height: 12),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    List.generate(AppConstants.categoriesList.length, (index) {
                  final ctg = AppConstants.categoriesList[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        CategoryBooksScreen.routeName,
                        arguments: {"categoryName": ctg.name},
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.darkPrimary.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(ctg.image, height: 22, width: 22),
                          const SizedBox(width: 8),
                          Text(
                            ctg.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 22),

              const TitelesTextWidget(label: "Recommended"),
              const SizedBox(height: 12),

              if (allProducts.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recommended.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final p = recommended[index];
                    return ProductWidget(
                      bookId: p.productId,
                      bookTitle: p.productTitle,
                      bookImage: p.productImage.isEmpty
                          ? AppConstants.imageUrl
                          : p.productImage,
                      bookPrice: "${p.productPrice} RSD",
                      bookCategory: p.productCategory,
                      bookDescription: p.productDescription,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
