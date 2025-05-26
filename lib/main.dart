import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easytasks/screens/auth/auth_screen.dart';
import 'package:flutter_easytasks/screens/home/home_screen.dart';
import 'utils/apptheme.dart';
import 'package:firebase_core/firebase_core.dart';

/// Função principal que inicializa o aplicativo.
void main() async {
  /// Garante que os bindings do Flutter estejam inicializados antes de usar qualquer funcionalidade do Flutter.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: FutureBuilder<User?>(
        future: Future.value(FirebaseAuth.instance.currentUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
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
