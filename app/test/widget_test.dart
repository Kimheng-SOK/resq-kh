import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app/app.dart';

void main() {
  testWidgets('App smoke test — renders without crashing', (
    WidgetTester tester,
  ) async {
    await dotenv.load();

    await tester.pumpWidget(const ResQApp(initialRoute: '/'));
    // Pump past the 2-second splash screen delay + navigation
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 1));

    // App should have rendered without crashing
    // ResQApp is still in the tree as the root
    expect(find.byType(ResQApp), findsOneWidget);
  });
}
