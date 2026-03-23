part of '../../smart_auto_suggest_box.dart';

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
