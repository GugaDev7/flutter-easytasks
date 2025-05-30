import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/firebase_options.dart';
import 'package:flutter_easytasks/screens/home_or_auth_screen.dart';
import 'utils/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';

/// Função principal que inicializa o aplicativo.
void main() async {
  /// Garante que os bindings do Flutter estejam inicializados antes de usar qualquer funcionalidade do Flutter.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configura o tema do sistema e inicializa o MaterialApp.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppTheme.secondaryColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: AppTheme.primaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

/// Widget raiz do aplicativo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: AppTheme.themeData,
      home: const HomeorauthScreen(),
    );
  }
}
