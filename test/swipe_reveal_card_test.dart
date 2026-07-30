import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swipe_reveal_card/swipe_reveal_card.dart';

void main() {
  test('SwipeAction holds configured values', () {
    var pressed = false;
    final action = SwipeAction(
      label: 'Archive',
      color: Colors.blue,
      icon: Icons.archive,
      onPressed: () => pressed = true,
    );

    expect(action.label, 'Archive');
    expect(action.color, Colors.blue);
    expect(action.icon, Icons.archive);
    action.onPressed();
    expect(pressed, isTrue);
  });
}
