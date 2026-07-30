# swipe_reveal_card

[![CI](https://github.com/Ayushd70/swipe_reveal_card/actions/workflows/ci.yml/badge.svg)](https://github.com/Ayushd70/swipe_reveal_card/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/swipe_reveal_card.svg)](https://pub.dev/packages/swipe_reveal_card)

A lightweight Flutter card with **horizontal swipe-to-reveal actions**.

Swipe left on a card to uncover Edit / Archive / Delete-style actions — with a
small, typed API and no heavy gesture controllers.

![Demo](https://raw.githubusercontent.com/Ayushd70/swipe_reveal_card/main/doc/demo.gif)

## Features

- Swipe left to reveal one or more actions
- Optional icons and custom action colors
- Material ink ripples on card and action taps
- Soft elevation with zero-margin “flush” mode
- Scroll position restored via `PageStorageKey`
- Zero third-party dependencies beyond Flutter

## Install

```yaml
dependencies:
  swipe_reveal_card: ^0.1.2
```

```dart
import 'package:swipe_reveal_card/swipe_reveal_card.dart';
```

## Usage

```dart
SwipeRevealCard(
  storageKey: 'task-1',
  onTap: () => debugPrint('opened'),
  actions: [
    SwipeAction(
      label: 'Edit',
      icon: Icons.edit_outlined,
      onPressed: () {},
    ),
    SwipeAction(
      label: 'Delete',
      icon: Icons.delete_outline,
      color: Colors.red,
      onPressed: () {},
    ),
  ],
  child: const ListTile(
    title: Text('Ship checklist'),
    subtitle: Text('Docs, tests, and pub.dev dry-run'),
  ),
)
```

### Plain card (no swipe)

Omit `actions` (or pass `null`) for a simple elevated card:

```dart
SwipeRevealCard(
  onTap: () {},
  child: const ListTile(title: Text('Hello')),
)
```

### Customization

| Parameter | Description |
| --- | --- |
| `actions` | List of `SwipeAction`s revealed on swipe |
| `backgroundColor` | Card body color (default white) |
| `actionsBackgroundColor` | Color behind action buttons |
| `borderRadius` | Corner radius (default `10`) |
| `margin` | Outer margin; `EdgeInsets.zero` disables shadow |
| `elevation` | Shadow depth when margin is non-zero |
| `storageKey` | Restores horizontal scroll offset |
| `onTap` | Card body tap callback |

## Screenshots

| Resting | Actions revealed |
| --- | --- |
| ![Resting](https://raw.githubusercontent.com/Ayushd70/swipe_reveal_card/main/doc/screenshots/resting.png) | ![Revealed](https://raw.githubusercontent.com/Ayushd70/swipe_reveal_card/main/doc/screenshots/revealed.png) |

## Testing

Unit tests live under `test/`. Behavior is also specified with Gherkin
(`.feature`) files under `test/bdd/` using
[`bdd_widget_test`](https://pub.dev/packages/bdd_widget_test).

```bash
# After editing .feature files, regenerate and commit the Dart tests
dart run build_runner build
dart format .

# Run all tests (unit + BDD)
flutter test
```

Generated BDD tests under `test/bdd/` are committed — CI does not regenerate them.

## Example

```bash
cd example
flutter run
```

## Compared to flutter_slidable

`swipe_reveal_card` is intentionally smaller: horizontal scroll-to-reveal
actions on a card surface. If you need dismissible panes, start/end action
regions, or custom motion types, prefer
[`flutter_slidable`](https://pub.dev/packages/flutter_slidable).

## License

MIT
