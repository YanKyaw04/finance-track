import 'package:fintrack/core/constants/color.dart';
import 'package:fintrack/core/constants/text_style.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardLight,
      onPrimary: AppColors.cardLight,
      onSecondary: AppColors.cardLight,
      onSurface: AppColors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.title,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primary),
    cardColor: AppColors.cardLight,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.cardDark,
      onPrimary: AppColors.cardDark,
      onSecondary: AppColors.cardDark,
      onSurface: AppColors.cardLight,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: AppTextStyles.title.copyWith(color: AppColors.cardDark),
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.cardDark),
    ),
    cardColor: AppColors.cardDark,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: AppColors.primary),
    useMaterial3: true,
  );
}
