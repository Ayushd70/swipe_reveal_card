import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swipe_reveal_card/swipe_reveal_card.dart';

import '../bdd/bdd_world.dart';

/// Usage: a tappable swipe reveal card with text {'Tap me'}
Future<void> aTappableSwipeRevealCardWithText(
  WidgetTester tester,
  String text,
) async {
  BddWorld.reset();
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SwipeRevealCard(
          onTap: () => BddWorld.cardTapped = true,
          child: SizedBox(
            height: 72,
            width: double.infinity,
            child: Text(text),
          ),
        ),
      ),
    ),
  );
}
