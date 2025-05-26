import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/screens/auth/auth_screen.dart';
import 'package:flutter_easytasks/screens/home/home_screen.dart';
import 'utils/apptheme.dart';

/// Função principal que inicializa o aplicativo.
void main() {
  runApp(MyApp());
}

/// Widget raiz do aplicativo.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Configura o tema do sistema e inicializa o MaterialApp.
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.backgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: AppTheme.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: AppTheme.themeData,
      home: HomeScreen(context),
    );
  }
}
