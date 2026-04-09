# ChangeLog

## 0.15.0

### Breaking Changes

* **`SmartAutoSuggestItem.builder` removed** — replaced by four focused
  builders that each provide a specific part of the tile:

  | New field | Renders |
  |---|---|
  | `titleBuilder` | Title (replaces deprecated `child`) |
  | `subtitleBuilder` | Subtitle (falls back to static `subtitle`) |
  | `trailingBuilder` | Trailing widget |
  | `leadingBuilder` | Leading widget |

  Each builder has the signature:
  ```dart
  Widget? Function(BuildContext context, String? searchText, bool isFocused)?
  ```
  `searchText` is the current query (can be used for highlighting) and
  `isFocused` indicates keyboard focus so the widget can adapt its style.

* **`SmartAutoSuggestItemBuilder<T>` typedef updated** — two extra positional
  parameters added (`String? searchText`, `bool isFocused`):
  ```dart
  typedef SmartAutoSuggestItemBuilder<T> =
      Widget Function(
        BuildContext context,
        SmartAutoSuggestItem<T> item,
        String? searchText,
        bool isFocused,
      );
  ```
  Callers of `itemBuilder` on `SmartAutoSuggestBox`, `SmartAutoSuggestView`,
  and `SmartAutoSuggestMultiSelectBox` must be updated to accept the two new
  parameters.

* **`SmartAutoSuggestBoxOverlayTile`** — new optional `leading` field added so
  that `leadingBuilder` output is rendered inside the tile.

### Deprecations

* **`SmartAutoSuggestItem.child`** — deprecated in favour of `titleBuilder`.

## 0.14.0

### Internal Refactor

* **Unified state management via `SmartAutoSuggestEngine<T>`** — introduced a
  single internal `ChangeNotifier` that owns filtering, async search
  scheduling, keyboard-navigation focus, and listener wiring. The three
  widgets (`SmartAutoSuggestBox`, `SmartAutoSuggestMultiSelectBox`, and
  `SmartAutoSuggestView`) now delegate to the engine instead of each
  re-implementing the same logic, eliminating duplicated text-change
  handlers, focus streams, and dataSource listener plumbing. Net change:
  ~308 fewer lines of duplicated code.

* **`ValueNotifier`-based focus highlight** — keyboard-focused tile highlight
  is now driven by `engine.focusedIndex` (a `ValueNotifier<int>`) rendered
  via `ValueListenableBuilder`, so only the two affected tiles rebuild on
  focus changes instead of the whole overlay.

* **Sorter is passed explicitly to `filter()`** — `SmartAutoSuggestDataSource`
  no longer exposes `activeSorter` as a mutable field. The sorter is now
  passed per-call to `filter()`, with the most recent one cached internally
  so `search()` can re-filter after merging new results. Widgets no longer
  assign `activeSorter` from `initState`/`didUpdateWidget`.

### Deprecations

* **`SmartAutoSuggestItem.selected` setter** — highlight state is now managed
  by `SmartAutoSuggestEngine.focusedIndex`. The setter is kept as a
  backward-compatibility shim that still fires `onFocusChange`, but
  rendering no longer relies on it. External code that reads
  `item.selected` continues to observe the expected value.

### Bug Fixes

* **Fixed double rebuilds on every filter change** — overlay sub-widgets and
  their outer `State` classes previously both added listeners to
  `dataSource.filteredItems`, `isLoading`, and `errorMessage`, causing two
  rebuilds per event. The overlay now subscribes only to
  `engine.focusedIndex`, and the outer widget rebuilds the overlay via
  `markNeedsBuild()` once per engine notification.

### Notes

* All public APIs and existing tests are preserved — this release is a
  drop-in upgrade. Internal code using `dataSource.activeSorter` (not part
  of the public API) will need to pass the sorter to `filter()` explicitly.

## 0.13.5

### Bug Fixes

* **Fixed overlay flickering in deep navigation routes** — when a `LayoutBuilder`
  is used in ancestor widgets (a common pattern in nested screens), any parent
  rebuild could cause constraint micro-changes that were incorrectly interpreted
  as a resize. The overlay was torn down and recreated on every such change,
  producing a visible flicker. The comparison is now tolerance-based (> 1 px),
  and a width change only triggers `markNeedsBuild()` on the existing overlay
  entry instead of a full remove-and-recreate cycle. Applies to
  `SmartAutoSuggestBox` and `SmartAutoSuggestMultiSelectBox`.

