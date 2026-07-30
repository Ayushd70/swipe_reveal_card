import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('demo app shows swipe cards', (tester) async {
    await tester.pumpWidget(const SwipeRevealCardDemo());

    expect(find.text('Swipe Reveal Card'), findsOneWidget);
    expect(find.text('Design sync'), findsOneWidget);
    expect(find.text('Edit'), findsWidgets);
  });
}
