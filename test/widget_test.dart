// Testes básicos do App Amamenta

import 'package:flutter_test/flutter_test.dart';

import 'package:app_amamenta/main.dart';

void main() {
  testWidgets('App deve inicializar com o cronômetro em 00:00', (WidgetTester tester) async {
    // Build do app e dispara um frame
    await tester.pumpWidget(const AppAmamenta());

    // Verifica se o cronômetro começa em 00:00
    expect(find.text('00 : 00'), findsOneWidget);
    
    // Verifica se os botões Esquerdo e Direito estão presentes
    expect(find.text('Esquerdo'), findsOneWidget);
    expect(find.text('Direito'), findsOneWidget);
    
    // Verifica se o botão de entrada manual está presente
    expect(find.text('Entrada Manual'), findsOneWidget);
  });
}
