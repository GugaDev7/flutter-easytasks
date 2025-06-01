// Importa os pacotes necessários
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/firebase_options.dart';
import 'package:flutter_easytasks/screens/home_or_auth_screen.dart';
import 'utils/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';

// Função principal do app
void main() async {
  // Precisa inicializar o Flutter antes de fazer qualquer coisa
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa o Firebase com as configurações da plataforma atual
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Configura as cores da barra de status e navegação do celular
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          AppTheme.secondaryColor, // Cor da barra de navegação
      systemNavigationBarIconBrightness:
          Brightness.dark, // Ícones escuros na barra
      statusBarColor: AppTheme.primaryColor, // Cor da barra de status
      statusBarIconBrightness:
          Brightness.light, // Ícones claros na barra de status
    ),
  );

  // Inicia o app
  runApp(const MyApp());
}

// Classe principal do app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retorna o MaterialApp que é a base do app
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove a faixa de debug
      title: 'Lista de Tarefas', // Título do app
      theme: AppTheme.themeData, // Tema personalizado
      home: const HomeorauthScreen(), // Tela inicial
    );
  }
}
