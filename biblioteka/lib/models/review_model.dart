class ReviewModel {
  final String reviewId;
  final String bookId;
  final String userName;
  final int rating; // 1-5
  final String comment;
  final DateTime createdAt;

  const ReviewModel({
    required this.reviewId,
    required this.bookId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });
}
