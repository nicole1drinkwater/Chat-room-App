import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color.fromRGBO(52, 183, 241, 1);
  static Color primaryAccent = const Color.fromRGBO(10, 132, 255, 1);
  static Color secondaryColor = const Color.fromRGBO(10, 132, 255, 1);
  static Color secondaryAccent = const Color.fromRGBO(35, 39, 42, 1);
  static Color titleColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color inputTextColor = Colors.black;
  static Color textColor = const Color.fromRGBO(255, 255, 255, 1);
  static Color successColor = const Color.fromRGBO(46, 204, 113, 1);
  static Color highlightColor = const Color.fromRGBO(231, 76, 60, 1);
}

ThemeData primaryTheme = ThemeData(
  // seed
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryColor,
  ),

  scaffoldBackgroundColor: AppColors.secondaryAccent,

  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.secondaryColor,
    foregroundColor: AppColors.textColor,
    surfaceTintColor: Colors.transparent,
    centerTitle: true,
  ),

  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: AppColors.textColor,
      fontSize: 16,
      letterSpacing: 1,
    ),
     headlineMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
      letterSpacing: 1,
    ),
     titleMedium: TextStyle(
      color: AppColors.titleColor,
      fontSize: 30,
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    )
  ),

  cardTheme: CardTheme(
    color: AppColors.secondaryColor.withAlpha(128),
    surfaceTintColor: Colors.transparent,
    shape: const RoundedRectangleBorder(),
    shadowColor: Colors.transparent,
    margin: const EdgeInsets.only(bottom: 16),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.textColor,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
    ),

    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
      color: AppColors.primaryColor, 
      width: 2.0,
    ),
    ),

    labelStyle: TextStyle(color: AppColors.textColor),
    prefixIconColor: AppColors.textColor,
  ),

  dialogTheme: DialogTheme(
    backgroundColor: AppColors.secondaryAccent,
    surfaceTintColor: Colors.transparent,
  ),

);