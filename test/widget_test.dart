// Testes básicos do App Amamenta

import 'package:flutter_test/flutter_test.dart';

import 'package:app_amamenta/main.dart';

void main() {
  testWidgets('App deve inicializar com a tela de login', (WidgetTester tester) async {
    // Build do app e dispara um frame
    await tester.pumpWidget(const AppAmamenta());

    // Verifica se está na tela de login
    expect(find.text('Bem-vindo de volta'), findsOneWidget);
    
    // Verifica se o botão de entrar está presente
    expect(find.text('ENTRAR'), findsOneWidget);
  });
}
