# Smart Auto Suggest Box

A highly customizable auto-suggest (autocomplete) text field widget for Flutter with **smart dropdown positioning** that adapts to available screen space.

[![pub package](https://img.shields.io/pub/v/smart_auto_suggest_box.svg)](https://pub.dev/packages/smart_auto_suggest_box)

## Features

- **Smart Positioning** - Dropdown automatically repositions when there's not enough space in the preferred direction
- **4-Direction Support** - Show suggestions in any direction: `top`, `bottom`, `start`, `end`
- **Auto-Fallback** - If the chosen direction has insufficient space, the dropdown falls back to the opposite direction
- **RTL Support** - `start`/`end` directions respect text directionality
- **Keyboard Navigation** - Navigate suggestions with arrow keys, Enter to select, Escape to dismiss
- **Async Loading** - Support for server-side search with loading indicators
- **Form Support** - Built-in form validation via `SmartAutoSuggestBox.form()`
- **Custom Builders** - Customize item rendering, no-results view, and loading state
- **Internationalization** - Built-in i18n support

## Getting Started

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  smart_auto_suggest_box: ^0.0.2
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

```dart
SmartAutoSuggestBox<String>(
  items: [
    SmartAutoSuggestBoxItem(value: 'apple', label: 'Apple'),
    SmartAutoSuggestBoxItem(value: 'banana', label: 'Banana'),
    SmartAutoSuggestBoxItem(value: 'cherry', label: 'Cherry'),
  ],
  decoration: const InputDecoration(
    labelText: 'Search fruits',
    border: OutlineInputBorder(),
  ),
  onSelected: (item) {
    print('Selected: ${item?.label}');
  },
);
```

### Smart Dropdown Positioning

Control where the dropdown appears using the `direction` parameter. The dropdown will automatically fall back to the opposite direction if the preferred direction doesn't have enough space:

```dart
SmartAutoSuggestBox<String>(
  items: myItems,
  direction: SmartAutoSuggestBoxDirection.bottom, // default
  onSelected: (item) {},
);
```

Available directions:

| Direction | Description |
|-----------|-------------|
| `bottom`  | Shows below the text field. Falls back to `top` if insufficient space. |
| `top`     | Shows above the text field. Falls back to `bottom` if insufficient space. |
| `start`   | Shows at the start side (left in LTR, right in RTL). Falls back to `end`. |
| `end`     | Shows at the end side (right in LTR, left in RTL). Falls back to `start`. |

### Form Validation

```dart
SmartAutoSuggestBox<String>.form(
  items: myItems,
  validator: (value) {
    if (value == null || value.isEmpty) return 'Required field';
    return null;
  },
  autovalidateMode: AutovalidateMode.onUserInteraction,
  onSelected: (item) {},
);
```

### Async Server Search

```dart
SmartAutoSuggestBox<String>(
  items: localItems,
  onNoResultsFound: (query) async {
    final results = await api.search(query);
    return results.map((r) =>
      SmartAutoSuggestBoxItem(value: r.id, label: r.name),
    ).toList();
  },
  onSelected: (item) {},
);
```

### Custom Item Builder

```dart
SmartAutoSuggestBox<String>(
  items: myItems,
  itemBuilder: (context, item) {
    return ListTile(
      leading: const Icon(Icons.fruit),
      title: Text(item.label),
      subtitle: Text('Value: ${item.value}'),
    );
  },
  onSelected: (item) {},
);
```

## Additional Information

- [Example app](example/) - Full working example with all directions
- [CHANGELOG](CHANGELOG.md) - Version history and breaking changes
- File issues on [GitHub](https://github.com/GeniusSystems24/smart_auto_suggest_box/issues)
