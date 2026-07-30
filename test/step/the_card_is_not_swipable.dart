import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the card is not swipable
Future<void> theCardIsNotSwipable(WidgetTester tester) async {
  expect(find.byType(SingleChildScrollView), findsNothing);
}
