import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/providers/cart_provider.dart';
import 'package:biblioteka/screens/cart/quantity_btm_sheet.dart';
import 'package:biblioteka/widgets/products/heart_btn.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({
    super.key,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price, // STRING
    required this.quantity,
  });

  final String productId;
  final String title;
  final String imageUrl;
  final String price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final Size size = MediaQuery.of(context).size;

    final String safeImage =
        imageUrl.trim().isEmpty ? AppConstants.imageUrl : imageUrl.trim();

    final double parsedPrice = double.tryParse(price) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: FancyShimmerImage(
              imageUrl: safeImage,
              height: size.height * 0.16,
              width: size.height * 0.12,
              boxFit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TitelesTextWidget(
                        label: title,
                        maxLines: 2,
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            cartProvider.removeItem(productId);
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.darkPrimary,
                          ),
                        ),
                        const HeartButtonWidget(),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SubtitleTextWidget(
                      label: "${parsedPrice.toStringAsFixed(0)} RSD",
                      color: AppColors.darkPrimary,
                    ),
                    const Spacer(),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final result = await showModalBottomSheet<int>(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return QuantityBottomSheetWidget(
                              initialQty: quantity,
                            );
                          },
                        );

                        if (result != null) {
                          cartProvider.updateQuantity(
                            productId: productId,
                            quantity: result,
                          );
                        }
                      },
                      icon: const Icon(IconlyLight.arrowDown2),
                      label: Text("Qty: $quantity"),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
