# ChangeLog

## 0.7.2

### Features

* **Show all items on focus** — when the input field is focused with empty
  content, all available items are now displayed in the suggestion list.
* **Cursor-based search text** — the search query is now calculated from the
  start of the text to the cursor position, not the entire text. For example,
  if the text is "الحساب الجديد" and the cursor is after "الحساب", only
  "الحساب" is used as the search query.

## 0.7.1

### Bug Fixes

* **Dismiss overlay on selection** — the floating suggestion overlay now
  correctly closes when the user selects an item.
* **Dismiss overlay on tap outside** — tapping outside the overlay or the
  text field now dismisses the floating suggestion list and unfocuses the
  input.
* **Builder items selectable** — items using `SmartAutoSuggestItem.builder`
  are now tappable to trigger selection (both in `SmartAutoSuggestBox` and
  `SmartAutoSuggestView`).

## 0.7.0

### Features

* **`SmartAutoSuggestHighlightText`** — new widget that highlights the matching
  portion of suggestion labels in bold with the theme's primary color.
  Automatically used in default tiles when no custom builder is provided.
* **`SmartAutoSuggestItem.key`** — optional unique key for item identity.
  When provided, equality and hashing use `key` instead of `value`.
* **`SmartAutoSuggestItem.builder`** — new builder callback
  `Widget Function(BuildContext context, String searchText)?` that replaces
  the deprecated `child`. The returned widget is automatically wrapped in a
  `Focus` widget for keyboard navigation support. The `searchText` parameter
  enables custom highlight rendering.

### Deprecations

* `SmartAutoSuggestItem.child` is deprecated — use `builder` instead.

### Example

* Added **"Highlight + Item Builder"** demo section showing highlighted text
  and the `builder` API with `Focus` wrapping.

## 0.6.0

### Features

* **`SmartAutoSuggestController<T>`** — new unified controller that wraps:
  * `textController` (`TextEditingController`) — for text input
  * `selectedItem` (`ValueNotifier<SmartAutoSuggestItem<T>?>`) — for observing
    the currently selected item
  * `select(item)` — sets the selected item and updates the text field
  * `clearSelection()` — clears both selection and text
  * `dispose()` — releases resources

* Both `SmartAutoSuggestBox` and `SmartAutoSuggestView` accept an optional
  `smartController` parameter.

### Deprecations

* `controller` (`TextEditingController?`) parameter is deprecated on both
  widgets — use `smartController` instead.

### Example

* Added **"SmartAutoSuggestController"** demo section showing how to observe
  selection state and clear it programmatically.

## 0.5.0

### Features

* **`selectedItemBuilder`** — new optional callback on `SmartAutoSuggestBox`
  that displays a custom widget (e.g. a `Chip`, card, or avatar row) after the
  user selects an item, replacing the `TextField`.
  * Tapping the custom widget dismisses it and restores the `TextField` for a
    new search.
  * Use `SmartAutoSuggestBoxState.clearSelection()` to clear it
    programmatically.
  * When `null` (the default), the classic behavior is preserved — the selected
    item's label is placed into the `TextField` as plain text.

### Example

* Added **"Selected Item Builder"** demo section in the Box demo tab showing a
  `Chip` widget after selection.

## 0.4.0

### Features

* **`SmartAutoSuggestTheme`** — new `ThemeExtension` for customizing the
  appearance of both `SmartAutoSuggestBox` and `SmartAutoSuggestView`.
  * Provides granular control over overlay colors, shadows, border radius,
    tile colors, text styles, progress indicator, divider indent, and more.
  * Factory constructors `SmartAutoSuggestTheme.light()` and
    `SmartAutoSuggestTheme.dark()` with sensible defaults.
  * Can be supplied via `ThemeData.extensions` or passed directly to a widget.
* Both `SmartAutoSuggestBox` and `SmartAutoSuggestView` now accept an optional
  `SmartAutoSuggestTheme? theme` parameter to override the theme locally.

### Example

* Split example app into multiple files: `main.dart`, `data.dart`,
  `box_demo.dart`, `view_demo.dart`, `advanced_examples.dart`.
* Example now registers `SmartAutoSuggestTheme.light()` and
  `SmartAutoSuggestTheme.dark()` via `ThemeData.extensions`.

## 0.3.0

### Breaking Changes

* **`SmartAutoSuggestDataSource` API overhaul** — the data source now works with
  raw values (`T`) instead of `SmartAutoSuggestItem<T>`:

  | Property | Old type | New type |
  |----------|----------|----------|
  | `initialList` | `List<SmartAutoSuggestItem<T>> Function(BuildContext)?` | `List<T> Function(BuildContext)?` |
  | `onSearch` | `Future<List<SmartAutoSuggestItem<T>>> Function(BuildContext, List<SmartAutoSuggestItem<T>>, String?)?` | `Future<List<T>> Function(BuildContext, List<T>, String?)?` |

