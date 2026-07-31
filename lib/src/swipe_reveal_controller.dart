import 'package:flutter/foundation.dart';

/// Controls open/close state for a [SwipeRevealCard].
///
/// Attach via [SwipeRevealCard.controller]. Dispose the controller when the
/// owning widget is disposed if you created it yourself.
class SwipeRevealController extends ChangeNotifier {
  VoidCallback? _open;
  VoidCallback? _close;
  bool _isOpen = false;
  bool _attached = false;

  /// Whether the action pane is currently revealed.
  bool get isOpen => _isOpen;

  /// Whether this controller is attached to a card in the tree.
  bool get isAttached => _attached;

  /// Opens the action pane (no-op if already open or unattached).
  void open() => _open?.call();

  /// Closes the action pane (no-op if already closed or unattached).
  void close() => _close?.call();

  /// Toggles between open and closed.
  void toggle() {
    if (_isOpen) {
      close();
    } else {
      open();
    }
  }

  /// Binds this controller to a card implementation.
  ///
  /// Called internally by the package — do not use from app code.
  void bind({
    required VoidCallback open,
    required VoidCallback close,
    required bool isOpen,
  }) {
    _open = open;
    _close = close;
    _attached = true;
    if (_isOpen != isOpen) {
      _isOpen = isOpen;
      notifyListeners();
    }
  }

  /// Unbinds this controller from a card implementation.
  ///
  /// Called internally by the package — do not use from app code.
  void unbind() {
    _open = null;
    _close = null;
    _attached = false;
  }

  /// Updates open state from the card implementation.
  ///
  /// Called internally by the package — do not use from app code.
  void updateOpen(bool value) {
    if (_isOpen == value) {
      return;
    }
    _isOpen = value;
    notifyListeners();
  }
}
