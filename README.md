# Smart Auto Suggest Box

A highly customizable auto-suggest (autocomplete) Flutter package offering three widgets:

- **`SmartAutoSuggestBox`** — floating overlay dropdown (single select)
- **`SmartAutoSuggestView`** — inline suggestion list embedded in the widget tree (single select)
- **`SmartAutoSuggestMultiSelectBox`** — floating overlay with multi-item selection and chips

All share the same `SmartAutoSuggestDataSource` API and item model.

[![pub package](https://img.shields.io/pub/v/smart_auto_suggest_box.svg)](https://pub.dev/packages/smart_auto_suggest_box)

## Features

- **Three display modes** — floating overlay (`SmartAutoSuggestBox`), inline list (`SmartAutoSuggestView`), or multi-select (`SmartAutoSuggestMultiSelectBox`)
- **Unified state engine** — all three widgets share a single internal `SmartAutoSuggestEngine<T>` that owns filtering, async search scheduling, keyboard focus, and listener wiring — so every widget behaves consistently and rebuilds minimally
- **Multi-select** — chip-based selection area, configurable max visible chips, "Show all" BottomSheet, max selections limit
- **Unified data source** — `SmartAutoSuggestDataSource` with sync `initialList` and async `onSearch`
- **Smart overlay positioning** — auto-repositions to the opposite side if insufficient space (`SmartAutoSuggestBox` only)
- **4-direction support** — `top`, `bottom`, `start`, `end` with RTL awareness
- **Search modes** — `onNoLocalResults` (default) or `always` (every keystroke)
- **Configurable debounce** — control search trigger timing
- **Keyboard navigation** — ↑ ↓ Enter Escape, auto-focus first item on desktop
- **Form support** — `SmartAutoSuggestBox.form()` and `SmartAutoSuggestView.form()` with validation
- **Scrollbar** — visible scrollbar thumb when the suggestion list overflows
- **Custom builders** — item, no-results, loading state, **selected item display**
- **Theming** — `SmartAutoSuggestTheme` (`ThemeExtension`) with light/dark defaults
- **BottomSheet ready** — `SmartAutoSuggestView` works inside `showModalBottomSheet`
- **Internationalization** — built-in i18n

## Getting Started

```yaml
dependencies:
  smart_auto_suggest_box: ^0.14.0

# localization (optional, but recommended)
  flutter_localizations:
    sdk: flutter
```

```bash
flutter pub get
```

## Localization setup

To enable localizations, add the following to your `MaterialApp`:

```dart
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // for GlobalMaterialLocalizations

/*
... other MaterialApp properties
*/

localizationsDelegates: const [
  SmartAutoSuggestBoxLocalizations.delegate,
  // ...app's other delegates (e.g. GlobalMaterialLocalizations.delegate)
],
supportedLocales:[
  // Add your app's supported locales here,like:
  const Locale('ar'), // Arabic
  const Locale('fa'), // Persian
  const Locale('en'), // English
  // ...other locales
],
```

## Usage

### SmartAutoSuggestBox (floating overlay)

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (context, value) => SmartAutoSuggestItem(
      value: value,
      label: value[0].toUpperCase() + value.substring(1),
    ),
    initialList: (context) => ['apple', 'banana'],
  ),
  decoration: const InputDecoration(
    labelText: 'Search fruits',
    border: OutlineInputBorder(),
  ),
  onSelected: (item) => print(item?.label),
);
```

### SmartAutoSuggestView (inline list)

```dart
SmartAutoSuggestView<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (context, value) => SmartAutoSuggestItem(
      value: value,
      label: value[0].toUpperCase() + value.substring(1),
    ),
    initialList: (context) => ['apple', 'banana'],
  ),
  showListWhenEmpty: true,   // show list even when text field is empty
  listMaxHeight: 300,
  decoration: const InputDecoration(
    labelText: 'Search',
    border: OutlineInputBorder(),
  ),
  onSelected: (item) => print(item?.label),
);
```

### Async Server Search

```dart
SmartAutoSuggestBox<String>(   // or SmartAutoSuggestView
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (context, value) => SmartAutoSuggestItem(
      value: value,
      label: value,
    ),
    initialList: (context) => [],
    onSearch: (context, currentItems, searchText) async {
      return await api.search(searchText);
    },
    debounce: const Duration(milliseconds: 500),
  ),
  onSelected: (item) {},
);
```

### searchMode.always

Call `onSearch` on every keystroke (after debounce):

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (context, value) => SmartAutoSuggestItem(
      value: value,
      label: value,
    ),
    initialList: (context) => localItems,
    onSearch: (context, current, searchText) async {
      return await api.search(searchText);
    },
    searchMode: SmartAutoSuggestSearchMode.always,
    debounce: const Duration(milliseconds: 600),
  ),
  onSelected: (item) {},
);
```

