import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biblioteka/providers/reservation_provider.dart';

class ReservationsScreen extends StatelessWidget {
  static const routName = "/ReservationsScreen";
  const ReservationsScreen({super.key});

  String _fmt(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    final reservationProvider = Provider.of<ReservationProvider>(context);
    final reservations = reservationProvider.reservations;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reservations"),
      ),
      body: reservations.isEmpty
          ? const Center(
              child: Text("No reservations yet."),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: reservations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final r = reservations[index];

                final statusText = r.isCanceled
                    ? "Status: canceled"
                    : r.isExpired
                        ? "Status: expired"
                        : "Status: active";

                final statusColor = r.isCanceled
                    ? Colors.grey
                    : r.isExpired
                        ? Colors.orange
                        : Colors.green;

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
                          r.bookImage,
                          width: 52,
                          height: 52,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.menu_book_rounded, size: 40),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.bookTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text("Reserved on: ${_fmt(r.reservedAt)}"),
                            Text("Expires on: ${_fmt(r.expiresAt)}"),
                            const SizedBox(height: 6),
                            Text(
                              statusText,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (r.isActive)
                        IconButton(
                          tooltip: "Cancel reservation",
                          onPressed: () => reservationProvider.cancelReservation(r.reservationId),
                          icon: const Icon(Icons.cancel_outlined),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
