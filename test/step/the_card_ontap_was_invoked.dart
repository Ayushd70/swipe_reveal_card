import 'package:flutter_test/flutter_test.dart';

import '../bdd/bdd_world.dart';

/// Usage: the card onTap was invoked
Future<void> theCardOntapWasInvoked(WidgetTester tester) async {
  expect(BddWorld.cardTapped, isTrue);
}
