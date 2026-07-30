import 'package:flutter/material.dart';

import 'swipe_action.dart';
import 'swipe_reveal_pane.dart';

/// A Material-styled card that optionally reveals [actions] on horizontal swipe.
///
/// When [actions] is null or empty, this widget behaves like a simple tappable
/// card. When actions are provided, the user can swipe left to reveal them.
///
/// ```dart
/// SwipeRevealCard(
///   onTap: () {},
///   actions: [
///     SwipeAction(
///       label: 'Edit',
///       icon: Icons.edit,
///       onPressed: () {},
///     ),
///     SwipeAction(
///       label: 'Delete',
///       color: Colors.red,
///       icon: Icons.delete,
///       onPressed: () {},
///     ),
///   ],
///   child: ListTile(title: Text('Hello')),
/// )
/// ```
class SwipeRevealCard extends StatelessWidget {
  /// Creates a swipe-reveal card.
  const SwipeRevealCard({
    super.key,
    required this.child,
    this.actions,
    this.backgroundColor,
    this.actionsBackgroundColor,
    this.onTap,
    this.borderRadius = 10,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.elevation = 4,
    this.storageKey,
  });

  /// Content displayed inside the card.
  final Widget child;

  /// Actions revealed by swiping left. Pass `null` or omit for a plain card.
  final List<SwipeAction>? actions;

  /// Card background color. Defaults to white.
  final Color? backgroundColor;

  /// Background behind the revealed action buttons.
  final Color? actionsBackgroundColor;

  /// Called when the card body is tapped.
  final VoidCallback? onTap;

  /// Corner radius of the card.
  final double borderRadius;

  /// Outer margin around the card.
  ///
  /// When [margin] is [EdgeInsets.zero], the drop shadow is disabled.
  final EdgeInsetsGeometry margin;

  /// Soft shadow depth. Ignored when [margin] is zero.
  final double elevation;

  /// Optional key for restoring horizontal scroll position via [PageStorage].
  final String? storageKey;

  bool get _hasActions => actions != null && actions!.isNotEmpty;

  bool get _hasShadow {
    final resolved = margin.resolve(TextDirection.ltr);
    return resolved != EdgeInsets.zero;
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.white;
    final radius = BorderRadius.circular(borderRadius);

    Widget content = child;

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, borderRadius: radius, child: content),
      );
    }

    if (_hasActions) {
      final resolvedMargin = margin.resolve(TextDirection.ltr);
      content = SwipeRevealPane(
        actions: actions!,
        backgroundColor: bg,
        actionsBackgroundColor: actionsBackgroundColor,
        borderRadius: borderRadius,
        horizontalInset: resolvedMargin.horizontal,
        storageKey: storageKey,
        child: content,
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: _hasActions ? null : bg,
        borderRadius: radius,
        boxShadow: [
          if (_hasShadow)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: elevation * 7.5,
              offset: Offset(0, elevation),
              spreadRadius: 0,
            ),
        ],
      ),
      clipBehavior: _hasActions ? Clip.none : Clip.antiAlias,
      child: _hasActions
          ? content
          : Material(
              color: bg,
              borderRadius: radius,
              clipBehavior: Clip.antiAlias,
              child: content,
            ),
    );
  }
}
