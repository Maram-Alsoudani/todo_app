import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/AppColors.dart';

class MyAppTheme {
  //light
  static final ThemeData lightMode = ThemeData(
      scaffoldBackgroundColor: AppColors.main_background_color_light,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary_color,
      ),
      textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary_color,
          unselectedItemColor: AppColors.grey),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary_color,
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 4, color: AppColors.white),
              borderRadius: BorderRadius.circular(40))));

  //dark
  static final ThemeData DarkMode = ThemeData(
      scaffoldBackgroundColor: AppColors.main_background_color_dark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary_color,
      ),
      textTheme: TextTheme(
          titleLarge: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.white)),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary_color,
          unselectedItemColor: AppColors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary_color,
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 4, color: AppColors.black_dark),
              borderRadius: BorderRadius.circular(40))));
}
