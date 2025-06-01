import 'package:flutter/material.dart';

/// Classe que define o tema do aplicativo, incluindo cores e estilos.
class AppTheme {
  // Cores principais do app
  static const Color primaryColor = Color(0xFF4180ab); // Azul principal
  static const Color secondaryColor = Color(0xFF8ab3cf); // Azul mais claro
  static const Color backgroundColor = Color(0xFFe4ebf0); // Cor de fundo

  /// Definir Cor de Botões
  static const Color dialogBtn = AppTheme.primaryColor; // Usa a cor principal

  // Tema claro
  static final ThemeData themeData = ThemeData(
    primaryColor: primaryColor, // Cor principal em todo app
    scaffoldBackgroundColor: backgroundColor, // Cor de fundo das telas
    colorScheme: ColorScheme.light(
      primary: primaryColor, // Cor principal
      secondary: secondaryColor, // Cor secundária
      surface: backgroundColor, // Cor de superfície
    ),
    fontFamily: 'PoetsenOne-Regular', // Fonte personalizada
  );
}
