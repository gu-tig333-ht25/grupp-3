import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark; 

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isOn) async {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);
    notifyListeners();
  }

  void _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
=======

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoggedIn = false;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLoggedIn => _isLoggedIn;

  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void toggleLogin() {
    _isLoggedIn = !_isLoggedIn;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
>>>>>>> 20895f9f957f5d05cc16b518306da28d1289a448
    notifyListeners();
  }
}