* **New required `itemBuilder`** — `SmartAutoSuggestDataSource` now requires an
  `itemBuilder` callback that converts each raw value `T` into a
  `SmartAutoSuggestItem<T>`:

  ```dart
  SmartAutoSuggestDataSource<String>(
    itemBuilder: (context, value) => SmartAutoSuggestItem(
      value: value,
      label: value[0].toUpperCase() + value.substring(1),
    ),
    initialList: (context) => ['apple', 'banana'],
  )
  ```

### Example

* Updated all example code to use the new `itemBuilder` API.

## 0.2.1

### Fixes

* **Keyboard-aware overlay sizing** (`SmartAutoSuggestBox`):
  popup placement/height now accounts for keyboard insets
  (`MediaQuery.viewInsets.bottom`) instead of relying on safe padding only.
* **Direction priority + best-space fallback**:
  the preferred direction is tried first; if it cannot fit the popup target
  size, the overlay falls back to the direction with the largest available
  space.
* **Auto-scroll for constrained layouts**:
  when all directions are constrained, the nearest scrollable parent is
  auto-scrolled to improve available space, then the overlay is recomputed.
* **Overlay reacts to keyboard metric changes**:
  overlay now rebuilds when keyboard opens/closes to keep placement accurate.
* Added/updated widget tests covering keyboard-aware placement, fallback
  behavior, and auto-scroll behavior.

## 0.2.0

### Features

* **`SmartAutoSuggestView`**: New inline widget that shows a `TextField` with a
  suggestion list rendered directly below it in the normal widget tree — no
  floating overlay. Ideal for search screens, filter panels, and embedded search
  UIs. Shares the same `SmartAutoSuggestDataSource` API as `SmartAutoSuggestBox`.
* **Scrollbar**: Both `SmartAutoSuggestBox` and `SmartAutoSuggestView` now show a
  visible scrollbar thumb when the suggestion list overflows.
  * `listMaxHeight`: maximum height of the inline suggestion list (default 380px).
  * `showListWhenEmpty`: whether to display the list when the text field is empty (default `true`).
  * Supports `.form` constructor with `validator` and `autovalidateMode`.
  * Full keyboard navigation (↑ ↓ Enter).

* **Shared-type rename** — types that are shared between `SmartAutoSuggestBox`
  and `SmartAutoSuggestView` have been renamed to drop the `Box` infix:

  | Old name | New name |
  |---|---|
  | `SmartAutoSuggestBoxItem` | `SmartAutoSuggestItem` |
  | `SmartAutoSuggestBoxDataSource` | `SmartAutoSuggestDataSource` |
  | `SmartAutoSuggestBoxSearchMode` | `SmartAutoSuggestSearchMode` |
  | `SmartAutoSuggestBoxSorter` | `SmartAutoSuggestSorter` |
  | `SmartAutoSuggestBoxItemBuilder` | `SmartAutoSuggestItemBuilder` |

### Deprecations

* All five old names above are kept as deprecated `typedef` aliases for full
  backward compatibility — no code changes required to migrate.

### Example

* Updated example app with a bottom `NavigationBar` switching between
  `SmartAutoSuggestBox` (floating overlay), `SmartAutoSuggestView` (inline list),
  and Advanced Examples demos.
* Updated all example code to use the new type names.
* **BottomSheet example**: `SmartAutoSuggestView` inside a `showModalBottomSheet`.
* **Custom no-results**: Rich custom widget with icon, message, and action button.
* **Custom item builder**: Tiles with leading emoji avatar, subtitle, and trailing badge.
* **Custom loading**: Shimmer-style placeholder while server search is in progress.

## 0.1.0

### Features

* **`SmartAutoSuggestDataSource`** (was `SmartAutoSuggestBoxDataSource`): New data source abstraction.
  * `initialList`: Synchronous callback to provide initial items with access to `BuildContext`.
  * `onSearch`: Async search callback that receives `(context, currentItems, searchText)`.
  * `searchMode`: Controls when `onSearch` is invoked — `onNoLocalResults` (default) or `always`.
  * `debounce`: Configurable debounce duration (default: 400ms).
* **`SmartAutoSuggestSearchMode`** (was `SmartAutoSuggestBoxSearchMode`): Enum to control search behavior.

### Deprecations

* `items` constructor parameter — use `dataSource` with `initialList` instead.
* `onNoResultsFound` — use `dataSource` with `onSearch` instead.

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
