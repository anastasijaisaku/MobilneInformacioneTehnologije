import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/screens/inner_screen/product_details.dart';
import 'package:biblioteka/widgets/products/heart_btn.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.bookId,
    required this.bookTitle,
    required this.bookImage,
    required this.bookPrice,
    required this.bookCategory,
    required this.bookDescription,
  });

  final String bookId;
  final String bookTitle;
  final String bookImage;
  final String bookPrice;
  final String bookCategory;
  final String bookDescription;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          ProductDetailsScreen.routName,
          arguments: {
            "bookId": bookId,
            "bookTitle": bookTitle,
            "bookImage": bookImage,
            "bookPrice": bookPrice,
            "bookCategory": bookCategory,
            "bookDescription": bookDescription,
          },
        );
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: FancyShimmerImage(
              imageUrl: bookImage,
              height: size.height * 0.22,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: TitelesTextWidget(
                    label: bookTitle,
                    fontSize: 18,
                    maxLines: 2,
                  ),
                ),
                const Flexible(
                  flex: 2,
                  child: HeartButtonWidget(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SubtitleTextWidget(
                    label: bookPrice,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkPrimary,
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(12.0),
                  color: AppColors.lightPrimary,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.0),
                    onTap: () {},
                    splashColor: Colors.blueGrey,
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.add_shopping_cart_outlined),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),
        ],
      ),
    );
  }
}
