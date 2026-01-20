import 'package:flutter/material.dart';
import 'package:biblioteka/models/reservation_model.dart';

class ReservationProvider with ChangeNotifier {
  final List<ReservationModel> _reservations = [];

  List<ReservationModel> get reservations => List.unmodifiable(_reservations);

  bool isBookReserved(String bookId) {
    return _reservations.any((r) => r.bookId == bookId && r.isActive);
  }

  void reserveBook({
    required String bookId,
    required String bookTitle,
    required String bookImage,
    int days = 5,
  }) {
    // Prevent duplicate active reservation for same book
    if (isBookReserved(bookId)) return;

    final now = DateTime.now();
    final reservation = ReservationModel(
      reservationId: "res_${now.microsecondsSinceEpoch}",
      bookId: bookId,
      bookTitle: bookTitle,
      bookImage: bookImage,
      reservedAt: now,
      expiresAt: now.add(Duration(days: days)),
    );

    _reservations.insert(0, reservation);
    notifyListeners();
  }

  void cancelReservation(String reservationId) {
    final index = _reservations.indexWhere((r) => r.reservationId == reservationId);
    if (index == -1) return;

    _reservations[index] = _reservations[index].copyWith(isCanceled: true);
    notifyListeners();
  }

  void clearAll() {
    _reservations.clear();
    notifyListeners();
  }
}
