import 'package:flutter/material.dart';

import 'swipe_action.dart';
import 'swipe_reveal_controller.dart';
import 'swipe_reveal_group.dart';

/// Horizontally scrollable pane that reveals [actions] beside [child].
class SwipeRevealPane extends StatefulWidget {
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
    this.controller,
    this.group,
    this.enabled = true,
    this.closeOnAction = true,
    this.closeOnCardTap = true,
    this.onOpen,
    this.onClose,
    this.cardOnTap,
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

  /// Optional external controller for open/close.
  final SwipeRevealController? controller;

  /// Optional group that keeps only one card open.
  final SwipeRevealGroup? group;

  /// Whether the user can swipe to reveal actions.
  final bool enabled;

  /// Whether tapping an action closes the card afterward.
  final bool closeOnAction;

  /// Whether tapping the card body closes an open action pane.
  final bool closeOnCardTap;

  /// Called when the action pane finishes opening.
  final VoidCallback? onOpen;

  /// Called when the action pane finishes closing.
  final VoidCallback? onClose;

  /// Optional tap handler for the card body.
  final VoidCallback? cardOnTap;

  @override
  State<SwipeRevealPane> createState() => _SwipeRevealPaneState();
}

class _SwipeRevealPaneState extends State<SwipeRevealPane> {
  late final ScrollController _scrollController;
  late SwipeRevealController _controller;
  bool _ownsController = false;
  bool _isOpen = false;
  bool _animating = false;

  static const _openThresholdFactor = 0.35;
  static const _animationDuration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _bindController(widget.controller);
  }

  @override
  void didUpdateWidget(covariant SwipeRevealPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _unbindController(notifyGroup: true);
      _bindController(widget.controller);
    }
    if (!widget.enabled && _isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _close(animated: false);
        }
      });
    }
  }

  @override
  void dispose() {
    _unbindController(notifyGroup: true);
    _scrollController.dispose();
    super.dispose();
  }

  void _bindController(SwipeRevealController? external) {
    if (external != null) {
      _controller = external;
      _ownsController = false;
    } else {
      _controller = SwipeRevealController();
      _ownsController = true;
    }
    _controller.bind(
      open: () {
        _open();
      },
      close: () {
        _close();
      },
      isOpen: _isOpen,
    );
  }

  void _unbindController({required bool notifyGroup}) {
    if (notifyGroup && _isOpen) {
      widget.group?.handleClosed(_controller);
    }
    _controller.unbind();
    if (_ownsController) {
      _controller.dispose();
    }
  }

  void _setOpenState(bool open) {
    if (_isOpen == open) {
      return;
    }
    _isOpen = open;
    _controller.updateOpen(open);
    if (open) {
      widget.group?.handleOpened(_controller);
      widget.onOpen?.call();
    } else {
      widget.group?.handleClosed(_controller);
      widget.onClose?.call();
    }
  }

  Future<void> _open({bool animated = true}) async {
    if (!widget.enabled || !_scrollController.hasClients || _animating) {
      return;
    }
    final target = _scrollController.position.maxScrollExtent;
    if (target <= 0) {
      return;
    }
    if ((_scrollController.offset - target).abs() < 0.5) {
      _setOpenState(true);
      return;
    }

    _animating = true;
    try {
      if (animated) {
        await _scrollController.animateTo(
          target,
          duration: _animationDuration,
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(target);
      }
    } finally {
      _animating = false;
    }
    if (mounted) {
      _setOpenState(true);
    }
  }

  Future<void> _close({bool animated = true}) async {
    if (!_scrollController.hasClients || _animating) {
      return;
    }
    if (_scrollController.offset.abs() < 0.5) {
      _setOpenState(false);
      return;
    }

    _animating = true;
    try {
      if (animated) {
        await _scrollController.animateTo(
          0,
          duration: _animationDuration,
          curve: Curves.easeOutCubic,
        );
      } else {
        _scrollController.jumpTo(0);
      }
    } finally {
      _animating = false;
    }
    if (mounted) {
      _setOpenState(false);
    }
  }

  void _snapFromScrollEnd() {
    if (!_scrollController.hasClients || _animating) {
      return;
    }
    final max = _scrollController.position.maxScrollExtent;
    if (max <= 0) {
      return;
    }
    final shouldOpen = _scrollController.offset > max * _openThresholdFactor;
    if (shouldOpen) {
      _open();
    } else {
      _close();
    }
  }

  void _onActionPressed(SwipeAction action) {
    action.onPressed();
    if (widget.closeOnAction) {
      _close();
    }
  }

  void _onCardBodyTap() {
    if (_isOpen && widget.closeOnCardTap) {
      _close();
      return;
    }
    widget.cardOnTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth = (screenWidth - widget.horizontalInset).clamp(
      0.0,
      screenWidth,
    );
    final radius = BorderRadius.circular(widget.borderRadius);
    final actionColor =
        widget.actionsBackgroundColor ?? const Color(0xFFF5F7FF);

    Widget cardBody = widget.child;
    if (widget.cardOnTap != null || widget.closeOnCardTap) {
      cardBody = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onCardBodyTap,
          borderRadius: radius,
          child: widget.child,
        ),
      );
    }

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.depth != 0 || _animating) {
          return false;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _snapFromScrollEnd();
          }
        });
        return false;
      },
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: widget.enabled
            ? const ClampingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        key: PageStorageKey<String>(widget.storageKey ?? ''),
        child: DecoratedBox(
          decoration: BoxDecoration(color: actionColor, borderRadius: radius),
          child: Row(
            children: [
              SizedBox(
                width: cardWidth,
                child: Material(
                  color: widget.backgroundColor,
                  borderRadius: radius,
                  clipBehavior: Clip.antiAlias,
                  child: cardBody,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: _ActionColumn(
                  actions: widget.actions,
                  onPressed: _onActionPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionColumn extends StatelessWidget {
  const _ActionColumn({required this.actions, required this.onPressed});

  final List<SwipeAction> actions;
  final ValueChanged<SwipeAction> onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final action in actions)
          InkWell(
            onTap: () => onPressed(action),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child:
                  action.child ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (action.icon != null) ...[
                        Icon(
                          action.icon,
                          size: 18,
                          color: action.color ?? primary,
                        ),
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
