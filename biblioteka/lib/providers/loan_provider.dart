import 'package:flutter/material.dart';
import 'package:biblioteka/models/loan_model.dart';

class LoanProvider with ChangeNotifier {
  final List<LoanModel> _loans = [];

  List<LoanModel> get loans => List.unmodifiable(_loans);

  int get activeLoansCount => _loans.where((l) => !l.isReturned).length;

  bool isBookBorrowed(String bookId) {
    return _loans.any((l) => l.bookId == bookId && !l.isReturned);
  }

  void borrowBook({
    required String bookId,
    required String bookTitle,
    required String bookImage,
    int days = 14,
  }) {
    if (isBookBorrowed(bookId)) return;

    final now = DateTime.now();
    final due = now.add(Duration(days: days));

    _loans.insert(
      0,
      LoanModel(
        loanId: "${bookId}_${now.millisecondsSinceEpoch}",
        bookId: bookId,
        bookTitle: bookTitle,
        bookImage: bookImage,
        loanDate: now,
        dueDate: due,
      ),
    );

    notifyListeners();
  }

  void markReturned(String loanId) {
    final index = _loans.indexWhere((l) => l.loanId == loanId);
    if (index == -1) return;

    _loans[index] = _loans[index].copyWith(isReturned: true);
    notifyListeners();
  }
}
