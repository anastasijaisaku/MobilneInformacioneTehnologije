import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:biblioteka/models/reservation_model.dart';

class ReservationProvider with ChangeNotifier {
  final List<ReservationModel> _reservations = [];

  List<ReservationModel> get reservations => List.unmodifiable(_reservations);

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  Future<void> fetchReservations() async {
    final uid = _uid;
    if (uid == null) {
      _reservations.clear();
      notifyListeners();
      return;
    }

    final snap = await _db
        .collection("reservations")
        .where("userId", isEqualTo: uid)
        .orderBy("reservedAt", descending: true)
        .get();

    _reservations
      ..clear()
      ..addAll(
        snap.docs.map((d) => ReservationModel.fromFirestore(d)),
      );

    notifyListeners();
  }

  bool isBookReserved(String bookId) {
    
    return _reservations.any((r) => r.bookId == bookId && r.isActive);
  }

  Future<void> reserveBook({
    required String bookId,
    required String bookTitle,
    required String bookImage, 
    int days = 5,
  }) async {
    final uid = _uid;
    if (uid == null) return;

   
    if (isBookReserved(bookId)) return;

    final now = DateTime.now();
    final expiresAt = now.add(Duration(days: days));

    final docRef = _db.collection("reservations").doc(); 

    final reservation = ReservationModel(
      reservationId: docRef.id,
      userId: uid,
      bookId: bookId,
      bookTitle: bookTitle,
      bookImage: bookImage,
      reservedAt: now,
      expiresAt: expiresAt,
      status: "active", 
    );

    await docRef.set(reservation.toMap());

    _reservations.insert(0, reservation);
    notifyListeners();
  }

  Future<void> cancelReservation(String reservationId) async {
    final uid = _uid;
    if (uid == null) return;

    final index = _reservations.indexWhere((r) => r.reservationId == reservationId);
    if (index == -1) return;

    await _db.collection("reservations").doc(reservationId).update({
      "status": "canceled",
      "canceledAt": FieldValue.serverTimestamp(),
    });

    final old = _reservations[index];
    _reservations[index] = old.copyWith(status: "canceled");
    notifyListeners();
  }

  Future<void> clearAllLocal() async {
    _reservations.clear();
    notifyListeners();
  }
}
