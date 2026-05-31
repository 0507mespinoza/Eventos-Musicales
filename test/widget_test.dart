
import 'package:flutter_test/flutter_test.dart';
import 'package:michaelespinozac1/main.dart';

void main() {
  testWidgets('La app inicia sin errores', (WidgetTester tester) async {
    // Solo verificar que la app no crashea al iniciar
    await tester.pumpWidget(MyApp());
    expect(find.byType(Scaffold), findsOneWidget);
  });
}

class Scaffold {
}