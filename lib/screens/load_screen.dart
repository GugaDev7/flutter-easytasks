import 'package:flutter/material.dart';
import 'package:flutter_easytasks/utils/apptheme.dart';

/// Tela de carregamento que é exibida durante operações assíncronas, como login ou registro.
class LoadScreen extends StatelessWidget {
  const LoadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.secondaryColor,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/icons/icon_nobg2.png', height: 200),
              const SizedBox(height: 25),
              CircularProgressIndicator(color: AppTheme.primaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
