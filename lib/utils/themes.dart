import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFFE7712D);
const Color primaryDark = Color(0xFFC85711);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: primaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),
  fontFamily: 'Inter',
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Color(0xFF121212),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1E1E1E),
    foregroundColor: primaryColor,
    elevation: 0,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: Colors.grey,
    type: BottomNavigationBarType.fixed,
  ),
  fontFamily: 'Inter',
);
