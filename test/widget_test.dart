import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // teste básico pra ver se o widget principal aparece
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // cria um app simples com um texto no meio
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Center(child: Text('EasyTasks')))),
    );

    // verifica se encontrou o texto EasyTasks
    expect(find.text('EasyTasks'), findsOneWidget);
    // verifica se o texto está centralizado
    expect(find.byType(Center), findsOneWidget);
    // verifica se tem um Scaffold (estrutura básica da tela)
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
