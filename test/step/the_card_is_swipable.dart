import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Usage: the card is swipable
Future<void> theCardIsSwipable(WidgetTester tester) async {
  expect(find.byType(SingleChildScrollView), findsOneWidget);
}