### Dropdown Direction (SmartAutoSuggestBox only)

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (c, v) => SmartAutoSuggestItem(value: v, label: v),
    initialList: (c) => items,
  ),
  direction: SmartAutoSuggestBoxDirection.top,   // falls back if no space
  onSelected: (item) {},
);
```

| Direction | Description |
|-----------|-------------|
| `bottom`  | Below the text field. Falls back to `top`. |
| `top`     | Above the text field. Falls back to `bottom`. |
| `start`   | Start side (left in LTR). Falls back to `end`. |
| `end`     | End side (right in LTR). Falls back to `start`. |

### SmartAutoSuggestView in BottomSheet

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (context) => DraggableScrollableSheet(
    expand: false,
    builder: (context, scrollController) => Column(
      children: [
        // ... drag handle, title ...
        Expanded(
          child: SmartAutoSuggestView<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: (context, value) => SmartAutoSuggestItem(
                value: value,
                label: value,
              ),
              initialList: (context) => myItems,
            ),
            showListWhenEmpty: true,
            listMaxHeight: double.infinity,
            onSelected: (item) => Navigator.pop(context),
          ),
        ),
      ],
    ),
  ),
);
```

### Custom No-Results View

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (c, v) => SmartAutoSuggestItem(value: v, label: v),
    initialList: (c) => items,
  ),
  noResultsFoundBuilder: (context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.search_off, size: 40),
        const Text('No matching results'),
        OutlinedButton.icon(
          onPressed: () { /* add new item */ },
          icon: const Icon(Icons.add),
          label: const Text('Add new'),
        ),
      ],
    );
  },
  onSelected: (item) {},
);
```

### Custom Item Builder

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (c, v) => SmartAutoSuggestItem(value: v, label: v),
    initialList: (c) => items,
  ),
  tileHeight: 72,
  itemBuilder: (context, item) {
    return ListTile(
      leading: CircleAvatar(child: Text(item.label[0])),
      title: Text(item.label),
      subtitle: Text('Value: ${item.value}'),
      trailing: Chip(label: Text('${item.label.length}')),
    );
  },
  onSelected: (item) {},
);
```

### Form Validation

```dart
SmartAutoSuggestView.form(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (c, v) => SmartAutoSuggestItem(value: v, label: v),
    initialList: (c) => items,
  ),
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onSelected: (item) {},
);
```

## Highlight Matching Text

By default, suggestion labels highlight the matching portion in bold with the
theme's primary color using `SmartAutoSuggestHighlightText`. You can also use
it directly:

```dart
SmartAutoSuggestHighlightText(
  text: 'Apple Pie',
  query: 'app',
  // optional: baseStyle, matchStyle
)
```

## Item Builder with Focus

Use `SmartAutoSuggestItem.builder` instead of the deprecated `child` to build
custom item widgets. The builder receives the current `searchText` for
highlighting, and the widget is automatically wrapped in `Focus` for keyboard
navigation:

```dart
SmartAutoSuggestItem(
  key: 'apple',
  value: 'apple',
  label: 'Apple',
  builder: (context, searchText) {
    return ListTile(
      title: SmartAutoSuggestHighlightText(
        text: 'Apple',
        query: searchText,
      ),
    );
  },
)
```

## SmartAutoSuggestController

Use `SmartAutoSuggestController<T>` to access the text input and observe the
selected item from outside the widget:

