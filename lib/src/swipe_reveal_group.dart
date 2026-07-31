import 'swipe_reveal_controller.dart';

/// Ensures only one card in a set is open at a time.
///
/// Share one [SwipeRevealGroup] across list items and pass it to each
/// [SwipeRevealCard.group]. Opening a card closes the previously open one.
class SwipeRevealGroup {
  SwipeRevealController? _active;

  /// The controller that is currently open, if any.
  SwipeRevealController? get active => _active;

  /// Called by a card when it becomes open.
  void handleOpened(SwipeRevealController controller) {
    if (_active != null && !identical(_active, controller)) {
      _active!.close();
    }
    _active = controller;
  }

  /// Called by a card when it becomes closed.
  void handleClosed(SwipeRevealController controller) {
    if (identical(_active, controller)) {
      _active = null;
    }
  }

  /// Closes whichever card is currently open.
  void closeAll() {
    _active?.close();
    _active = null;
  }
}
