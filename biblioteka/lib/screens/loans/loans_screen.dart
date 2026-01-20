import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biblioteka/providers/loan_provider.dart';

class LoansScreen extends StatelessWidget {
  static const routName = "/LoansScreen";
  const LoansScreen({super.key});

  String _fmt(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
    final loans = loanProvider.loans;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Moje pozajmice"),
      ),
      body: loans.isEmpty
          ? const Center(
              child: Text("Nema pozajmljenih knjiga."),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: loans.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final loan = loans[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          loan.bookImage,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.menu_book_rounded, size: 40),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loan.bookTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text("Pozajmljeno: ${_fmt(loan.loanDate)}"),
                            Text("Vratiti do: ${_fmt(loan.dueDate)}"),
                            const SizedBox(height: 6),
                            Text(
                              loan.isReturned ? "Status: vraćeno" : "Status: aktivno",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: loan.isReturned ? Colors.grey : Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (!loan.isReturned)
                        IconButton(
                          tooltip: "Označi kao vraćeno",
                          onPressed: () => loanProvider.markReturned(loan.loanId),
                          icon: const Icon(Icons.check_circle_outline),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
