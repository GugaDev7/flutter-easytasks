import 'package:flutter/material.dart';

/// Classe que define o tema do aplicativo, incluindo cores e estilos.
class AppTheme {
  // Cores claras
  static const Color primaryColor = Color(0xFF4180ab);
  static const Color secondaryColor = Color(0xFF8ab3cf);
  static const Color backgroundColor = Color(0xFFe4ebf0);

  /// Definir Cor de Botões
  static const Color dialogBtn = AppTheme.primaryColor;

  // Tema claro
  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(primary: primaryColor, secondary: secondaryColor, surface: backgroundColor),
    fontFamily: 'PoetsenOne-Regular',
  );
}
