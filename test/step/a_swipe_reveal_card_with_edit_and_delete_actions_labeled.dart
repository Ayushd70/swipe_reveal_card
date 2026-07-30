import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swipe_reveal_card/swipe_reveal_card.dart';

import '../bdd/bdd_world.dart';

/// Usage: a swipe reveal card with Edit and Delete actions labeled {'Swipe me'}
Future<void> aSwipeRevealCardWithEditAndDeleteActionsLabeled(
  WidgetTester tester,
  String label,
) async {
  BddWorld.reset();
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SwipeRevealCard(
          storageKey: 'bdd-card',
          actions: [
            SwipeAction(
              label: 'Edit',
              icon: Icons.edit,
              onPressed: () {
                BddWorld.actionInvoked = true;
                BddWorld.lastActionLabel = 'Edit';
              },
            ),
            SwipeAction(
              label: 'Delete',
              color: Colors.red,
              onPressed: () {
                BddWorld.actionInvoked = true;
                BddWorld.lastActionLabel = 'Delete';
              },
            ),
          ],
          child: SizedBox(height: 72, child: Center(child: Text(label))),
        ),
      ),
    ),
  );
}
