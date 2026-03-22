# ChangeLog

## 0.0.2

### Features

* **Smart dropdown positioning**: The dropdown now supports 4 directions: `top`, `bottom`, `start`, and `end`.
* **Auto-fallback positioning**: When there isn't enough space in the preferred direction, the dropdown automatically repositions to the opposite direction.
* **RTL support**: `start` and `end` directions respect the text directionality (`ltr`/`rtl`).

### Breaking Changes

* `SmartAutoSuggestBoxDirection.below` is now deprecated.
* Use `SmartAutoSuggestBoxDirection.bottom` instead.
* `SmartAutoSuggestBoxDirection.above` is now deprecated.
* Use `SmartAutoSuggestBoxDirection.top` instead.

### Example

* Updated example app to demonstrate all 4 dropdown directions with interactive direction switching.

## 0.0.1

* Initial release of `smart_auto_suggest_box`.
