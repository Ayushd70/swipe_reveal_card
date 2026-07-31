import 'package:flutter/material.dart';

import 'swipe_action.dart';
import 'swipe_reveal_controller.dart';
import 'swipe_reveal_group.dart';
import 'swipe_reveal_pane.dart';

/// A Material-styled card that optionally reveals [actions] on horizontal swipe.
///
/// When [actions] is null or empty, this widget behaves like a simple tappable
/// card. When actions are provided, the user can swipe left to reveal them.
///
/// ```dart
/// final group = SwipeRevealGroup();
///
/// SwipeRevealCard(
///   group: group,
///   closeOnAction: true,
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
    this.controller,
    this.group,
    this.enabled = true,
    this.closeOnAction = true,
    this.closeOnCardTap = true,
    this.onOpen,
    this.onClose,
  });

  /// Content displayed inside the card.
  final Widget child;

  /// Actions revealed by swiping left. Pass `null` or omit for a plain card.
  final List<SwipeAction>? actions;

  /// Card background color. Defaults to white.
  final Color? backgroundColor;

  /// Background behind the revealed action buttons.
  final Color? actionsBackgroundColor;

  /// Called when the card body is tapped (while closed, or when
  /// [closeOnCardTap] is false).
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

  /// Optional controller for programmatic open/close.
  final SwipeRevealController? controller;

  /// Optional group so only one card is open at a time.
  final SwipeRevealGroup? group;

  /// Whether swipe-to-reveal is enabled.
  final bool enabled;

  /// Whether tapping an action closes the revealed pane.
  final bool closeOnAction;

  /// Whether tapping the card body closes an open pane before [onTap].
  final bool closeOnCardTap;

  /// Called when the action pane opens.
  final VoidCallback? onOpen;

  /// Called when the action pane closes.
  final VoidCallback? onClose;

  bool get _hasActions => actions != null && actions!.isNotEmpty;

  bool get _hasShadow {
    final resolved = margin.resolve(TextDirection.ltr);
    return resolved != EdgeInsets.zero;
  }

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.white;
    final radius = BorderRadius.circular(borderRadius);

    if (!_hasActions) {
      Widget content = child;
      if (onTap != null) {
        content = Material(
          color: Colors.transparent,
          child: InkWell(onTap: onTap, borderRadius: radius, child: content),
        );
      }

      return Container(
        margin: margin,
        decoration: BoxDecoration(
          color: bg,
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
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: bg,
          borderRadius: radius,
          clipBehavior: Clip.antiAlias,
          child: content,
        ),
      );
    }

    final resolvedMargin = margin.resolve(TextDirection.ltr);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
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
      child: SwipeRevealPane(
        actions: actions!,
        backgroundColor: bg,
        actionsBackgroundColor: actionsBackgroundColor,
        borderRadius: borderRadius,
        horizontalInset: resolvedMargin.horizontal,
        storageKey: storageKey,
        controller: controller,
        group: group,
        enabled: enabled,
        closeOnAction: closeOnAction,
        closeOnCardTap: closeOnCardTap,
        onOpen: onOpen,
        onClose: onClose,
        cardOnTap: onTap,
        child: child,
      ),
    );
  }
}
