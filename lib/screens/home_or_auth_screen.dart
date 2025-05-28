import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easytasks/screens/auth/auth_screen.dart';
import 'package:flutter_easytasks/screens/home/home_screen.dart';
import 'package:flutter_easytasks/screens/load_screen.dart';

/// Tela que verifica se o usuário está autenticado e exibe a tela apropriada.
class HomeorauthScreen extends StatefulWidget {
  const HomeorauthScreen({super.key});

  @override
  State<HomeorauthScreen> createState() => _HomeorauthScreenState();
}

class _HomeorauthScreenState extends State<HomeorauthScreen> {
  @override
  Widget build(BuildContext context) {
    return
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
          return LoadScreen();
        }

        /// Se o usuário estiver autenticado, exibe a tela inicial, caso contrário, exibe a tela de autenticação.
        if (snapshot.data != null) {
          return HomeScreen(context);
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
