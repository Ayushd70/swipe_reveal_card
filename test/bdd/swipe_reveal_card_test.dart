// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../step/a_plain_swipe_reveal_card_with_text.dart';
import '../step/i_see_text.dart';
import '../step/the_card_is_not_swipable.dart';
import '../step/a_swipe_reveal_card_with_edit_and_delete_actions_labeled.dart';
import '../step/the_card_is_swipable.dart';
import '../step/i_swipe_the_card_left.dart';
import '../step/i_tap_text.dart';
import '../step/the_action_was_invoked.dart';
import '../step/a_tappable_swipe_reveal_card_with_text.dart';
import '../step/the_card_ontap_was_invoked.dart';

void main() {
  group('''Swipe Reveal Card''', () {
    testWidgets('''Plain card shows its child without swipe actions''', (
      tester,
    ) async {
      await aPlainSwipeRevealCardWithText(tester, 'Hello card');
      await iSeeText(tester, 'Hello card');
      await theCardIsNotSwipable(tester);
    });
    testWidgets('''Card with actions shows action labels''', (tester) async {
      await aSwipeRevealCardWithEditAndDeleteActionsLabeled(tester, 'Swipe me');
      await iSeeText(tester, 'Swipe me');
      await iSeeText(tester, 'Edit');
      await iSeeText(tester, 'Delete');
      await theCardIsSwipable(tester);
    });
    testWidgets('''Swiping left and tapping Edit invokes the action''', (
      tester,
    ) async {
      await aSwipeRevealCardWithEditAndDeleteActionsLabeled(tester, 'Swipe me');
      await iSwipeTheCardLeft(tester);
      await iTapText(tester, 'Edit');
      await theActionWasInvoked(tester, 'Edit');
    });
    testWidgets('''Tapping the card body invokes onTap''', (tester) async {
      await aTappableSwipeRevealCardWithText(tester, 'Tap me');
      await iTapText(tester, 'Tap me');
      await theCardOntapWasInvoked(tester);
    });
  });
}
