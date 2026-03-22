# Smart Auto Suggest Box

A highly customizable auto-suggest (autocomplete) text field widget for Flutter with **smart dropdown positioning** and a **flexible data source** API.

[![pub package](https://img.shields.io/pub/v/smart_auto_suggest_box.svg)](https://pub.dev/packages/smart_auto_suggest_box)

## Features

- **Data Source API** - Unified `SmartAutoSuggestBoxDataSource` for sync initial data and async search
- **Smart Positioning** - Dropdown automatically repositions when there's not enough space
- **4-Direction Support** - Show suggestions in any direction: `top`, `bottom`, `start`, `end`
- **Auto-Fallback** - Falls back to the opposite direction if insufficient space
- **Search Modes** - `onNoLocalResults` (default) or `always` for every keystroke
- **Configurable Debounce** - Control search trigger timing
- **RTL Support** - `start`/`end` directions respect text directionality
- **Keyboard Navigation** - Arrow keys, Enter to select, Escape to dismiss
- **Form Support** - Built-in form validation via `SmartAutoSuggestBox.form()`
- **Custom Builders** - Customize item rendering, no-results view, and loading state
- **Internationalization** - Built-in i18n support

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  smart_auto_suggest_box: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage with Data Source

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestBoxDataSource(
    initialList: (context) => [
      SmartAutoSuggestBoxItem(value: 'apple', label: 'Apple'),
      SmartAutoSuggestBoxItem(value: 'banana', label: 'Banana'),
      SmartAutoSuggestBoxItem(value: 'cherry', label: 'Cherry'),
    ],
  ),
  decoration: const InputDecoration(
    labelText: 'Search fruits',
    border: OutlineInputBorder(),
  ),
  onSelected: (item) {
    print('Selected: ${item?.label}');
  },
);
```

### Async Server Search

Use `onSearch` to fetch results from a server when local filtering yields no results:

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestBoxDataSource(
    initialList: (context) => [], // Start with empty list
    onSearch: (context, currentItems, searchText) async {
      final results = await api.search(searchText);
      return results.map((r) =>
        SmartAutoSuggestBoxItem(value: r.id, label: r.name),
      ).toList();
    },
    debounce: const Duration(milliseconds: 500),
  ),
  onSelected: (item) {},
);
```

### Always Search Mode

Call `onSearch` on every text change (after debounce), regardless of local results:

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestBoxDataSource(
    initialList: (context) => localItems,
    onSearch: (context, currentItems, searchText) async {
      return await api.search(searchText);
    },
    searchMode: SmartAutoSuggestBoxSearchMode.always,
    debounce: const Duration(milliseconds: 600),
  ),
  onSelected: (item) {},
);
```

### Smart Dropdown Positioning

Control where the dropdown appears. It will automatically fall back to the opposite direction if insufficient space:

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestBoxDataSource(
    initialList: (context) => myItems,
  ),
  direction: SmartAutoSuggestBoxDirection.bottom, // default
  onSelected: (item) {},
);
```

| Direction | Description |
|-----------|-------------|
| `bottom`  | Shows below the text field. Falls back to `top` if insufficient space. |
| `top`     | Shows above the text field. Falls back to `bottom` if insufficient space. |
| `start`   | Shows at the start side (left in LTR, right in RTL). Falls back to `end`. |
| `end`     | Shows at the end side (right in LTR, left in RTL). Falls back to `start`. |

### Form Validation

```dart
SmartAutoSuggestBox<String>.form(
  dataSource: SmartAutoSuggestBoxDataSource(
    initialList: (context) => myItems,
  ),
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required field';
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onSelected: (item) {},
);
```

### Custom Item Builder

```dart
SmartAutoSuggestBox<String>(
  dataSource: SmartAutoSuggestBoxDataSource(
    initialList: (context) => myItems,
  ),
  itemBuilder: (context, item) {
    return ListTile(
      leading: const Icon(Icons.label),
      title: Text(item.label),
      subtitle: Text('Value: ${item.value}'),
    );
  },
  onSelected: (item) {},
);
```

## SmartAutoSuggestBoxDataSource API

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `initialList` | `List<Item> Function(BuildContext)?` | `null` | Sync callback for initial items |
| `onSearch` | `Future<List<Item>> Function(BuildContext, List<Item>, String?)?` | `null` | Async search callback |
| `searchMode` | `SmartAutoSuggestBoxSearchMode` | `onNoLocalResults` | When to trigger `onSearch` |
| `debounce` | `Duration` | `400ms` | Debounce before calling `onSearch` |

## Migration from 0.0.x

```dart
// Before (deprecated)
SmartAutoSuggestBox(
  items: [item1, item2],
  onNoResultsFound: (text) async => await api.search(text),
);

// After
SmartAutoSuggestBox(
  dataSource: SmartAutoSuggestBoxDataSource(
    initialList: (context) => [item1, item2],
    onSearch: (context, currentItems, searchText) async {
      return await api.search(searchText);
    },
  ),
);
```

## Additional Information

- [Example app](example/) - Full working example with all features
- [CHANGELOG](CHANGELOG.md) - Version history and breaking changes
- File issues on [GitHub](https://github.com/GeniusSystems24/smart_auto_suggest_box/issues)