```dart
final controller = SmartAutoSuggestController<String>();

// Pass to widget
SmartAutoSuggestBox<String>(
  smartController: controller,
  dataSource: SmartAutoSuggestDataSource(...),
)

// Listen to selection changes
controller.selectedItem.addListener(() {
  print('Selected: ${controller.selectedItem.value?.label}');
});

// Clear programmatically
controller.clearSelection();

// Don't forget to dispose
controller.dispose();
```

> **Note:** The old `controller: TextEditingController?` parameter is
> deprecated — use `smartController` instead.

## Selected Item Display

By default, the selected item's label is placed into the `TextField` as text.
Use `selectedItemBuilder` to show a custom widget instead:

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: fruitItemBuilder,
    initialList: (context) => fruits,
  ),
  selectedItemBuilder: (context, item) {
    return InputDecorator(
      decoration: const InputDecoration(border: OutlineInputBorder()),
      child: Chip(
        label: Text(item.label),
        onDeleted: () {}, // tap anywhere to dismiss
      ),
    );
  },
)
```

Tapping the custom widget clears the selection and restores the `TextField`.
To clear programmatically, use `SmartAutoSuggestBoxState.clearSelection()`.

## SmartAutoSuggestMultiSelectBox

Select multiple items from a floating overlay. Selected items appear as chips
below the text field.

### Basic Multi-Select

```dart
SmartAutoSuggestMultiSelectBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (context, value) => SmartAutoSuggestItem(
      value: value,
      label: value[0].toUpperCase() + value.substring(1),
    ),
    initialList: (context) => ['apple', 'banana', 'cherry', 'date'],
  ),
  decoration: const InputDecoration(
    labelText: 'Select fruits',
    border: OutlineInputBorder(),
  ),
  onSelectionChanged: (selected) {
    print('Selected: ${selected.map((e) => e.label).join(', ')}');
  },
);
```

### With Max Selections

Limit the number of selectable items. Unselected items are disabled once the
limit is reached. Tap a selected item in the overlay to deselect it.

```dart
SmartAutoSuggestMultiSelectBox<String>(
  dataSource: SmartAutoSuggestDataSource(
    itemBuilder: (context, value) => SmartAutoSuggestItem(
      value: value,
      label: value,
    ),
    initialList: (context) => items,
  ),
  maxSelections: 5,
  maxVisibleChips: 2,  // show 2 chips, then "Show all" button
  onSelectionChanged: (selected) {},
);
```

### Multi-Select Controller

Use `SmartAutoSuggestMultiSelectController<T>` to observe and manipulate
selections from outside the widget:

```dart
final controller = SmartAutoSuggestMultiSelectController<String>();

// Pass to widget
SmartAutoSuggestMultiSelectBox<String>(
  smartController: controller,
  dataSource: SmartAutoSuggestDataSource(...),
)

// Listen to selection changes
controller.selectedItems.addListener(() {
  print('Count: ${controller.selectedItems.value.length}');
});

// Programmatic control
controller.select(item);
controller.deselect(item);
controller.toggleSelection(item);
controller.clearAll();

