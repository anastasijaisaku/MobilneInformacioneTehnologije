import 'package:flutter/material.dart';
import 'package:biblioteka/consts/app.colors.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
  }) {
    final Color primaryColor =
        isDarkTheme ? AppColors.darkPrimary : AppColors.lightPrimary;

    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,

      // Card color 
      cardColor: isDarkTheme ? const Color(0xFF1E1E1E) : AppColors.lightCardColor,

      brightness: isDarkTheme ? Brightness.dark : Brightness.light,

      // Osnovna šema boja da bi se primary boja provlačila kroz app
      colorScheme: (isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light())
          .copyWith(
        primary: primaryColor,
        surface: isDarkTheme ? const Color(0xFF1E1E1E) : AppColors.lightCardColor,
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: primaryColor, //  AppBar tamno zelena
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Dugmad da prate Biblioteka stil
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Tekst dugmadi/ikonice 
      iconTheme: IconThemeData(
        color: isDarkTheme ? Colors.white : const Color(0xFF1F2937),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // elegantan fill za inpute
        fillColor: isDarkTheme ? const Color(0xFF1E1E1E) : const Color(0xFFF3EDE1),
        contentPadding: const EdgeInsets.all(10),

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.2,
            color: primaryColor, // fokus border tamno zelena
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.2,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
