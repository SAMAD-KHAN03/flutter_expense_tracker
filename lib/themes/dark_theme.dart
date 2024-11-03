import 'package:flutter/material.dart';

var kdarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(227, 9, 43, 53),
  brightness: Brightness.dark,
);

ThemeData darktheme = ThemeData(
  primaryTextTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color.fromARGB(255, 59, 83, 94)),
  ),
  colorScheme: kdarkColorScheme,
  cardTheme: const CardTheme().copyWith(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    color: const Color.fromARGB(255, 217, 217, 217),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor:
          WidgetStatePropertyAll(kdarkColorScheme.primaryContainer),
    ),
  ),
  textTheme: const TextTheme().copyWith(
    titleLarge: const TextStyle(
      color: Colors.white, // Change to white for better visibility
      fontSize: 25,
      fontWeight: FontWeight.w600,
    ),
    bodySmall: const TextStyle(
      color: Color.fromARGB(
          255, 28, 28, 28), // Change to white for better visibility
      fontSize: 18,
      fontWeight: FontWeight.normal,
    ),
  ),
  useMaterial3: true,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kdarkColorScheme.surfaceBright,
    foregroundColor: kdarkColorScheme.primaryContainer,
  ),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconSize: WidgetStatePropertyAll(16),
      iconColor: WidgetStatePropertyAll(
          Color.fromARGB(255, 217, 217, 217)), // Change to white
    ),
  ),
);
