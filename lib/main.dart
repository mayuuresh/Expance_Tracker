import 'package:expanse_tracker/expanses.dart';
import 'package:expanse_tracker/firebase_options.dart';
  import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// Set up color schemes for themes
var kColorScheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));
var kdarkcolorscheme = ColorScheme.fromSeed(brightness:Brightness.dark, seedColor:  const Color.fromARGB(255, 5, 99, 125));

void main() async {
  // Ensure widgets are bound before initializing Firebase
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    darkTheme: ThemeData.dark().copyWith(
      colorScheme: kdarkcolorscheme,
      cardTheme: const CardTheme().copyWith(
        color: kdarkcolorscheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kdarkcolorscheme.primaryContainer,
          foregroundColor: kdarkcolorscheme.onPrimaryContainer,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kdarkcolorscheme.primaryContainer,
        foregroundColor: kdarkcolorscheme.onPrimaryContainer,
      ),
    ),
    theme: ThemeData().copyWith(
      colorScheme: kColorScheme,
      appBarTheme: const AppBarTheme().copyWith(
        backgroundColor: kColorScheme.onPrimaryContainer,
        foregroundColor: kColorScheme.primaryContainer,
      ),
      cardTheme: const CardTheme().copyWith(
        color: kColorScheme.primaryContainer,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: kColorScheme.primaryContainer)),
      textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: kColorScheme.onSecondaryContainer,
          fontSize: 15),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: kColorScheme.primaryContainer,
        foregroundColor: kColorScheme.onPrimaryContainer,
      ),
    ),
    themeMode: ThemeMode.dark,
    // Use Expanses widget as the main screen
    home: const Expanses(),
  ));
}
