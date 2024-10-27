import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static InputBorder _border(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 3),
      borderRadius: BorderRadius.circular(11),
    );
  }

  static ThemeData darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    chipTheme: const ChipThemeData(color: MaterialStatePropertyAll(AppPallete.backgroundColor), side: BorderSide.none),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: _border(AppPallete.gradient2),
      contentPadding: const EdgeInsets.all(21),
      enabledBorder: _border(AppPallete.borderColor),
      focusColor: AppPallete.gradient1,
      border: _border(AppPallete.borderColor),
      errorBorder: _border(AppPallete.errorColor),
    ),
    
    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.backgroundColor)
  );
}
