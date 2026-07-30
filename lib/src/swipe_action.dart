import 'package:flutter/material.dart';

/// A single action revealed when the user swipes a [SwipeRevealCard].
///
/// Provide a [label] and [onPressed] callback. Optionally set [color] and
/// [icon] for richer action buttons.
class SwipeAction {
  /// Creates a swipe action.
  const SwipeAction({
    required this.label,
    required this.onPressed,
    this.color,
    this.icon,
  });

  /// Text shown on the action button.
  final String label;

  /// Called when the user taps this action.
  final VoidCallback onPressed;

  /// Foreground color for the label (and icon, if present).
  ///
  /// Defaults to the ambient [ThemeData.primaryColor] when null.
  final Color? color;

  /// Optional leading icon displayed beside [label].
  final IconData? icon;
}
