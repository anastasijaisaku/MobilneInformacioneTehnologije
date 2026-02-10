import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';

class OrdersWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;
  const OrdersWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final String status = (orderData["status"] ?? "created").toString();

    final num totalPriceNum = (orderData["totalPrice"] as num?) ?? 0;
    final int totalItems = (orderData["totalItems"] as num?)?.toInt() ?? 0;
    final int totalProducts = (orderData["totalProducts"] as num?)?.toInt() ?? 0;

    final List items = (orderData["items"] as List?) ?? const [];
    final Map firstItem = items.isNotEmpty ? (items.first as Map) : {};

    final String title = (firstItem["title"] ?? "Order").toString();
    final String imageUrlRaw = (firstItem["imageUrl"] ?? "").toString();
    final String imageUrl =
        imageUrlRaw.trim().isEmpty ? AppConstants.imageUrl : imageUrlRaw.trim();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.25,
              width: size.width * 0.25,
              imageUrl: imageUrl,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitelesTextWidget(
                    label: title,
                    maxLines: 2,
                    fontSize: 15,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const TitelesTextWidget(label: 'Total: ', fontSize: 15),
                      Flexible(
                        child: SubtitleTextWidget(
                          label: "${totalPriceNum.toStringAsFixed(0)} RSD",
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SubtitleTextWidget(
                    label: "Items: $totalProducts products / $totalItems items",
                    fontSize: 14,
                  ),
                  const SizedBox(height: 5),
                  SubtitleTextWidget(
                    label: "Status: $status",
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
