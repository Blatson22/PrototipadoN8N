import 'package:flutter_test/flutter_test.dart';

import 'package:prototipado/main.dart';

void main() {
  testWidgets('Chat app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ChatApp());

    expect(find.text('Chat con n8n + IA'), findsOneWidget);
    expect(find.text('Escribe algo para empezar la conversación'), findsOneWidget);
  });
}