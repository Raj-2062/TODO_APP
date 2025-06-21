import 'package:flutter/material.dart';

/// Defines the light and dark themes for the application.
class AppThemes {
  // Common text style for the app to ensure consistency
  static const TextStyle _appBarTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle _bodyTextStyle = TextStyle(
    fontSize: 16,
  );

  static const TextStyle _titleTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  /// Light theme data for the application.
  static final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue, // Primary color for light theme
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white, // Background color for scaffolds
      appBarTheme: const AppBarTheme(
        color: Colors.blue, // AppBar background color
        foregroundColor: Colors.white, // AppBar icons and text color
        titleTextStyle: _appBarTextStyle,
        centerTitle: true,
        elevation: 4.0, // Shadow beneath the app bar
      ),
      textTheme: TextTheme(
        bodyMedium: _bodyTextStyle.copyWith(color: Colors.black87),
        titleMedium: _titleTextStyle.copyWith(color: Colors.black87),
        titleLarge: _appBarTextStyle.copyWith(color: Colors.black87),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Rounded corners for buttons
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.blue, // Cursor color in text fields
        selectionColor: Colors.blueAccent, // Selection highlight color
        selectionHandleColor: Colors.blue, // Selection handle color
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.blue),
        floatingLabelStyle: const TextStyle(color: Colors.blue),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue;
          }
          return Colors.grey;
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue;
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.blue.shade200;
          }
          return Colors.grey.shade300;
        }),
      )
  );

  /// Dark theme data for the application.
  static final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.indigo, // Primary color for dark theme
      primaryColor: Colors.indigo,
      scaffoldBackgroundColor: Colors.grey[900], // Dark background
      appBarTheme: AppBarTheme(
        color: Colors.grey[850], // Darker AppBar background
        foregroundColor: Colors.white, // AppBar icons and text color
        titleTextStyle: _appBarTextStyle,
        centerTitle: true,
        elevation: 4.0,
      ),
      textTheme: TextTheme(
        bodyMedium: _bodyTextStyle.copyWith(color: Colors.white70),
        titleMedium: _titleTextStyle.copyWith(color: Colors.white),
        titleLarge: _appBarTextStyle.copyWith(color: Colors.white),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.indigo,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.indigo,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.indigo,
        selectionColor: Colors.indigoAccent,
        selectionHandleColor: Colors.indigo,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.indigo),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.indigo, width: 2),
        ),
        labelStyle: const TextStyle(color: Colors.indigo),
        floatingLabelStyle: const TextStyle(color: Colors.indigo),
      ),
      cardTheme: CardTheme(
        color: Colors.grey[800],
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        backgroundColor: Colors.grey[850],
        titleTextStyle: _titleTextStyle.copyWith(color: Colors.white),
        contentTextStyle: _bodyTextStyle.copyWith(color: Colors.white70),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.indigo;
          }
          return Colors.grey.shade600;
        }),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.indigo;
          }
          return Colors.grey.shade600;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.indigo.shade200;
          }
          return Colors.grey.shade700;
        }),
      )
  );
}
