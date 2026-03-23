# Smart Auto Suggest Box

A highly customizable auto-suggest (autocomplete) Flutter package offering two widgets:

- **`SmartAutoSuggestBox`** — floating overlay dropdown
- **`SmartAutoSuggestView`** — inline suggestion list embedded in the widget tree

Both share the same `SmartAutoSuggestDataSource` API and item model.

[![pub package](https://img.shields.io/pub/v/smart_auto_suggest_box.svg)](https://pub.dev/packages/smart_auto_suggest_box)

## Features

- **Two display modes** — floating overlay (`SmartAutoSuggestBox`) or inline list (`SmartAutoSuggestView`)
- **Unified data source** — `SmartAutoSuggestDataSource` with sync `initialList` and async `onSearch`
- **Smart overlay positioning** — auto-repositions to the opposite side if insufficient space (`SmartAutoSuggestBox` only)
- **4-direction support** — `top`, `bottom`, `start`, `end` with RTL awareness
- **Search modes** — `onNoLocalResults` (default) or `always` (every keystroke)
- **Configurable debounce** — control search trigger timing
- **Keyboard navigation** — ↑ ↓ Enter Escape
- **Form support** — `SmartAutoSuggestBox.form()` and `SmartAutoSuggestView.form()` with validation
- **Scrollbar** — visible scrollbar thumb when the suggestion list overflows
- **Custom builders** — item, no-results, loading state
- **Theming** — `SmartAutoSuggestTheme` (`ThemeExtension`) with light/dark defaults
- **BottomSheet ready** — `SmartAutoSuggestView` works inside `showModalBottomSheet`
- **Internationalization** — built-in i18n

## Getting Started

```yaml
dependencies:
  smart_auto_suggest_box: ^0.4.0

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

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `itemBuilder` | `SmartAutoSuggestItem<T> Function(BuildContext, T)` | **required** | Converts raw `T` to `SmartAutoSuggestItem<T>` |
| `initialList` | `List<T> Function(BuildContext)?` | `null` | Sync initial items (raw values) |
| `onSearch` | `Future<List<T>> Function(BuildContext, List<T>, String?)?` | `null` | Async search (returns raw values) |
| `searchMode` | `SmartAutoSuggestSearchMode` | `onNoLocalResults` | When to trigger `onSearch` |
| `debounce` | `Duration` | `400ms` | Debounce before calling `onSearch` |

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
