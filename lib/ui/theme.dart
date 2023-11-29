import 'package:flutter/material.dart';
import 'package:gunsayaci/utils/utils.dart';

extension ThemeExtension on BuildContext {
  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;

  ThemeData lightTheme() => ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Poppins',
        textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black87)),
        scaffoldBackgroundColor: KColors.baseColorLight,
        appBarTheme: const AppBarTheme(
          color: KColors.baseColorLight,
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      );

  ThemeData darkTheme() => ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: KColors.baseColorDark,
        colorScheme: const ColorScheme.dark(onPrimary: Colors.white),
        appBarTheme: const AppBarTheme(
          color: KColors.baseColorDark,
          titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      );
}
