import 'package:biblioteka/screens/resevations/reservations_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:biblioteka/consts/theme_data.dart';
import 'package:biblioteka/providers/theme_provider.dart';
import 'package:biblioteka/providers/loan_provider.dart';
import 'package:biblioteka/providers/reservation_provider.dart';
import 'package:biblioteka/providers/review_provider.dart';
import 'package:biblioteka/screens/auth/login.dart';
import 'package:biblioteka/screens/auth/register.dart';
import 'package:biblioteka/screens/inner_screen/orders/orders_screen.dart';
import 'package:biblioteka/screens/inner_screen/product_details.dart';
import 'package:biblioteka/screens/inner_screen/viewed_recently.dart';
import 'package:biblioteka/screens/inner_screen/wishlist.dart';
import 'package:biblioteka/screens/loans/loans_screen.dart';
import 'package:biblioteka/screens/root_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => ReservationProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Biblioteka',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            home: const LoginScreen(),
            routes: {
              RootScreen.routeName: (context) => const RootScreen(),
              ProductDetailsScreen.routName: (context) =>
                  const ProductDetailsScreen(),
              WishlistScreen.routName: (context) => const WishlistScreen(),
              ViewedRecentlyScreen.routName: (context) =>
                  const ViewedRecentlyScreen(),
              RegisterScreen.routName: (context) => const RegisterScreen(),
              LoginScreen.routeName: (context) => const LoginScreen(),
              OrdersScreen.routeName: (context) => const OrdersScreen(),
              LoansScreen.routName: (context) => const LoansScreen(),
              ReservationsScreen.routName: (context) =>
                  const ReservationsScreen(),
            },
          );
        },
      ),
    );
  }
}
