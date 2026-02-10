import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String themeStatusKey = "THEME_STATUS";

  bool _darkTheme = false;
  bool get getIsDarkTheme => _darkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _darkTheme = prefs.getBool(themeStatusKey) ?? false;
    notifyListeners();
  }

  Future<void> setDarkTheme({required bool themeValue}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeStatusKey, themeValue);
    _darkTheme = themeValue;
    notifyListeners();
  }
}
