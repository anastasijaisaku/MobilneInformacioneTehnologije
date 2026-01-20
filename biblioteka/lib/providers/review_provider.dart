import 'package:flutter/material.dart';
import 'package:biblioteka/models/review_model.dart';

class ReviewProvider with ChangeNotifier {
  final List<ReviewModel> _reviews = [
    ReviewModel(
      reviewId: "r1",
      bookId: "book_1",
      userName: "Ana",
      rating: 5,
      comment: "Great book, very easy to follow.",
      createdAt: DateTime(2026, 1, 10),
    ),
    ReviewModel(
      reviewId: "r2",
      bookId: "book_1",
      userName: "Marko",
      rating: 4,
      comment: "Useful and well-written.",
      createdAt: DateTime(2026, 1, 12),
    ),
    ReviewModel(
      reviewId: "r3",
      bookId: "book_2",
      userName: "Jelena",
      rating: 5,
      comment: "Loved it. Would recommend!",
      createdAt: DateTime(2026, 1, 15),
    ),
  ];

  List<ReviewModel> reviewsByBook(String bookId) {
    return _reviews.where((r) => r.bookId == bookId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  double averageRating(String bookId) {
    final list = reviewsByBook(bookId);
    if (list.isEmpty) return 0;
    final sum = list.fold<int>(0, (p, e) => p + e.rating);
    return sum / list.length;
  }

  int reviewsCount(String bookId) => reviewsByBook(bookId).length;

  void addReview({
    required String bookId,
    required String userName,
    required int rating,
    required String comment,
  }) {
    final newReview = ReviewModel(
      reviewId: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: bookId,
      userName: userName.trim().isEmpty ? "Guest" : userName.trim(),
      rating: rating.clamp(1, 5),
      comment: comment.trim(),
      createdAt: DateTime.now(),
    );
    _reviews.add(newReview);
    notifyListeners();
  }
}
