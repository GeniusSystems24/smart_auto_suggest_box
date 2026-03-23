part of 'common.dart';

/// A data source configuration for [SmartAutoSuggestBox] that provides
/// flexible data fetching capabilities including sync initial data
/// and async search.
///
/// Example:
/// ```dart
/// SmartAutoSuggestBox<String>(
///   dataSource: SmartAutoSuggestDataSource(
///     itemBuilder: (context, value) => SmartAutoSuggestItem(
///       value: value,
///       label: value,
///     ),
///     initialList: (context) => ['apple', 'banana'],
///     onSearch: (context, currentItems, searchText) async {
///       return await api.search(searchText);
///     },
///   ),
/// )
/// ```
class SmartAutoSuggestDataSource<T> {
  /// Converts a raw value of type [T] into a [SmartAutoSuggestItem].
  ///
  /// This builder is called for every item returned by [initialList] and
  /// [onSearch] to create the corresponding [SmartAutoSuggestItem].
  final SmartAutoSuggestItem<T> Function(BuildContext context, T value)
  itemBuilder;

  /// Synchronous initial items provided when the widget first builds.
  ///
  /// Called once during [initState] with the widget's [BuildContext].
  /// Returns a list of raw values that will be converted to
  /// [SmartAutoSuggestItem] via [itemBuilder].
  final List<T> Function(BuildContext context)?
  initialList;

  /// Async search callback invoked when new data is needed.
  ///
  /// Parameters:
  /// - [context]: The widget's build context
  /// - [currentItems]: The current list of raw values in the widget
  /// - [searchText]: The current search text (null when loading initial data)
  ///
  /// Returns a list of raw values that will be converted to
  /// [SmartAutoSuggestItem] via [itemBuilder].
  ///
  /// When invoked depends on [searchMode]:
  /// - [SmartAutoSuggestSearchMode.onNoLocalResults]: Called only when
  ///   local filtering yields no results.
  /// - [SmartAutoSuggestSearchMode.always]: Called on every text change
  ///   after the [debounce] duration.
  final Future<List<T>> Function(
    BuildContext context,
    List<T> currentItems,
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
    required this.itemBuilder,
    this.initialList,
    this.onSearch,
    this.searchMode = SmartAutoSuggestSearchMode.onNoLocalResults,
    this.debounce = const Duration(milliseconds: 400),
  });
}
