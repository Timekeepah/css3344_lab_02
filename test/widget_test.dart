import 'package:flutter_test/flutter_test.dart';

import 'package:first_flutter_app/main.dart';

void main() {
  testWidgets('Student profile opens', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentInfoApp());
    await tester.pumpAndSettle();
    expect(find.text('CSS3344 Mobile App Dev - Lab 02'), findsOneWidget);
    expect(find.text('ALEEF DANIAL BIN ABDUL RAHMAN'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
