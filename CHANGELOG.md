## 0.2.1

* Add `actionsExtentRatio` to clamp the actions pane width relative to the card.
* Expose each action with button `Semantics` using `SwipeAction.label` (including
  custom `child` actions).
* Apply `PageStorageKey` only when `storageKey` is set, so cards without a key
  no longer share an empty storage bucket.

## 0.2.0

* Add `SwipeRevealController` for programmatic open / close / toggle.
* Add `SwipeRevealGroup` so only one card is open at a time in a list.
* Add `closeOnAction`, `closeOnCardTap`, `enabled`, `onOpen`, and `onClose`.
* Allow custom action content via `SwipeAction.child`.

## 0.1.2

* Add BDD widget tests with Gherkin feature files (`bdd_widget_test`).

## 0.1.1

* Use absolute GitHub image URLs in the README so the demo GIF and screenshots
  render correctly on pub.dev.

## 0.1.0

* Initial release of `swipe_reveal_card`.
* `SwipeRevealCard` with optional horizontal swipe-to-reveal actions.
* `SwipeAction` model with label, optional icon/color, and typed callback.
* Example app, widget tests, and documentation assets.
