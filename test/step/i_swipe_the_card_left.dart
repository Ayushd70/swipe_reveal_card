import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: I swipe the card left
Future<void> iSwipeTheCardLeft(WidgetTester tester) async {
  await tester.drag(find.byType(SingleChildScrollView), const Offset(-220, 0));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}
