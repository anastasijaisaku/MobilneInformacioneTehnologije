import 'package:biblioteka/providers/cart_provider.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/widgets/products/heart_btn.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:biblioteka/providers/loan_provider.dart';
import 'package:biblioteka/providers/reservation_provider.dart';
import 'package:biblioteka/providers/review_provider.dart';
import 'package:biblioteka/widgets/reviews/rating_stars.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routName = "/ProductDetailsScreen";
  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    final String bookId = (args?["bookId"] ?? "book_unknown").toString();
    final String bookTitle = (args?["bookTitle"] ?? ("Title" * 6)).toString();
    final String bookImage = (args?["bookImage"] ?? AppConstants.imageUrl)
        .toString();
    final String bookPrice = (args?["bookPrice"] ?? "1550.00 RSD").toString();
    final String bookCategory = (args?["bookCategory"] ?? "Category")
        .toString();
    final String bookDescription =
        (args?["bookDescription"] ?? ("Book description " * 10)).toString();

    final loanProvider = Provider.of<LoanProvider>(context);
    final bool alreadyBorrowed = loanProvider.isBookBorrowed(bookId);

    final reservationProvider = Provider.of<ReservationProvider>(context);
    final bool alreadyReserved = reservationProvider.isBookReserved(bookId);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.arrow_back_ios, size: 20),
        ),
        title: const Text("Biblioteka"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FancyShimmerImage(
              imageUrl: bookImage,
              height: size.height * 0.38,
              width: double.infinity,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          bookTitle,
                          softWrap: true,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SubtitleTextWidget(
                        label: bookPrice,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkPrimary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const HeartButtonWidget(
                              bkgColor: AppColors.darkPrimary,
                            ),
                            const SizedBox(width: 12),

                            // BUY
                            Expanded(
                              child: SizedBox(
                                height: kBottomNavigationBarHeight - 10,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.darkPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    final cartProvider =
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        );

                                    final priceOnly = bookPrice
                                        .replaceAll("RSD", "")
                                        .trim();

                                    cartProvider.addToCart(
                                      productId: bookId,
                                      title: bookTitle,
                                      price: priceOnly,
                                      imageUrl: bookImage,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Added to cart"),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Buy",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // BORROW
                        SizedBox(
                          width: double.infinity,
                          height: kBottomNavigationBarHeight - 10,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: alreadyBorrowed
                                  ? Colors.grey
                                  : AppColors.darkPrimary.withOpacity(0.85),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: alreadyBorrowed
                                ? null
                                : () {
                                    loanProvider.borrowBook(
                                      bookId: bookId,
                                      bookTitle: bookTitle,
                                      bookImage: bookImage,
                                      days: 14,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Book borrowed (due in 14 days)",
                                        ),
                                      ),
                                    );
                                  },
                            icon: const Icon(
                              Icons.library_books_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              alreadyBorrowed ? "Already borrowed" : "Borrow",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // RESERVE (5 days)
                        SizedBox(
                          width: double.infinity,
                          height: kBottomNavigationBarHeight - 10,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: alreadyReserved
                                  ? Colors.grey
                                  : AppColors.darkPrimary.withOpacity(0.75),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: alreadyReserved
                                ? null
                                : () {
                                    reservationProvider.reserveBook(
                                      bookId: bookId,
                                      bookTitle: bookTitle,
                                      bookImage: bookImage,
                                      days: 5,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Book reserved (expires in 5 days)",
                                        ),
                                      ),
                                    );
                                  },
                            icon: const Icon(
                              Icons.bookmark_added_outlined,
                              color: Colors.white,
                            ),
                            label: Text(
                              alreadyReserved
                                  ? "Already reserved"
                                  : "Reserve (5 days)",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitelesTextWidget(label: "About this book"),
                      SubtitleTextWidget(label: bookCategory),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SubtitleTextWidget(label: bookDescription),

                  // REVIEWS SECTION
                  const SizedBox(height: 18),

                  Consumer<ReviewProvider>(
                    builder: (context, reviewProvider, _) {
                      final avg = reviewProvider.averageRating(bookId);
                      final count = reviewProvider.reviewsCount(bookId);
                      final reviews = reviewProvider.reviewsByBook(bookId);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TitelesTextWidget(label: "Reviews"),
                              Row(
                                children: [
                                  RatingStars(rating: avg, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    avg == 0
                                        ? "No rating"
                                        : avg.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text("($count)"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          if (reviews.isEmpty)
                            const SubtitleTextWidget(
                              label: "No reviews yet. Be the first one!",
                            )
                          else
                            Column(
                              children: reviews.take(3).map((r) {
                                return Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: Colors.black12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              r.userName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          RatingStars(
                                            rating: r.rating.toDouble(),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(r.comment),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final result =
                                    await showDialog<Map<String, dynamic>>(
                                      context: context,
                                      builder: (_) => const _AddReviewDialog(),
                                    );

                                if (result == null) return;

                                reviewProvider.addReview(
                                  bookId: bookId,
                                  userName: result["name"] as String,
                                  rating: result["rating"] as int,
                                  comment: result["comment"] as String,
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Review added")),
                                );
                              },
                              icon: const Icon(Icons.rate_review_outlined),
                              label: const Text("Write a review"),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddReviewDialog extends StatefulWidget {
  const _AddReviewDialog();

  @override
  State<_AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<_AddReviewDialog> {
  final nameCtrl = TextEditingController();
  final commentCtrl = TextEditingController();
  int rating = 5;

  @override
  void dispose() {
    nameCtrl.dispose();
    commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Write a review"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                hintText: "Your name (optional)",
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: rating,
              items: const [
                DropdownMenuItem(value: 5, child: Text("5 - Excellent")),
                DropdownMenuItem(value: 4, child: Text("4 - Very good")),
                DropdownMenuItem(value: 3, child: Text("3 - Good")),
                DropdownMenuItem(value: 2, child: Text("2 - Fair")),
                DropdownMenuItem(value: 1, child: Text("1 - Poor")),
              ],
              onChanged: (v) => setState(() => rating = v ?? 5),
              decoration: const InputDecoration(labelText: "Rating"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: commentCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Write your comment...",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final comment = commentCtrl.text.trim();
            if (comment.isEmpty) return;

            Navigator.pop(context, {
              "name": nameCtrl.text,
              "rating": rating,
              "comment": comment,
            });
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
