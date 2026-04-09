part of 'common.dart';

/// Internal state-management engine shared by [SmartAutoSuggestBox],
/// [SmartAutoSuggestMultiSelectBox], and [SmartAutoSuggestView].
///
/// Centralizes filtering, async search scheduling, keyboard-navigation
/// focus, and listener wiring so that individual widgets don't each have
/// to re-implement the same logic.
///
/// The engine extends [ChangeNotifier]; widgets subscribe once with
/// [addListener] and call [setState] from the callback.
class SmartAutoSuggestEngine<T> extends ChangeNotifier {
  SmartAutoSuggestEngine({
    required TextEditingController textController,
    required SmartAutoSuggestDataSource<T> dataSource,
    required SmartAutoSuggestSorter<T> sorter,
    bool enableKeyboardFocus = true,
    Future<void> Function(BuildContext context, String text)? onSearchOverride,
  }) : _textController = textController,
       _dataSource = dataSource,
       _sorter = sorter,
       _enableKeyboardFocus = enableKeyboardFocus,
       _onSearchOverride = onSearchOverride;

  TextEditingController _textController;
  SmartAutoSuggestDataSource<T> _dataSource;
  SmartAutoSuggestSorter<T> _sorter;
  bool _enableKeyboardFocus;

  /// Legacy [SmartAutoSuggestBox.onNoResultsFound] adapter. When set, it is
  /// used instead of [SmartAutoSuggestDataSource.search] for the no-results
  /// fallback path.
  Future<void> Function(BuildContext context, String text)? _onSearchOverride;

  bool _attached = false;

  // ─── Notifiers ────────────────────────────────────────────────────────

  /// Index of the currently keyboard-focused item in [filteredList].
  ///
  /// A value of `-1` means "nothing focused". This replaces the old
  /// mutable `item.selected` field as the source of truth for highlight.
  final ValueNotifier<int> focusedIndex = ValueNotifier<int>(-1);

  /// Whether the floating overlay is currently visible (owned by the
  /// widget, updated via [setOverlayVisible]).
  final ValueNotifier<bool> overlayVisible = ValueNotifier<bool>(false);

  // ─── Public getters ───────────────────────────────────────────────────

  TextEditingController get textController => _textController;
  SmartAutoSuggestDataSource<T> get dataSource => _dataSource;
  SmartAutoSuggestSorter<T> get sorter => _sorter;

  /// The substring from the start of the input to the current caret.
  ///
  /// Mirrors the `_searchText` getter that every widget used to carry.
  String get searchText {
    final text = _textController.text;
    final offset = _textController.selection.baseOffset;
    if (offset < 0 || offset > text.length) return text;
    return text.substring(0, offset);
  }

  /// Snapshot of the currently filtered items as a list (for indexed access).
  List<SmartAutoSuggestItem<T>> get filteredList =>
      _dataSource.filteredItems.value.toList(growable: false);

