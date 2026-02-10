import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biblioteka/providers/cart_provider.dart';
import 'package:biblioteka/services/orders_service.dart';
import 'package:biblioteka/screens/inner_screen/orders/orders_screen.dart';

class CartBottomSheetWidget extends StatelessWidget {
  const CartBottomSheetWidget({super.key});

  Future<void> _processCheckout(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    if (cartProvider.getCartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Korpa je prazna.")),
      );
      return;
    }

    
    final nav = Navigator.of(context, rootNavigator: true);

    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final service = OrdersService();

      
      await service
          .createOrderFromCart(cartProvider)
          .timeout(const Duration(seconds: 15));

      await cartProvider.clearCart();

     
      if (nav.canPop()) nav.pop();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Porudžbina je kreirana ✅")),
        );

        
        Navigator.pushNamed(context, OrdersScreen.routeName);
      }
    } on TimeoutException {
      if (nav.canPop()) nav.pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Checkout timeout (pokušaj ponovo).")),
        );
      }
    } catch (e) {
      
      if (nav.canPop()) nav.pop();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Checkout failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(top: BorderSide(color: Colors.black12)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total (${cartProvider.totalProducts} products / ${cartProvider.totalItems} items)",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${cartProvider.totalPrice.toStringAsFixed(0)} RSD",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _processCheckout(context),
              child: const Text("Checkout"),
            ),
          ],
        ),
      ),
    );
  }
}
