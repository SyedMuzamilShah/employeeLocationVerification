import 'package:flutter/material.dart';
import 'package:my_mobile_app/core/constants/app_colors.dart';

extension CustomColors on ColorScheme {
  Color get success => const Color(0xFF388E3C);
}

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryVariant,
      secondary: AppColors.secondary,
      secondaryContainer: AppColors.secondaryVariant,
      surface: AppColors.surface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.darkSurface,
      surfaceContainerHighest: AppColors.onBackground,
      onError: AppColors.onError,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(color: AppColors.grey),
      labelStyle: TextStyle(color: AppColors.darkGrey),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: AppColors.onBackground),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.onBackground),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.primaryVariant,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryVariant,
      primaryContainer: AppColors.primary,
      secondary: AppColors.secondaryVariant,
      secondaryContainer: AppColors.secondary,
      surface: AppColors.darkSurface,
      error: AppColors.error,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.onBackground,
      onError: AppColors.onError,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.darkGrey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.error, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.secondary),
      ),
      hintStyle: TextStyle(color: AppColors.lightGrey),
      labelStyle: TextStyle(color: AppColors.grey),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(color: AppColors.white),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.white),
    ),
  );
}
