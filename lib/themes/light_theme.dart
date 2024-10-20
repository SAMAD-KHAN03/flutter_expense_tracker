import 'package:flutter/material.dart';

// Define a custom color scheme for your dark theme
var kcolorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 55, 15, 149),
  brightness: Brightness.light, // Make sure this matches the brightness setting
);
ThemeData lightTheme = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: const ButtonStyle().copyWith(
      backgroundColor: WidgetStatePropertyAll(
        kcolorScheme.primaryContainer,
      ),
    ),
  ),
  textTheme: const TextTheme().copyWith(
      titleLarge: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 20,
          fontWeight: FontWeight.bold),
      bodySmall: const TextStyle(
          color: Colors.black, fontSize: 18, fontWeight: FontWeight.normal)),
  useMaterial3: true,
  colorScheme: kcolorScheme,
  appBarTheme: const AppBarTheme().copyWith(
    backgroundColor: kcolorScheme.primary,
    foregroundColor: kcolorScheme.primaryContainer,
  ),
  cardTheme: const CardTheme().copyWith(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white),
  iconButtonTheme: const IconButtonThemeData(
    style: ButtonStyle(
      iconColor: WidgetStatePropertyAll(Colors.black),
      iconSize: WidgetStatePropertyAll(25),
    ),
  ),
);
