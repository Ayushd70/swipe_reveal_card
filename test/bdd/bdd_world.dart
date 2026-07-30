/// Shared state for BDD step definitions.
class BddWorld {
  BddWorld._();

  static bool actionInvoked = false;
  static String? lastActionLabel;
  static bool cardTapped = false;

  static void reset() {
    actionInvoked = false;
    lastActionLabel = null;
    cardTapped = false;
  }
}
