class LoanModel {
  final String loanId;
  final String bookId;
  final String bookTitle;
  final String bookImage;
  final DateTime loanDate;
  final DateTime dueDate;
  final bool isReturned;

  const LoanModel({
    required this.loanId,
    required this.bookId,
    required this.bookTitle,
    required this.bookImage,
    required this.loanDate,
    required this.dueDate,
    this.isReturned = false,
  });

  LoanModel copyWith({
    bool? isReturned,
  }) {
    return LoanModel(
      loanId: loanId,
      bookId: bookId,
      bookTitle: bookTitle,
      bookImage: bookImage,
      loanDate: loanDate,
      dueDate: dueDate,
      isReturned: isReturned ?? this.isReturned,
    );
  }
}
