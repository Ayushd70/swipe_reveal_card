import 'package:flutter/material.dart';

import 'swipe_action.dart';

/// Horizontally scrollable pane that reveals [actions] beside [child].
class SwipeRevealPane extends StatelessWidget {
  /// Creates a swipe-reveal pane.
  const SwipeRevealPane({
    super.key,
    required this.child,
    required this.actions,
    required this.backgroundColor,
    required this.borderRadius,
    this.actionsBackgroundColor,
    this.horizontalInset = 32,
    this.storageKey,
  });

  /// The foreground card content.
  final Widget child;

  /// Actions shown when the user swipes left.
  final List<SwipeAction> actions;

  /// Background color of the foreground card area.
  final Color backgroundColor;

  /// Background behind the action buttons.
  final Color? actionsBackgroundColor;

  /// Corner radius applied to the pane.
  final double borderRadius;

  /// Total horizontal inset used when sizing the card width
  /// (`screenWidth - horizontalInset`). Typically `margin.horizontal`.
  final double horizontalInset;

  /// Key used with [PageStorage] so scroll offset is restored.
  final String? storageKey;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth - horizontalInset).clamp(0.0, screenWidth);
    final radius = BorderRadius.circular(borderRadius);
    final actionColor = actionsBackgroundColor ?? const Color(0xFFF5F7FF);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      key: PageStorageKey<String>(storageKey ?? ''),
      child: DecoratedBox(
        decoration: BoxDecoration(color: actionColor, borderRadius: radius),
        child: Row(
          children: [
            SizedBox(
              width: cardWidth,
              child: Material(
                color: backgroundColor,
                borderRadius: radius,
                clipBehavior: Clip.antiAlias,
                child: child,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _ActionColumn(actions: actions),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionColumn extends StatelessWidget {
  const _ActionColumn({required this.actions});

  final List<SwipeAction> actions;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final action in actions)
          InkWell(
            onTap: action.onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (action.icon != null) ...[
                    Icon(action.icon, size: 18, color: action.color ?? primary),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    action.label,
                    style: TextStyle(
                      color: action.color ?? primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
