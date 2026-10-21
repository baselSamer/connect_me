import 'package:flutter/material.dart';

abstract final class AppPalette {
  static const violet = Color(0xFF6259D8);
  static const violetLight = Color(0xFF8A83F0);
  static const ink = Color(0xFF202137);
  static const muted = Color(0xFF9294A9);
  static const surface = Color(0xFFF5F5FA);
  static const plum = Color(0xFF1B1429);
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: AppPalette.violet);
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme.copyWith(primary: AppPalette.violet),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppPalette.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppPalette.ink,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppPalette.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: AppPalette.violet, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppPalette.violet,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        minimumSize: const Size(0, 52),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: AppPalette.ink,
        fontWeight: FontWeight.w800,
      ),
      headlineSmall: TextStyle(
        color: AppPalette.ink,
        fontWeight: FontWeight.w800,
      ),
      titleLarge: TextStyle(color: AppPalette.ink, fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(color: AppPalette.ink),
    ),
  );
}
