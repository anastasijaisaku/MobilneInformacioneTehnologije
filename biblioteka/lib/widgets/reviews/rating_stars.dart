import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
  });

  final double rating; // supports decimals
  final double size;

  @override
  Widget build(BuildContext context) {
    // simple half-step visualization
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final starValue = i + 1;
        IconData icon;

        if (rating >= starValue) {
          icon = Icons.star;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }

        return Icon(icon, size: size);
      }),
    );
  }
}
