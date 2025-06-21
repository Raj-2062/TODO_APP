import 'package:flutter/material.dart';

/// A [ChangeNotifier] that manages the application's theme mode (light/dark).
class ThemeProvider with ChangeNotifier {
  // Default theme mode is system preference.
  ThemeMode _themeMode = ThemeMode.system;

  /// Gets the current theme mode.
  ThemeMode get themeMode => _themeMode;

  /// Sets the new theme mode and notifies listeners to rebuild widgets.
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners(); // Notify all listening widgets to update.
    }
  }

  /// Toggles between light and dark theme modes.
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
