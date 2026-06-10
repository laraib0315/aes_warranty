import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  SettingsProvider() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('themeMode');
    if (saved == 'light') {
      _themeMode = ThemeMode.light;
    } else if (saved == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    String? value;
    if (mode == ThemeMode.light) {
      value = 'light';
    } else if (mode == ThemeMode.dark) {
      value = 'dark';
    } else {
      value = 'system';
    }
    await prefs.setString('themeMode', value);
    notifyListeners();
  }
}
