import 'package:flutter_test/flutter_test.dart';
import 'package:i_wow/main.dart';

void main() {
  testWidgets('Salem', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
  });
}
