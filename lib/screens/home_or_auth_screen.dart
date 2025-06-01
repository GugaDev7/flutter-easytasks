import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easytasks/screens/auth/auth_screen.dart';
import 'package:flutter_easytasks/screens/home/home_screen.dart';
import 'package:flutter_easytasks/screens/load_screen.dart';

/// Tela que decide se mostra a tela inicial ou a tela de login
class HomeorauthScreen extends StatefulWidget {
  const HomeorauthScreen({super.key});

  @override
  State<HomeorauthScreen> createState() => _HomeorauthScreenState();
}

class _HomeorauthScreenState extends State<HomeorauthScreen> {
  @override
  Widget build(BuildContext context) {
    /// Usa FutureBuilder para verificar se o usuário está logado
    return FutureBuilder<User?>(
      /// Pega o usuário atual do Firebase
      future: Future.value(FirebaseAuth.instance.currentUser),

      /// Constrói a tela baseado no estado da autenticação
      builder: (context, snapshot) {
        /// Se estiver carregando, mostra a tela de loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadScreen();
        }

        /// Se tiver um usuário logado, mostra a tela inicial
        /// Se não, mostra a tela de login
        if (snapshot.data != null) {
          return HomeScreen(context);
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
