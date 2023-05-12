import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class ThemeModel extends ChangeNotifier {
  bool isDarkMode = ui.window.platformBrightness == ui.Brightness.dark;
  bool exDarkMode = false;
  bool systemTheme = true;

  ThemeModel() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    systemTheme = prefs.getBool('systemTheme') ?? systemTheme;
    if (systemTheme) {
      isDarkMode = ui.window.platformBrightness == ui.Brightness.dark;
    } else {
      isDarkMode = prefs.getBool('isDarkMode') ?? isDarkMode;
    }
    notifyListeners();
  }

  Future<void> _saveThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
    await prefs.setBool('systemTheme', systemTheme);
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    exDarkMode = isDarkMode;
    _saveThemePreference();
    notifyListeners();
  }

  void chooseTheme(value) {
    systemTheme = value;
    if (systemTheme) {
      isDarkMode = ui.window.platformBrightness == ui.Brightness.dark;
    } else {
      isDarkMode = exDarkMode;
    }
    _saveThemePreference();
    notifyListeners();
  }
}
