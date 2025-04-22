import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4180ab);
  static const Color secondaryColor = Color(0xFF8ab3cf);
  static const Color backgroudColor = Color(0xFFe4ebf0);
  static const Color textColor = Color.fromARGB(255, 0, 0, 0);

  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroudColor,
    colorScheme: ColorScheme.light(primary: textColor, secondary: secondaryColor),
    // fontFamily: '',
  );
}
