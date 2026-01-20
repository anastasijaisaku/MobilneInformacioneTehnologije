import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/consts/app_constants.dart';
import 'package:biblioteka/widgets/products/heart_btn.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:biblioteka/providers/loan_provider.dart';

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
    final String bookImage =
        (args?["bookImage"] ?? AppConstants.imageUrl).toString();
    final String bookPrice = (args?["bookPrice"] ?? "1550.00 RSD").toString();
    final String bookCategory =
        (args?["bookCategory"] ?? "Category").toString();
    final String bookDescription =
        (args?["bookDescription"] ?? ("Book description " * 10)).toString();

    final loanProvider = Provider.of<LoanProvider>(context);
    final bool alreadyBorrowed = loanProvider.isBookBorrowed(bookId);

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
        title: const Text("Library"),
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
                                  onPressed: () {},
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
                              alreadyBorrowed
                                  ? "Already borrowed"
                                  : "Borrow",
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
