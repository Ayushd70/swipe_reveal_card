import 'package:flutter/material.dart';

/// A single action revealed when the user swipes a [SwipeRevealCard].
///
/// Provide a [label] and [onPressed] callback. Optionally set [color], [icon],
/// or a fully custom [child] widget.
class SwipeAction {
  /// Creates a swipe action.
  const SwipeAction({
    required this.label,
    required this.onPressed,
    this.color,
    this.icon,
    this.child,
  });

  /// Accessibility / semantics label (also used by the default button UI).
  final String label;

  /// Called when the user taps this action.
  final VoidCallback onPressed;

  /// Foreground color for the default label (and icon, if present).
  ///
  /// Defaults to the ambient [ColorScheme.primary] when null.
  final Color? color;

  /// Optional leading icon for the default button UI.
  final IconData? icon;

  /// Optional custom content. When set, replaces the default icon+label row.
  final Widget? child;
}
