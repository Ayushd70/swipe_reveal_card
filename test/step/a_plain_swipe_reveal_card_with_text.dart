import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swipe_reveal_card/swipe_reveal_card.dart';

import '../bdd/bdd_world.dart';

/// Usage: a plain swipe reveal card with text {'Hello card'}
Future<void> aPlainSwipeRevealCardWithText(
  WidgetTester tester,
  String text,
) async {
  BddWorld.reset();
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SwipeRevealCard(child: Text(text))),
    ),
  );
}
