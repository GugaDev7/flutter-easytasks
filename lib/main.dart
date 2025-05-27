import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/firebase_options.dart';
import 'package:flutter_easytasks/screens/auth/auth_screen.dart';
import 'package:flutter_easytasks/screens/home/home_screen.dart';
import 'utils/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';

/// Função principal que inicializa o aplicativo.
void main() async {
  /// Garante que os bindings do Flutter estejam inicializados antes de usar qualquer funcionalidade do Flutter.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Configura o tema do sistema e inicializa o MaterialApp.
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppTheme.secondaryColor,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarColor: AppTheme.primaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(MyApp());
}

/// Widget raiz do aplicativo.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Tarefas',
      theme: AppTheme.themeData,
      home: 
      /// Verifica se o usuário está autenticado e exibe a tela apropriada.
      FutureBuilder<User?>(
        future: 
        /// Obtém o usuário atual do Firebase Auth.
        Future.value(FirebaseAuth.instance.currentUser),
        builder: 
        /// Constrói o widget com base no estado da conexão do FutureBuilder.
        (context, snapshot) {
          /// Se a conexão estiver aguardando, exibe um indicador de progresso.
          if (snapshot.connectionState == ConnectionState.waiting) {
            /// Retorna um Scaffold com um CircularProgressIndicator centralizado.
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          /// Se o usuário estiver autenticado, exibe a tela inicial, caso contrário, exibe a tela de autenticação.
          if (snapshot.data != null) {
            return HomeScreen(context);
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}
