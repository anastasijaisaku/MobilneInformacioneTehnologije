import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:biblioteka/screens/search_screen.dart';
import 'package:biblioteka/screens/inner_screen/orders/orders_widget.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/empty_bag.dart';
import 'package:biblioteka/widgets/title_text.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/OrderScreen';
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const TitelesTextWidget(label: 'Placed orders')),
        body: const Center(child: Text("Please login to view your orders.")),
      );
    }

    final stream = FirebaseFirestore.instance
        .collection('orders')
        .where("uid", isEqualTo: user.uid)
        .orderBy("createdAt", descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(title: const TitelesTextWidget(label: 'Placed orders')),
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
            return EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "No orders has been placed yet",
              subtitle: "",
              buttonText: "Shop now",
              buttonAction: () {
                Navigator.pushNamed(context, SearchScreen.routName);
              },
            );
          }

          return ListView.separated(
            itemCount: docs.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (ctx, index) {
              final data = docs[index].data();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
                child: OrdersWidget(orderData: data),
              );
            },
          );
        },
      ),
    );
  }
}
