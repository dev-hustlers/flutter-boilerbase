import 'package:flutter_test/flutter_test.dart';
import 'package:catalyst/features/splash/view/splash_screen.dart';

Future<void> iSeeSplashScreen(WidgetTester tester) async {
  // 1. Immediately verify that the SplashScreen is in the tree
  expect(find.byType(SplashScreen), findsOneWidget);

  // 2. Let the 2-second splash delay timer tick
  await tester.pump(const Duration(seconds: 2));
  
  // 3. Settle the subsequent route transition
  await tester.pump(const Duration(milliseconds: 200));
}
