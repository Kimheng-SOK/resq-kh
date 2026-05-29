import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ResQApp());
    await tester.pumpAndSettle();

    // Verify the app loads and shows the home screen with SOS button
    expect(find.text('SOS'), findsOneWidget);
    expect(find.text('Emergency'), findsOneWidget);
  });
}