* **Fixed keyboard focus highlight not visible on individual items** — the
  `selected` condition in the overlay tile incorrectly included
  `widget.node.hasFocus` (the overlay's `FocusScopeNode`). When the scope had
  focus every tile appeared selected simultaneously, making per-item keyboard
  highlight indistinguishable. The flag has been removed so only the truly
  focused item (`item.selected`) shows the highlight color. Applies to
  `SmartAutoSuggestBox` overlay and `SmartAutoSuggestView` inline list.

### Improvements

* **Arrow keys open the overlay when it is closed** — pressing ↑ or ↓ while
  the text field has focus now opens the suggestion overlay if it is not already
  visible, consistent with standard combobox UX. Applies to `SmartAutoSuggestBox`
  and `SmartAutoSuggestMultiSelectBox`.

### Example

* **Migrated example app to `go_router_builder`** — all 13 use-case screens are
  now registered as typed `GoRouteData` subclasses with `@TypedGoRoute`
  annotations. Navigation uses generated `.push(context)` extension methods
  instead of raw `Navigator.push`. Run
  `dart run build_runner build --delete-conflicting-outputs` inside `example/`
  to regenerate `app_router.g.dart` after adding new routes.

## 0.13.1

### Bug Fixes

* **Fixed async search side-effects during build** — triggering `onSearch`
  when no local results were found is now scheduled after the current frame
  instead of being invoked from inside widget `build()`. This fixes
  `setState() or markNeedsBuild() called during build` in
  `SmartAutoSuggestBox`, `SmartAutoSuggestView`, and
  `SmartAutoSuggestMultiSelectBox`.

* **Fixed auto-scroll on unattached `ScrollController`** — keyboard focus
  scrolling now waits until the list is attached before calling `animateTo`,
  preventing `ScrollController not attached to any scroll views`.

## 0.13.0

### New Features

* **Error state in overlay** — when `onSearch` throws an exception, the overlay
  now displays a localized error message with an error icon instead of silently
  swallowing the error. The error is automatically cleared when a new search
  starts.

* **`errorMessage` on `SmartAutoSuggestDataSource`** — new `ValueNotifier<String?>`
  that holds the error message from the last failed search. Listen to it to
  observe error state externally.

* **`errorSubtitleStyle` and `errorIconColor` on `SmartAutoSuggestTheme`** —
  new theme properties for customizing the error card appearance.

* **`searchError` / `searchErrorHint` localizations** — new localized strings
  for the error state across all 13 supported languages.

## 0.12.0

### Bug Fixes

* **Fixed double `onFocusChange` callback** — `item.selected` setter already
  calls `onFocusChange`, but the code was also calling it explicitly, resulting
  in duplicate callbacks. Removed the redundant calls across all three widgets.

* **Fixed stale selection on items leaving `filteredItems`** —
  `_unselectAll()` now iterates `dataSource.items` (all items) instead of only
  `filteredItems`, so items that move out of the filtered set have their
  `selected` flag properly cleared.

### Improvements

* **Auto-focus first item on data change** — when `filteredItems` updates
  (e.g. async search completes), the first item is now automatically focused
  on desktop, so the user can immediately navigate with arrow keys.

* **`_autoSelectFirstItem` added to `SmartAutoSuggestView`** — the inline
  list widget now auto-selects the first item on desktop platforms, matching
  the behavior of `SmartAutoSuggestBox` and `SmartAutoSuggestMultiSelectBox`.

* **`_selectItem()` extracted from `build()`** — the item selection logic is
  now a proper state method instead of a closure recreated on every build, in
  all three widgets.

* **`isDesktopPlatform` helper** — new top-level getter in the common library
  replaces repeated `switch (defaultTargetPlatform)` blocks across widgets.

## 0.11.0

### Breaking Changes

* **`SmartAutoSuggestDataSource` is now stateful** — the constructor is no longer
  `const`. If you stored a `const SmartAutoSuggestDataSource(...)`, remove the
  `const` keyword. All existing usage patterns (inline construction in `build`)
  continue to work without changes thanks to the new `hasSameConfig()` check.

### Features

* **Stateful `SmartAutoSuggestDataSource`** — the data source now owns and
  manages overlay state internally:
  * `items` (`ValueNotifier<Set<SmartAutoSuggestItem<T>>>`) — all available
    items (unfiltered).
  * `filteredItems` (`ValueNotifier<Set<SmartAutoSuggestItem<T>>>`) — the
    currently filtered/sorted items shown in the overlay.
  * `isLoading` (`ValueNotifier<bool>`) — whether an async search is in
    progress.

* **External control** — you can now observe and manipulate the data source
  from outside the widget:
  * `filter(searchText, [sorter])` — apply sorter and update `filteredItems`.
  * `search(context, searchText)` — trigger an async search programmatically.
  * `setItems(newItems, searchText)` — replace all items and re-filter.
  * `addItems(newItems, searchText)` — merge new items and re-filter.
  * `resetSearchState()` — reset the last query so the same search can run
    again.
  * Listen to `dataSource.filteredItems` and `dataSource.isLoading` for
    real-time state updates.

* **Immediate overlay updates** — the overlay now listens directly to
  `dataSource.filteredItems` and `dataSource.isLoading`, so tiles update
  instantly when an async search completes (no manual refresh needed).

* **`hasSameConfig()`** — prevents unnecessary re-initialization when the
  `SmartAutoSuggestDataSource` is recreated inline in `build` methods with
  the same callbacks and settings.

### Internal

* Removed internal `StreamController` for items in all three widgets
  (`SmartAutoSuggestBox`, `SmartAutoSuggestView`,
  `SmartAutoSuggestMultiSelectBox`).
* Overlay build methods simplified from nested `ValueListenableBuilder` to
  direct `DataSource` reads.

## 0.10.1

### Features

* **Desktop keyboard auto-focus** — on desktop platforms (Windows, macOS, Linux)
  the first item in the floating overlay is now automatically focused when the
  dropdown opens, so the user can immediately navigate with arrow keys and
  confirm with Enter without needing to press ↓ first.
* **Enter key support in `SmartAutoSuggestBox`** — pressing Enter now selects
  the currently focused item (was already supported in
  `SmartAutoSuggestMultiSelectBox` and `SmartAutoSuggestView`).
* **Focus follows filter** — when the user types and the suggestion list
  updates, focus automatically resets to the first matching item on desktop.

### Example

* Added dedicated **Multi-Select** demo screen with 6 examples: basic usage,
  max selections, custom `maxVisibleChips`, custom `chipBuilder`, controller
  demo, and async search. Accessible via a new "Multi-Select" tab in the bottom
  navigation bar.

## 0.10.0

### Features

* **`SmartAutoSuggestMultiSelectBox`** — new multi-select widget that allows
  selecting multiple items from a floating suggestion overlay.
  * Selected items are shown as compact chips below the text field.
  * Configurable `maxVisibleChips` (default 3) — excess items are accessible
    via a "Show all" button that opens a `BottomSheet`.
  * Each chip has a cancel button to deselect the item.
  * Optional `maxSelections` — when the limit is reached, remaining unselected
    items are disabled in the overlay.
  * Tapping a selected item in the overlay toggles it off (deselects).
  * Custom `chipBuilder` for full control over chip appearance.

* **`SmartAutoSuggestMultiSelectController`** — new controller that provides
  access to both the text input (`textController`) and the set of currently
  selected items (`selectedItems` `ValueNotifier`). Supports `select`,
  `deselect`, `toggleSelection`, `clearAll`, and `isSelected`.

* **`SmartAutoSuggestBoxOverlayTile.trailing`** — new optional widget
  displayed at the end of overlay tiles (used internally for check marks in
  multi-select mode).

### Example

* Added **"Multi-Select (Basic)"** and **"Multi-Select (Max 5)"** demo
  sections in Advanced Examples.

## 0.7.3

### Bug Fixes

* **Keep focus when interacting with overlay** — the floating suggestion
  list is now treated as part of the text field using `TextFieldTapRegion`,
  so tapping overlay items no longer causes the text field to lose focus.
  Focus is only removed when tapping truly outside both the text field and
  the overlay.

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
