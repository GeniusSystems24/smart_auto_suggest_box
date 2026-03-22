part of '../smart_auto_suggest_box.dart';

const kPickerHeight = 32.0;
const kPickerDiameterRatio = 100.0;
const kComboBoxRadius = Radius.circular(4.0);
const double kOneLineTileHeight = 40.0;
const double kComboBoxItemHeight = kOneLineTileHeight + 10;

typedef WidgetOrNullBuilder = Widget? Function(BuildContext context);
typedef SmartAutoSuggestSorter<T> =
    Set<SmartAutoSuggestItem<T>> Function(
      String text,
      Set<SmartAutoSuggestItem<T>> items,
    );

typedef OnChangeSmartAutoSuggestBox<T> =
    void Function(String text, FluentTextChangedReason reason);

typedef SmartAutoSuggestItemBuilder<T> =
    Widget Function(BuildContext context, SmartAutoSuggestItem<T> item);

enum FluentTextChangedReason {
  /// Whether the text in an [SmartAutoSuggestBox] was changed by user input
  userInput,

  /// Whether the text in an [SmartAutoSuggestBox] was changed because the user
  /// chose the suggestion
  suggestionChosen,

  /// Whether the text in an [SmartAutoSuggestBox] was cleared by the user
  cleared,
}

/// Controls when [SmartAutoSuggestDataSource.onSearch] is invoked.
enum SmartAutoSuggestSearchMode {
  /// Only calls [SmartAutoSuggestDataSource.onSearch] when local filtering
  /// yields no results. This is the default behavior.
  onNoLocalResults,

  /// Calls [SmartAutoSuggestDataSource.onSearch] on every text change
  /// (after debounce), regardless of local results.
  always,
}

/// A data source configuration for [SmartAutoSuggestBox] that provides
/// flexible data fetching capabilities including sync initial data
/// and async search.
///
/// Example:
/// ```dart
/// SmartAutoSuggestBox<String>(
///   dataSource: SmartAutoSuggestDataSource(
///     initialList: (context) => [
///       SmartAutoSuggestItem(value: 'apple', label: 'Apple'),
///       SmartAutoSuggestItem(value: 'banana', label: 'Banana'),
///     ],
///     onSearch: (context, currentItems, searchText) async {
///       final results = await api.search(searchText);
///       return results.map((r) =>
///         SmartAutoSuggestItem(value: r.id, label: r.name),
///       ).toList();
///     },
///   ),
/// )
/// ```
class SmartAutoSuggestDataSource<T> {
  /// Synchronous initial items provided when the widget first builds.
  ///
  /// Called once during [initState] with the widget's [BuildContext].
  final List<SmartAutoSuggestItem<T>> Function(BuildContext context)?
  initialList;

  /// Async search callback invoked when new data is needed.
  ///
  /// Parameters:
  /// - [context]: The widget's build context
  /// - [currentItems]: The current list of items in the widget
  /// - [searchText]: The current search text (null when loading initial data)
  ///
  /// When invoked depends on [searchMode]:
  /// - [SmartAutoSuggestSearchMode.onNoLocalResults]: Called only when
  ///   local filtering yields no results.
  /// - [SmartAutoSuggestSearchMode.always]: Called on every text change
  ///   after the [debounce] duration.
  final Future<List<SmartAutoSuggestItem<T>>> Function(
    BuildContext context,
    List<SmartAutoSuggestItem<T>> currentItems,
    String? searchText,
  )?
  onSearch;

  /// Controls when [onSearch] is invoked.
  ///
  /// Defaults to [SmartAutoSuggestSearchMode.onNoLocalResults].
  final SmartAutoSuggestSearchMode searchMode;

  /// Debounce duration before calling [onSearch].
  ///
  /// Defaults to 400ms. Set to [Duration.zero] for no debounce.
  final Duration debounce;

  /// Creates a data source for [SmartAutoSuggestBox].
  const SmartAutoSuggestDataSource({
    this.initialList,
    this.onSearch,
    this.searchMode = SmartAutoSuggestSearchMode.onNoLocalResults,
    this.debounce = const Duration(milliseconds: 400),
  });
}

enum SmartAutoSuggestBoxDirection {
  /// The suggestions overlay will be shown below the text box.
  /// Falls back to top if insufficient space below.
  bottom,

  /// The suggestions overlay will be shown above the text box.
  /// Falls back to bottom if insufficient space above.
  top,

  /// The suggestions overlay will be shown at the start (left in LTR, right in RTL).
  /// Falls back to end if insufficient space at start.
  start,

  /// The suggestions overlay will be shown at the end (right in LTR, left in RTL).
  /// Falls back to start if insufficient space at end.
  end,
}

/// The default max height the auto suggest box popup can have
const kSmartAutoSuggestBoxPopupMaxHeight = 380.0;

/// An item used in [SmartAutoSuggestBox]
class SmartAutoSuggestItem<T> {
  /// The value attached to this item
  final T value;

  /// The label that identifies this item
  ///
  /// The data is filtered based on this label
  final String label;

  /// The widget to be shown.
  ///
  /// If null, [label] is displayed
  ///
  /// Usually a [Text]
  final Widget? child, subtitle;

  /// Called when this item's focus is changed.
  final ValueChanged<bool>? onFocusChange;

  /// Called when this item is selected
  final VoidCallback? onSelected;

  /// {@macro fluent_ui.controls.inputs.HoverButton.semanticLabel}
  ///
  /// If not provided, [label] is used
  final String? semanticLabel;

  final bool enabled;

  bool _selected = false;

  /// Creates an auto suggest box item
  SmartAutoSuggestItem({
    required this.value,
    required this.label,
    this.child,
    this.onFocusChange,
    this.onSelected,
    this.semanticLabel,
    this.enabled = true,
    this.subtitle,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SmartAutoSuggestItem && other.value == value;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }
}

// ─── Backward-compatibility aliases (deprecated) ────────────────────────────

/// Deprecated. Use [SmartAutoSuggestItem] instead.
@Deprecated('Use SmartAutoSuggestItem instead')
typedef SmartAutoSuggestBoxItem<T> = SmartAutoSuggestItem<T>;

/// Deprecated. Use [SmartAutoSuggestDataSource] instead.
@Deprecated('Use SmartAutoSuggestDataSource instead')
typedef SmartAutoSuggestBoxDataSource<T> = SmartAutoSuggestDataSource<T>;

/// Deprecated. Use [SmartAutoSuggestSearchMode] instead.
@Deprecated('Use SmartAutoSuggestSearchMode instead')
typedef SmartAutoSuggestBoxSearchMode = SmartAutoSuggestSearchMode;

/// Deprecated. Use [SmartAutoSuggestSorter] instead.
@Deprecated('Use SmartAutoSuggestSorter instead')
typedef SmartAutoSuggestBoxSorter<T> = SmartAutoSuggestSorter<T>;

/// Deprecated. Use [SmartAutoSuggestItemBuilder] instead.
@Deprecated('Use SmartAutoSuggestItemBuilder instead')
typedef SmartAutoSuggestBoxItemBuilder<T> = SmartAutoSuggestItemBuilder<T>;

// ─────────────────────────────────────────────────────────────────────────────