// Don't forget to dispose
controller.dispose();
```

### Multi-Select Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `dataSource` | `SmartAutoSuggestDataSource<T>` | **required** | Data source for items |
| `smartController` | `SmartAutoSuggestMultiSelectController<T>?` | `null` | External controller |
| `maxVisibleChips` | `int` | `3` | Max chips shown before "Show all" button |
| `maxSelections` | `int?` | `null` | Max selectable items (`null` = unlimited) |
| `chipBuilder` | `Widget Function(BuildContext, item, onRemove)?` | `null` | Custom chip widget |
| `onSelectionChanged` | `ValueChanged<Set<SmartAutoSuggestItem<T>>>?` | `null` | Selection change callback |

## Theming

Use `SmartAutoSuggestTheme` (a `ThemeExtension`) to customise colours, shadows,
border radii, text styles, and more.

### Via ThemeData (recommended)

```dart
MaterialApp(
  theme: ThemeData.light().copyWith(
    extensions: [SmartAutoSuggestTheme.light()],
  ),
  darkTheme: ThemeData.dark().copyWith(
    extensions: [SmartAutoSuggestTheme.dark()],
  ),
)
```

### Per-widget override

```dart
SmartAutoSuggestBox<String>(
  theme: SmartAutoSuggestTheme.light().copyWith(
    overlayBorderRadius: BorderRadius.circular(12),
    selectedTileColor: Colors.amber.shade100,
  ),
  // ...
)
```

## SmartAutoSuggestDataSource API

### Configuration (constructor parameters)

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `itemBuilder` | `SmartAutoSuggestItem<T> Function(BuildContext, T)` | **required** | Converts raw `T` to `SmartAutoSuggestItem<T>` |
| `initialList` | `List<T> Function(BuildContext)?` | `null` | Sync initial items (raw values) |
| `onSearch` | `Future<List<T>> Function(BuildContext, List<T>, String?)?` | `null` | Async search (returns raw values) |
| `searchMode` | `SmartAutoSuggestSearchMode` | `onNoLocalResults` | When to trigger `onSearch` |
| `debounce` | `Duration` | `400ms` | Debounce before calling `onSearch` |

### State (observable)

| Property | Type | Description |
|----------|------|-------------|
| `items` | `ValueNotifier<Set<SmartAutoSuggestItem<T>>>` | All available items (unfiltered) |
| `filteredItems` | `ValueNotifier<Set<SmartAutoSuggestItem<T>>>` | Filtered/sorted items shown in overlay |
| `isLoading` | `ValueNotifier<bool>` | Whether an async search is in progress |
| `errorMessage` | `ValueNotifier<String?>` | Error message from the last failed `onSearch` call |

### Methods

| Method | Description |
|--------|-------------|
| `filter(searchText, [sorter])` | Apply sorter and update `filteredItems` |
| `search(context, searchText)` | Trigger an async search via `onSearch` |
| `setItems(newItems, searchText)` | Replace all items and re-filter |
| `addItems(newItems, searchText)` | Merge new items into existing set and re-filter |
| `resetSearchState()` | Reset last query so the same search can run again |
| `dispose()` | Release resources (ValueNotifiers, timers) |

### External Control

You can observe and control the data source from outside the widget:

```dart
final dataSource = SmartAutoSuggestDataSource<String>(
  itemBuilder: (context, value) => SmartAutoSuggestItem(
    value: value,
    label: value[0].toUpperCase() + value.substring(1),
  ),
  initialList: (context) => ['apple', 'banana', 'cherry'],
  onSearch: (context, current, searchText) async {
    return await api.search(searchText);
  },
);

// Observe filtered items
dataSource.filteredItems.addListener(() {
  print('Filtered: ${dataSource.filteredItems.value.length} items');
});

// Observe loading state
dataSource.isLoading.addListener(() {
  print('Loading: ${dataSource.isLoading.value}');
});

// Add items programmatically
dataSource.addItems({
  SmartAutoSuggestItem(value: 'date', label: 'Date'),
}, 'searchText');

// Pass to widget
SmartAutoSuggestBox<String>(
  dataSource: dataSource,
  onSelected: (item) {},
);
```

## SmartAutoSuggestView unique parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `listMaxHeight` | `double` | `380` | Max height of the inline suggestion list |
| `showListWhenEmpty` | `bool` | `true` | Show list when text field is empty |

## Migration from 0.1.x

All old type names are kept as deprecated `typedef` aliases — no code changes required.
Rename at your own pace:

| Old | New |
|-----|-----|
| `SmartAutoSuggestBoxItem` | `SmartAutoSuggestItem` |
| `SmartAutoSuggestBoxDataSource` | `SmartAutoSuggestDataSource` |
| `SmartAutoSuggestBoxSearchMode` | `SmartAutoSuggestSearchMode` |
| `SmartAutoSuggestBoxSorter` | `SmartAutoSuggestSorter` |
| `SmartAutoSuggestBoxItemBuilder` | `SmartAutoSuggestItemBuilder` |

## Additional Information

- [Example app](example/) — complete demo with both widgets
- [CHANGELOG](CHANGELOG.md) — version history
- File issues on [GitHub](https://github.com/GeniusSystems24/smart_auto_suggest_box/issues)
