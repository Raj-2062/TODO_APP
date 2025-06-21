import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:todo_app/app_theme.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/screens/add_edit_todo_screen.dart';
import 'package:todo_app/screens/settings_screen.dart';
import 'package:todo_app/screens/statistics_screen.dart';

void main() {
  runApp(
    // MultiProvider is used to provide multiple providers to the widget tree.
    MultiProvider(
      providers: [
        // ThemeProvider manages the current theme (light/dark).
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // TodoProvider manages the list of To-Do items.
        ChangeNotifierProvider(create: (_) => TodoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the current theme mode from ThemeProvider.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter To-Do App',
      debugShowCheckedModeBanner: false, // Hide the debug banner

      // Set the theme based on the themeProvider's current themeMode.
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeProvider.themeMode,

      // Define supported locales for localization, especially for date pickers.
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
      ],

      // Define the routes for navigation within the app.
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/add_edit_todo': (context) => const AddEditTodoScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/statistics': (context) => const StatisticsScreen(),
      },
    );
  }
}
