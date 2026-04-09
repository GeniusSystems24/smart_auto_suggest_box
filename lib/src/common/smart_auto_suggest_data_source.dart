part of 'common.dart';

/// A stateful data source for [SmartAutoSuggestBox],
/// [SmartAutoSuggestView], and [SmartAutoSuggestMultiSelectBox].
///
/// Manages the full lifecycle of suggestion items: loading initial data,
/// filtering, async searching, and notifying listeners when data changes.
///
/// Can be controlled externally to trigger searches, update items, or
/// observe loading/filtered state.
///
/// Example:
/// ```dart
/// final dataSource = SmartAutoSuggestDataSource<String>(
///   itemBuilder: (context, value) => SmartAutoSuggestItem(
///     value: value,
///     label: value,
///   ),
///   initialList: (context) => ['apple', 'banana'],
///   onSearch: (context, currentItems, searchText) async {
///     return await api.search(searchText);
///   },
/// );
///
/// // Listen to changes externally
/// dataSource.filteredItems.addListener(() {
///   print('Filtered: ${dataSource.filteredItems.value.length}');
/// });
///
/// dataSource.isLoading.addListener(() {
///   print('Loading: ${dataSource.isLoading.value}');
/// });
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
  final List<T> Function(BuildContext context)? initialList;

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
  )? onSearch;

  /// Controls when [onSearch] is invoked.
  ///
  /// Defaults to [SmartAutoSuggestSearchMode.onNoLocalResults].
  final SmartAutoSuggestSearchMode searchMode;

  /// Debounce duration before calling [onSearch].
  ///
  /// Defaults to 400ms. Set to [Duration.zero] for no debounce.
  final Duration debounce;

  // ─── State ──────────────────────────────────────────────────────────

  /// All available items (unfiltered).
  final ValueNotifier<Set<SmartAutoSuggestItem<T>>> items =
      ValueNotifier(<SmartAutoSuggestItem<T>>{});

  /// The currently filtered/sorted items shown in the overlay.
  final ValueNotifier<Set<SmartAutoSuggestItem<T>>> filteredItems =
      ValueNotifier(<SmartAutoSuggestItem<T>>{});

  /// Whether an async search is in progress.
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Error message from the last failed [onSearch] call.
  ///
  /// Set when [onSearch] throws an exception; cleared when a new search
  /// starts successfully. The overlay listens to this to display an
  /// error card instead of items.
  final ValueNotifier<String?> errorMessage = ValueNotifier(null);

  /// Tracks the last search query to avoid duplicate requests.
  String lastSearchQuery = '';

  /// Debounce timer for search-mode-always.
  Timer? _debounceTimer;

  /// Sorter cached from the most recent call to [filter], used so that a
  /// later [search] call can re-filter against the same widget-level
  /// sorter without needing to know about the widget that created it.
  SmartAutoSuggestSorter<T>? _lastSorter;

  /// Creates a data source for [SmartAutoSuggestBox].
  SmartAutoSuggestDataSource({
    required this.itemBuilder,
    this.initialList,
    this.onSearch,
    this.searchMode = SmartAutoSuggestSearchMode.onNoLocalResults,
    this.debounce = const Duration(milliseconds: 400),
  });

  /// Initializes items from [initialList]. Called once from the widget's
  /// [initState].
  void initialize(BuildContext context) {
    if (initialList != null) {
      final rawValues = initialList!(context);
      items.value =
          rawValues.map((v) => itemBuilder(context, v)).toSet();
    }
  }

  /// Applies the [sorter] to [items] and updates [filteredItems].
  ///
  /// If [sorter] is not provided, the most recently used sorter is
  /// re-applied. When no sorter has ever been supplied, [filteredItems]
  /// becomes a copy of [items].
  void filter(String searchText, [SmartAutoSuggestSorter<T>? sorter]) {
    if (sorter != null) _lastSorter = sorter;
    final s = _lastSorter;
    if (s == null) {
      filteredItems.value = items.value;
    } else {
      filteredItems.value = s(searchText, items.value);
    }
  }

  /// Performs an async search using [onSearch].
  ///
  /// Results are **merged** into [items] (never replace), so all data
  /// accumulated across multiple searches is retained.  After merging,
  /// [filter] is called so [filteredItems] shows only the items that
  /// match the current query.
  ///
  /// The overlay updates automatically because it listens to
  /// [filteredItems] and [isLoading].
  Future<void> search(
    BuildContext context,
    String searchText,
  ) async {
    if (onSearch == null) return;

    final trimmed = searchText.trim();
    if (trimmed.isEmpty) return;
    if (trimmed == lastSearchQuery) return;

    lastSearchQuery = trimmed;
    errorMessage.value = null;
    isLoading.value = true;
    try {
      final rawValues = await onSearch!(
        context,
        items.value.map((i) => i.value).toList(),
        trimmed,
      );
      if (rawValues.isNotEmpty) {
        final newItems =
            rawValues.map((v) => itemBuilder(context, v)).toSet();
        items.value = {...items.value, ...newItems};
      }
      // Always re-filter so the overlay shows only matching items,
      // even when the server returned no new results.
      filter(searchText);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Schedules a debounced search (used by search-mode-always).
  void scheduleSearch(BuildContext context, String searchText) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(debounce, () {
      search(context, searchText);
    });
  }

  /// Replaces all items and re-filters.
  void setItems(Set<SmartAutoSuggestItem<T>> newItems, String searchText) {
    items.value = newItems;
    filter(searchText);
  }

  /// Merges new items into the existing set and re-filters.
  void addItems(Set<SmartAutoSuggestItem<T>> newItems, String searchText) {
    items.value = {...items.value, ...newItems};
    filter(searchText);
  }

  /// Resets the search state so the same query can be re-executed.
  void resetSearchState() {
    lastSearchQuery = '';
  }

  /// Whether [other] has the same config (ignoring mutable state).
  ///
  /// Used by the widget to avoid re-initializing when the DataSource is
  /// recreated inline in the build method with the same callbacks.
  bool hasSameConfig(SmartAutoSuggestDataSource<T> other) {
    return identical(itemBuilder, other.itemBuilder) &&
        identical(initialList, other.initialList) &&
        identical(onSearch, other.onSearch) &&
        searchMode == other.searchMode &&
        debounce == other.debounce;
  }

  /// Releases resources used by this data source.
  void dispose() {
    _debounceTimer?.cancel();
    items.dispose();
    filteredItems.dispose();
    isLoading.dispose();
    errorMessage.dispose();
  }
}
