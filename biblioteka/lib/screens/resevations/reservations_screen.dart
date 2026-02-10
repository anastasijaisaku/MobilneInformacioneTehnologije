import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:biblioteka/consts/app_constants.dart';

class ReservationsScreen extends StatelessWidget {
  static const routName = "/ReservationsScreen";
  const ReservationsScreen({super.key});

  String _fmtTimestamp(Timestamp? t) {
    if (t == null) return "-";
    final d = t.toDate();
    return "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}";
  }

  Color _statusColor(String s) {
    final v = s.toLowerCase().trim();
    if (v == "cancelled" || v == "canceled") return Colors.grey;
    if (v == "rejected") return Colors.red;
    if (v == "expired") return Colors.orange;
    if (v == "approved") return Colors.green;
    if (v == "pickedup" || v == "picked_up") return Colors.blue;
    if (v == "pending") return Colors.amber;
    return Colors.amber; // created / default
  }

  String _statusLabel(String s) {
    final v = s.toLowerCase().trim();
    if (v == "cancelled" || v == "canceled") return "Status: cancelled";
    if (v == "rejected") return "Status: rejected";
    if (v == "expired") return "Status: expired";
    if (v == "approved") return "Status: approved";
    if (v == "pickedup" || v == "picked_up") return "Status: picked up";
    if (v == "pending") return "Status: pending";
    return "Status: created";
  }

  Future<void> _cancelReservation(String reservationId) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .update({
      "status": "cancelled",
      "cancelledAt": FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("My Reservations")),
        body: const Center(
          child: Text("Please login to view your reservations."),
        ),
      );
    }

    // 
    final stream = FirebaseFirestore.instance
        .collection('reservations')
        .where("uid", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reservations"),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text("No reservations yet."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data();

              final String status = (data["status"] ?? "created").toString();
              final Timestamp? createdAt = data["createdAt"] as Timestamp?;

              final num totalPriceNum = (data["totalPrice"] as num?) ?? 0;
              final int totalItems = (data["totalItems"] as num?)?.toInt() ?? 0;
              final int totalProducts =
                  (data["totalProducts"] as num?)?.toInt() ?? 0;

              final List items = (data["items"] as List?) ?? const [];
              final Map firstItem = items.isNotEmpty ? (items.first as Map) : {};

              final String title =
                  (firstItem["title"] ?? "Reservation").toString();
              final String imageUrlRaw =
                  (firstItem["imageUrl"] ?? "").toString();

              final String imageUrl = imageUrlRaw.trim().isEmpty
                  ? AppConstants.imageUrl
                  : imageUrlRaw.trim();

              final Color c = _statusColor(status);
              final String statusText = _statusLabel(status);

              final String st = status.toLowerCase().trim();
              final bool canCancel = (st == "created" || st == "pending");

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
                      child: Image.network(
                        imageUrl,
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
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 6),
                          Text("Created: ${_fmtTimestamp(createdAt)}"),
                          Text("Items: $totalProducts products / $totalItems items"),
                          Text("Total: ${totalPriceNum.toStringAsFixed(0)} RSD"),
                          const SizedBox(height: 6),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: c,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (canCancel)
                      IconButton(
                        tooltip: "Cancel reservation",
                        onPressed: () async {
                          try {
                            await _cancelReservation(doc.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Reservation cancelled."),
                                ),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Cancel failed: $e")),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.cancel_outlined),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
