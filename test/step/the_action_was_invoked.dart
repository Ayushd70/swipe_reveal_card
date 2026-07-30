import 'package:flutter_test/flutter_test.dart';

import '../bdd/bdd_world.dart';

/// Usage: the {'Edit'} action was invoked
Future<void> theActionWasInvoked(WidgetTester tester, String label) async {
  expect(BddWorld.actionInvoked, isTrue);
  expect(BddWorld.lastActionLabel, label);
}
