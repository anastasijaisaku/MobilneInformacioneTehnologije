class ReservationModel {
  final String reservationId;
  final String bookId;
  final String bookTitle;
  final String bookImage;
  final DateTime reservedAt;
  final DateTime expiresAt;
  final bool isCanceled;

  ReservationModel({
    required this.reservationId,
    required this.bookId,
    required this.bookTitle,
    required this.bookImage,
    required this.reservedAt,
    required this.expiresAt,
    this.isCanceled = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isActive => !isCanceled && !isExpired;

  ReservationModel copyWith({
    bool? isCanceled,
  }) {
    return ReservationModel(
      reservationId: reservationId,
      bookId: bookId,
      bookTitle: bookTitle,
      bookImage: bookImage,
      reservedAt: reservedAt,
      expiresAt: expiresAt,
      isCanceled: isCanceled ?? this.isCanceled,
    );
  }
}
