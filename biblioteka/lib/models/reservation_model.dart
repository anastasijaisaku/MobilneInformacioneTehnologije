import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationModel {
  final String reservationId;
  final String userId;

  final String bookId;
  final String bookTitle;
  final String bookImage; // URL ili prazan string

  final DateTime reservedAt;
  final DateTime expiresAt;

  final String status;

  const ReservationModel({
    required this.reservationId,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.bookImage,
    required this.reservedAt,
    required this.expiresAt,
    this.status = "active",
  });

  bool get isCanceled => status == "canceled";
  bool get isExpired => status == "expired" || DateTime.now().isAfter(expiresAt);

  bool get isActive => !isCanceled && !isExpired;

  ReservationModel copyWith({
    String? reservationId,
    String? userId,
    String? bookId,
    String? bookTitle,
    String? bookImage,
    DateTime? reservedAt,
    DateTime? expiresAt,
    String? status,
  }) {
    return ReservationModel(
      reservationId: reservationId ?? this.reservationId,
      userId: userId ?? this.userId,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
      bookImage: bookImage ?? this.bookImage,
      reservedAt: reservedAt ?? this.reservedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "reservationId": reservationId,
      "userId": userId,
      "bookId": bookId,
      "bookTitle": bookTitle,
      "bookImage": bookImage,
      "reservedAt": Timestamp.fromDate(reservedAt),
      "expiresAt": Timestamp.fromDate(expiresAt),
      "status": status,
    };
  }

  factory ReservationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};

    DateTime _toDate(dynamic v) {
      if (v is Timestamp) return v.toDate();
      if (v is DateTime) return v;
      return DateTime.now();
    }

    return ReservationModel(
      reservationId: (data["reservationId"] ?? doc.id).toString(),
      userId: (data["userId"] ?? "").toString(),
      bookId: (data["bookId"] ?? "").toString(),
      bookTitle: (data["bookTitle"] ?? "").toString(),
      bookImage: (data["bookImage"] ?? "").toString(),
      reservedAt: _toDate(data["reservedAt"]),
      expiresAt: _toDate(data["expiresAt"]),
      status: (data["status"] ?? "active").toString(),
    );
  }
}