  SmartAutoSuggestItem<T>? get focusedItem {
    final list = filteredList;
    final index = focusedIndex.value;
    if (index < 0 || index >= list.length) return null;
    return list[index];
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────

  /// Starts listening to the text controller and data source.
  void attach() {
    if (_attached) return;
    _attached = true;
    _textController.addListener(_onTextChanged);
    _dataSource.filteredItems.addListener(_onDataSourceChanged);
    _dataSource.isLoading.addListener(_onDataSourceChanged);
    _dataSource.errorMessage.addListener(_onDataSourceChanged);
    _applyFilter();
  }

  /// Stops listening to the text controller and data source.
  void detach() {
    if (!_attached) return;
    _attached = false;
    _textController.removeListener(_onTextChanged);
    _dataSource.filteredItems.removeListener(_onDataSourceChanged);
    _dataSource.isLoading.removeListener(_onDataSourceChanged);
    _dataSource.errorMessage.removeListener(_onDataSourceChanged);
  }

  /// Updates any combination of engine configuration values atomically.
  ///
  /// Used from widget `didUpdateWidget` when the caller swaps a
  /// [TextEditingController], [SmartAutoSuggestDataSource], sorter, or
  /// any other configuration piece.
  void updateConfig({
    TextEditingController? textController,
    SmartAutoSuggestDataSource<T>? dataSource,
    SmartAutoSuggestSorter<T>? sorter,
    bool? enableKeyboardFocus,
    Future<void> Function(BuildContext context, String text)? onSearchOverride,
    bool clearOnSearchOverride = false,
  }) {
    final wasAttached = _attached;
    if (wasAttached) detach();

    if (textController != null && textController != _textController) {
      _textController = textController;
    }
    if (dataSource != null && dataSource != _dataSource) {
      _dataSource = dataSource;
    }
    if (sorter != null) {
      _sorter = sorter;
    }
    if (enableKeyboardFocus != null) {
      _enableKeyboardFocus = enableKeyboardFocus;
    }
    if (clearOnSearchOverride) {
      _onSearchOverride = null;
    } else if (onSearchOverride != null) {
      _onSearchOverride = onSearchOverride;
    }

    if (wasAttached) attach();
  }

  @override
  void dispose() {
    detach();
    focusedIndex.dispose();
    overlayVisible.dispose();
    super.dispose();
  }

  // ─── Filter / search ──────────────────────────────────────────────────

  /// Re-runs the sorter against the current text. Called after
  /// [SmartAutoSuggestDataSource.initialize] has populated the initial list
  /// in the widget's post-frame callback.
  void refresh() {
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    _dataSource.filter(searchText, _sorter);
    _clampFocus();
  }

  void _clampFocus() {
    final length = _dataSource.filteredItems.value.length;
    if (focusedIndex.value >= length) {
      _assignFocus(length - 1);
    }
  }

  void _onTextChanged() {
    _applyFilter();
    notifyListeners();
  }

  void _onDataSourceChanged() {
    _clampFocus();
    notifyListeners();
  }

  /// Schedules an async search when the widget is configured with
  /// [SmartAutoSuggestSearchMode.onNoLocalResults] and the local filter
  /// returned nothing.
  void scheduleSearchOnNoResults(BuildContext context) {
    if (_dataSource.searchMode != SmartAutoSuggestSearchMode.onNoLocalResults) {
      return;
    }

    final text = searchText.trim();
    if (text.isEmpty ||
        _dataSource.filteredItems.value.isNotEmpty ||
        _dataSource.isLoading.value) {
      return;
    }
    if (_dataSource.onSearch == null && _onSearchOverride == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      final currentText = searchText.trim();
      if (currentText != text ||
          _dataSource.filteredItems.value.isNotEmpty ||
          _dataSource.isLoading.value) {
        return;
      }

      if (_onSearchOverride != null) {
        unawaited(_onSearchOverride!(context, text));
      } else {
        unawaited(_dataSource.search(context, text));
      }
    });
  }

  /// Debounce-triggers an async search on every keystroke when the widget
  /// is configured with [SmartAutoSuggestSearchMode.always].
  void scheduleSearchAlways(BuildContext context) {
    if (_dataSource.searchMode != SmartAutoSuggestSearchMode.always ||
        _dataSource.onSearch == null) {
      return;
    }
    _dataSource.scheduleSearch(context, searchText.trim());
  }

  // ─── Keyboard focus ───────────────────────────────────────────────────

  /// On desktop, auto-focus the first item the first time the overlay
  /// opens so the user can navigate with arrow keys immediately.
  void focusFirstIfVisible() {
    if (!_enableKeyboardFocus || !isDesktopPlatform) return;
    if (focusedIndex.value != -1) return;
    final list = _dataSource.filteredItems.value;
    if (list.isEmpty) return;
    _assignFocus(0);
  }

  void focusNext() {
    final length = _dataSource.filteredItems.value.length;
    if (length == 0) return;
    final current = focusedIndex.value;
    if (current == -1 || current == length - 1) {
      _assignFocus(0);
    } else {
      _assignFocus(current + 1);
    }
  }

  void focusPrevious() {
    final length = _dataSource.filteredItems.value.length;
    if (length == 0) return;
    final current = focusedIndex.value;
    if (current <= 0) {
      _assignFocus(length - 1);
    } else {
      _assignFocus(current - 1);
    }
  }

  void clearFocus() => _assignFocus(-1);

  /// Returns the currently focused item (used for Enter-key submission).
  SmartAutoSuggestItem<T>? confirmFocused() => focusedItem;

  void _assignFocus(int index) {
    final length = _dataSource.filteredItems.value.length;
    final clamped = index < -1
        ? -1
        : (index >= length ? length - 1 : index);
    if (clamped == focusedIndex.value) return;

    final list = _dataSource.filteredItems.value.toList(growable: false);

    // Update the deprecated mutable `selected` flag on the items involved.
    // Its setter still fires `onFocusChange`, which preserves the public
    // callback contract. Keeping the flag in sync also means any external
    // code that still reads [SmartAutoSuggestItem.selected] observes the
    // expected value.
    final previousIndex = focusedIndex.value;
    if (previousIndex >= 0 && previousIndex < list.length) {
      // ignore: deprecated_member_use_from_same_package
      list[previousIndex].selected = false;
    }
    if (clamped >= 0 && clamped < list.length) {
      // ignore: deprecated_member_use_from_same_package
      list[clamped].selected = true;
    }

    focusedIndex.value = clamped;
  }

  // ─── Overlay visibility ───────────────────────────────────────────────

  void setOverlayVisible(bool value) {
    if (overlayVisible.value == value) return;
    overlayVisible.value = value;
    if (!value) clearFocus();
  }
}
