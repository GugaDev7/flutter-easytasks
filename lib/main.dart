import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Lista de Tarefas', theme: AppTheme.themeData, home: HomeScreen(name: ""));
  }
}
