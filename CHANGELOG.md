# ChangeLog

## 0.1.0

### Features

* **`SmartAutoSuggestBoxDataSource`**: New data source abstraction that replaces the `items` and `onNoResultsFound` parameters with a cleaner, unified API.
  * `initialList`: Synchronous callback to provide initial items with access to `BuildContext`.
  * `onSearch`: Async search callback that receives `(context, currentItems, searchText)`.
  * `searchMode`: Controls when `onSearch` is invoked — `onNoLocalResults` (default) or `always`.
  * `debounce`: Configurable debounce duration (default: 400ms).
* **`SmartAutoSuggestBoxSearchMode`**: New enum to control search behavior:
  * `onNoLocalResults`: Only calls `onSearch` when local filtering yields no results.
  * `always`: Calls `onSearch` on every text change after debounce.

### Deprecations

* `items` constructor parameter — use `dataSource` with `initialList` instead.
* `onNoResultsFound` — use `dataSource` with `onSearch` instead.

### Example

* Updated example app with 4 demos: `initialList`, `onSearch`, `searchMode.always`, and deprecated `items` backward compatibility.

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
