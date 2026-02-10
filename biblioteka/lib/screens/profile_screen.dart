import 'package:biblioteka/screens/auth/login.dart';
import 'package:biblioteka/screens/resevations/reservations_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import 'package:biblioteka/consts/app.colors.dart';
import 'package:biblioteka/providers/theme_provider.dart';
import 'package:biblioteka/screens/inner_screen/orders/orders_screen.dart';
import 'package:biblioteka/screens/inner_screen/viewed_recently.dart';
import 'package:biblioteka/screens/inner_screen/wishlist.dart';
import 'package:biblioteka/screens/loans/loans_screen.dart';
import 'package:biblioteka/services/assets_manager.dart';
import 'package:biblioteka/widgets/subtitle_text.dart';
import 'package:biblioteka/widgets/title_text.dart';

import 'package:biblioteka/screens/admin/catalog_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Stream<DocumentSnapshot<Map<String, dynamic>>> _userDocStream(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: AssetImage(AssetsManager.logo),
          ),
        ),
        title: const Text("Profile Screen"),
      ),
      body: user == null
          ? const Center(child: Text("Please login."))
          : StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _userDocStream(user.uid),
              builder: (context, snap) {
                final data = snap.data?.data();

                final String name =
                    (data?['name'] ?? user.displayName ?? "User").toString();
                final String email = (data?['email'] ?? user.email ?? "-")
                    .toString();

                final String role = (data?['role'] ?? "user").toString();
                final bool isAdmin = role.toLowerCase().trim() == "admin";

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 5,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.surface,
                                  width: 3,
                                ),
                                image: const DecorationImage(
                                  image: NetworkImage(
                                    "https://cdn.pixabay.com/photo/2017/11/10/05/48/user-2935527_1280.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitelesTextWidget(label: name),
                                SubtitleTextWidget(label: email),
                                if (isAdmin)
                                  const SubtitleTextWidget(
                                    label: "Role: admin",
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Divider(),
                            const TitelesTextWidget(label: "General"),
                            const SizedBox(height: 10),

                            //ADMIN ONLY
                            if (isAdmin)
                              CustomListTile(
                                imagePath:
                                    "${AssetsManager.imagePath}/categories/book.png",
                                text: "Catalog",
                                function: () {
                                  Navigator.pushNamed(
                                    context,
                                    CatalogScreen.routeName,
                                  );
                                },
                              ),

                            CustomListTile(
                              imagePath:
                                  "${AssetsManager.imagePath}/bag/checkout.png",
                              text: "All Orders",
                              function: () {
                                Navigator.pushNamed(
                                  context,
                                  OrdersScreen.routeName,
                                );
                              },
                            ),
                            CustomListTile(
                              imagePath:
                                  "${AssetsManager.imagePath}/bag/wishlist.png",
                              text: "Wishlist",
                              function: () {
                                Navigator.pushNamed(
                                  context,
                                  WishlistScreen.routName,
                                );
                              },
                            ),
                            CustomListTile(
                              imagePath:
                                  "${AssetsManager.imagePath}/profile/repeat.png",
                              text: "Viewed Recently",
                              function: () {
                                Navigator.pushNamed(
                                  context,
                                  ViewedRecentlyScreen.routName,
                                );
                              },
                            ),
                            CustomListTile(
                              imagePath:
                                  "${AssetsManager.imagePath}/categories/book.png",
                              text: "My loans",
                              function: () {
                                Navigator.pushNamed(
                                  context,
                                  LoansScreen.routName,
                                );
                              },
                            ),
                            CustomListTile(
                              imagePath:
                                  "${AssetsManager.imagePath}/categories/book.png",
                              text: "My reservations",
                              function: () {
                                Navigator.pushNamed(
                                  context,
                                  ReservationsScreen.routName,
                                );
                              },
                            ),

                            const Divider(),
                            const TitelesTextWidget(label: "Settings"),
                            SwitchListTile(
                              secondary: Image.asset(
                                "${AssetsManager.imagePath}/profile/night-mode.png",
                                height: 34,
                              ),
                              title: Text(
                                themeProvider.getIsDarkTheme
                                    ? "Dark Theme"
                                    : "Light Theme",
                              ),
                              value: themeProvider.getIsDarkTheme,
                              onChanged: (value) {
                                themeProvider.setDarkTheme(themeValue: value);
                              },
                            ),
                          ],
                        ),
                      ),

                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          icon: const Icon(Icons.logout, color: Colors.white),
                          label: const Text(
                            "Sign out",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            final parentContext = context;

                            final confirmed = await showDialog<bool>(
                              context: parentContext,
                              barrierDismissible: true,
                              builder: (dialogContext) {
                                return AlertDialog(
                                  title: const Text("Sign out"),
                                  content: const Text(
                                    "Are you sure you want to sign out?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, false),
                                      child: const Text("No"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.pop(dialogContext, true),
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmed != true) return;

                            await FirebaseAuth.instance.signOut();

                            if (!parentContext.mounted) return;

                            Navigator.of(
                              parentContext,
                              rootNavigator: true,
                            ).pushNamedAndRemoveUntil(
                              LoginScreen.routeName, 
                              (route) => false,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => function(),
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(imagePath, height: 34),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
