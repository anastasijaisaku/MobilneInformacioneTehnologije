import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/empty_bag.dart';
import 'package:biblioteka/widgets/products/product_widget.dart';
import 'package:biblioteka/widgets/title_text.dart';

class WishlistScreen extends StatelessWidget {
  static const routName = "/WishlistScreen";
  const WishlistScreen({super.key});

  final bool isEmpty = true;

  @override
  Widget build(BuildContext context) {
    return isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/wishlist.png",
              title: "Nothing in your wishlist yet",
              subtitle:
                  "Looks like your wishlist is empty.\nStart adding books you like!",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(AssetsManager.logo),
                ),
              ),
              title: const TitelesTextWidget(label: "Wishlist (6)"),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              builder: (context, index) {
                return ProductWidget(
                  bookId: "wishlist_book_$index",
                  bookTitle: "Wishlist Book ${index + 1}",
                  bookImage: AppConstants.imageUrl,
                  bookPrice: "1200 RSD",
                  bookCategory: "Books",
                  bookDescription: "Book description " * 6,
                );
              },
              itemCount: 6,
              crossAxisCount: 2,
            ),
          );
  }
}
