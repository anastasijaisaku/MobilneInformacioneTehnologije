import 'package:biblioteka/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:biblioteka/providers/cart_provider.dart';
import 'package:biblioteka/screens/cart/bottom_checkout.dart';
import 'package:biblioteka/screens/cart/cart_widget.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/empty_bag.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItems = cartProvider.getCartItems.values.toList();
    final bool isEmpty = cartItems.isEmpty;

    return isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
              title: "Your Cart is Empty",
              subtitle:
                  "Looks like you haven't added \n anything to your cart yet.",
              buttonText: "Shop Now",
               buttonAction: () {
    Navigator.pushNamed(context, SearchScreen.routName);
  },
              
            ),
          )
        : Scaffold(
            bottomSheet: const CartBottomSheetWidget(),
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    "${AssetsManager.imagePath}/logo.png",
                  ),
                ),
              ),
              title: const Text("Biblioteka"),
              actions: [
                IconButton(
                  onPressed: () {
                    cartProvider.clearCart();
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                )
              ],
            ),
            body: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CartWidget(
                  productId: item.productId,
                  title: item.title,
                  imageUrl: item.imageUrl,
                  price: item.price, // STRING
                  quantity: item.quantity,
                );
              },
            ),
          );
  }
}
