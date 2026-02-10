import 'package:biblioteka/screens/admin/catalog_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

// PROVIDERS
import 'package:biblioteka/providers/theme_provider.dart';
import 'package:biblioteka/providers/products_provider.dart';
import 'package:biblioteka/providers/cart_provider.dart';
import 'package:biblioteka/providers/wishlist_provider.dart';
import 'package:biblioteka/providers/viewed_recently_provider.dart';
import 'package:biblioteka/providers/loan_provider.dart';
import 'package:biblioteka/providers/reservation_provider.dart';
import 'package:biblioteka/providers/review_provider.dart';

// THEME
import 'package:biblioteka/consts/theme_data.dart';

// SCREENS
import 'package:biblioteka/screens/auth/login.dart';
import 'package:biblioteka/screens/auth/register.dart';
import 'package:biblioteka/screens/auth/forgot_password.dart';
import 'package:biblioteka/screens/root_screen.dart';
import 'package:biblioteka/screens/search_screen.dart';
import 'package:biblioteka/screens/categories/categories_books_screen.dart';
import 'package:biblioteka/screens/inner_screen/product_details.dart';
import 'package:biblioteka/screens/inner_screen/wishlist.dart';
import 'package:biblioteka/screens/inner_screen/viewed_recently.dart';
import 'package:biblioteka/screens/inner_screen/orders/orders_screen.dart';
import 'package:biblioteka/screens/loans/loans_screen.dart';
import 'package:biblioteka/screens/resevations/reservations_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
  
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => ViewedProdProvider()),

        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Biblioteka',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const AuthGate(),
            routes: {
              // AUTH
              LoginScreen.routeName: (context) => const LoginScreen(),
              RegisterScreen.routName: (context) => const RegisterScreen(),
              ForgotPasswordScreen.routeName: (context) =>
                  const ForgotPasswordScreen(),

              // ROOT
              RootScreen.routeName: (context) => const RootScreen(),

              // INNER
              ProductDetailsScreen.routName: (context) =>
                  const ProductDetailsScreen(),
              WishlistScreen.routName: (context) => const WishlistScreen(),
              ViewedRecentlyScreen.routName: (context) =>
                  const ViewedRecentlyScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),

              // OTHER
              LoansScreen.routName: (context) => const LoansScreen(),
              ReservationsScreen.routName: (context) =>
                  const ReservationsScreen(),
              SearchScreen.routName: (context) => const SearchScreen(),
              CategoryBooksScreen.routeName: (context) =>
                  const CategoryBooksScreen(),
              CatalogScreen.routeName: (context) => const CatalogScreen(),

            },
          );
        },
      ),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snap.data;
        if (user == null) {
          return const LoginScreen();
        }
        return const RootScreen();
      },
    );
  }
}
