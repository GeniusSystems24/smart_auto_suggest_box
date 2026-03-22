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
- **Custom builders** — item, no-results, loading state
- **Internationalization** — built-in i18n

## Getting Started

```yaml
dependencies:
  smart_auto_suggest_box: ^0.2.0

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
    initialList: (context) => [
      SmartAutoSuggestItem(value: 'apple', label: 'Apple'),
      SmartAutoSuggestItem(value: 'banana', label: 'Banana'),
    ],
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
    initialList: (context) => [
      SmartAutoSuggestItem(value: 'apple', label: 'Apple'),
      SmartAutoSuggestItem(value: 'banana', label: 'Banana'),
    ],
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
    initialList: (context) => [],
    onSearch: (context, currentItems, searchText) async {
      final results = await api.search(searchText);
      return results.map((r) =>
        SmartAutoSuggestItem(value: r.id, label: r.name),
      ).toList();
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
  dataSource: SmartAutoSuggestDataSource(initialList: (c) => items),
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

### Form Validation

```dart
SmartAutoSuggestView.form(
  dataSource: SmartAutoSuggestDataSource(initialList: (c) => items),
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required';
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onSelected: (item) {},
);
```

## SmartAutoSuggestDataSource API

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `initialList` | `List<SmartAutoSuggestItem<T>> Function(BuildContext)?` | `null` | Sync initial items |
| `onSearch` | `Future<List<SmartAutoSuggestItem<T>>> Function(BuildContext, List, String?)?` | `null` | Async search |
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
