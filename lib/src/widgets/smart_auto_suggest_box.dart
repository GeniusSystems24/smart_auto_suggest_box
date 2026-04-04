part of '../../smart_auto_suggest_box.dart';

/// An SmartAutoSuggestBox provides a list of suggestions for a user to select from
/// as they type.
///
/// ![SmartAutoSuggestBox Preview](https://docs.microsoft.com/en-us/windows/apps/design/controls/images/controls-autosuggest-expanded-01.png)
///
/// See also:
///
///  * [TextBox], which is used by this widget to enter user text input
///  * [TextFormBox], which is used by this widget by Form
///  * [Overlay], which is used to show the suggestion popup
///  * <https://docs.microsoft.com/en-us/windows/apps/design/controls/auto-suggest-box>

class SmartAutoSuggestBox<T> extends StatefulWidget {
  /// Creates a fluent-styled auto suggest box.
  ///
  /// Use [dataSource] to provide items and search functionality.
  /// The deprecated [items] parameter is still supported for backward
  /// compatibility.
  SmartAutoSuggestBox({
    super.key,
    @Deprecated('Use dataSource with initialList instead')
    List<SmartAutoSuggestItem<T>> items = const [],
    this.dataSource,
    @Deprecated('Use smartController instead') this.controller,
    this.smartController,
    this.onChanged,
    this.onSelected,
    this.onOverlayVisibilityChanged,
    this.itemBuilder,
    this.noResultsFoundBuilder,
    this.sorter,
    this.trailingIcon,
    this.clearButtonEnabled = true,
    this.style,
    this.decoration,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorWidth = 1.5,
    this.showCursor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.enableKeyboardControls = true,
    this.enabled = true,
    this.inputFormatters,
    this.maxPopupHeight = kSmartAutoSuggestBoxPopupMaxHeight,
    @Deprecated('Use dataSource with onSearch instead') this.onNoResultsFound,
    this.waitingBuilder,
    this.tileHeight = kComboBoxItemHeight,
    this.direction = SmartAutoSuggestBoxDirection.bottom,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
    this.theme,
    this.selectedItemBuilder,
  }) : autovalidateMode = AutovalidateMode.disabled,
       validator = null,
       items = dataSource != null
           ? ValueNotifier(<SmartAutoSuggestItem<T>>{})
           : ValueNotifier(items.toSet());

  /// Creates a fluent-styled auto suggest form box.
  SmartAutoSuggestBox.form({
    super.key,
    @Deprecated('Use dataSource with initialList instead')
    List<SmartAutoSuggestItem<T>> items = const [],
    this.dataSource,
    @Deprecated('Use smartController instead') this.controller,
    this.smartController,
    this.onChanged,
    this.onSelected,
    this.onOverlayVisibilityChanged,
    this.itemBuilder,
    this.noResultsFoundBuilder,
    this.sorter,
    this.trailingIcon,
    this.clearButtonEnabled = true,
    this.style,
    this.decoration,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorWidth = 1.5,
    this.showCursor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.textInputAction,
    this.focusNode,
    this.autofocus = false,
    this.enableKeyboardControls = true,
    this.enabled = true,
    this.inputFormatters,
    this.maxPopupHeight = kSmartAutoSuggestBoxPopupMaxHeight,
    @Deprecated('Use dataSource with onSearch instead') this.onNoResultsFound,
    this.waitingBuilder,
    this.tileHeight = kComboBoxItemHeight,
    this.direction = SmartAutoSuggestBoxDirection.bottom,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
    this.theme,
    this.selectedItemBuilder,
  }) : items = dataSource != null
           ? ValueNotifier(<SmartAutoSuggestItem<T>>{})
           : ValueNotifier(items.toSet());

  /// Optional theme override for this widget.
  ///
  /// If null, the widget will use [SmartAutoSuggestTheme] from the nearest
  /// [Theme], or fall back to system defaults.
  final SmartAutoSuggestTheme? theme;

  /// Builder for displaying the selected item as a custom widget.
  ///
  /// When provided and an item is selected, this widget replaces the
  /// [TextField]. Tapping the widget dismisses it and shows the [TextField]
  /// again for a new search.
  ///
  /// When `null` (default), the selected item's label is placed into the
  /// [TextField] as plain text (the classic behavior).
  final Widget Function(BuildContext context, SmartAutoSuggestItem<T> item)?
      selectedItemBuilder;

  /// offset: const Offset(0, 0.8),
  /// Creates a fluent-styled auto suggest box.
  final Offset? offset;

  /// max length of the text box
  final int? maxLength;

  /// KeyBoardType for the text box
  /// Defaults to [TextInputType.text]
  final TextInputType keyboardType;

  /// The direction in which the suggestions overlay will be shown
  final SmartAutoSuggestBoxDirection direction;

  /// The data source for providing items and search functionality.
  ///
  /// When provided, this replaces both [items] and [onNoResultsFound].
  final SmartAutoSuggestDataSource<T>? dataSource;

  /// The list of items to display to the user to pick.
  ///
  /// Deprecated: Use [dataSource] with [SmartAutoSuggestDataSource.initialList] instead.
  final ValueNotifier<Set<SmartAutoSuggestItem<T>>> items;

  @Deprecated('Use dataSource with onSearch instead')
  final Future<List<SmartAutoSuggestItem<T>>> Function(String text)?
  onNoResultsFound;

  /// The controller used to have control over what to show on the [TextBox].
  ///
  /// Deprecated: Use [smartController] instead.
  @Deprecated('Use smartController instead')
  final TextEditingController? controller;

  /// A unified controller that provides access to both the text input and the
  /// currently selected item.
  ///
  /// When provided, [controller] is ignored.
  final SmartAutoSuggestController<T>? smartController;

  /// Called when the text is updated
  final OnChangeSmartAutoSuggestBox? onChanged;

  /// Called when the user selected a value.
  final ValueChanged<SmartAutoSuggestItem<T>?>? onSelected;

  /// Called when the overlay visibility changes
  final ValueChanged<bool>? onOverlayVisibilityChanged;

  /// A callback function that builds the items in the overlay.
  ///
  /// Use [noResultsFoundBuilder] to build the overlay when no item is provided
  final SmartAutoSuggestItemBuilder? itemBuilder;

  final Widget Function(BuildContext context)? waitingBuilder;
  final double tileHeight;

  /// Widget to be displayed when none of the items fit the [sorter]
  final WidgetOrNullBuilder? noResultsFoundBuilder;

  /// Sort the [items] based on the current query text
  ///
  /// See also:
  ///
  ///  * [SmartAutoSuggestBox.defaultItemSorter], the default item sorter
  final SmartAutoSuggestSorter<T>? sorter;

  /// A widget displayed at the end of the text box
  ///
  /// Usually an [IconButton] or [Icon]
  final Widget? trailingIcon;

  /// Whether the close button is enabled
  ///
  /// Defauls to true
  final bool clearButtonEnabled;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// Controls the [InputDecoration] of the box behind the text input.
  final InputDecoration? decoration;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius cursorRadius;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  final Color? cursorColor;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to the brightness of [FluentThemeData.brightness].
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<String>? validator;

  /// Used to enable/disable this form field auto validation and update its
  /// error text.
  final AutovalidateMode autovalidateMode;

  /// The type of action button to use for the keyboard.
  ///
  /// Defaults to [TextInputAction.newline] if [keyboardType] is
  /// [TextInputType.multiline] and [TextInputAction.done] otherwise.
  final TextInputAction? textInputAction;

  /// An object that can be used by a stateful widget to obtain the keyboard focus
  /// and to handle keyboard events.
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Whether the items can be selected using the keyboard
  ///
  /// Arrow Up - focus the item above
  /// Arrow Down - focus the item below
  /// Enter - select the current focused item
  /// Escape - close the suggestions overlay
  ///
  /// Defaults to `true`
  final bool enableKeyboardControls;

  /// Whether the text box is enabled
  ///
  /// See also:
  ///  * [TextBox.enabled]
  final bool enabled;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// The max height the popup can assume.
  ///
  /// The suggestion popup can assume the space available below the text box but,
  /// by default, it's limited to a 380px height. If the value provided is greater
  /// than the available space, the box is limited to the available space.
  final double maxPopupHeight;

  @override
  State<SmartAutoSuggestBox<T>> createState() => SmartAutoSuggestBoxState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<SmartAutoSuggestItem<T>>('items', items.value))
      ..add(
        ObjectFlagProperty<ValueChanged<SmartAutoSuggestItem<T>>?>(
          'onSelected',
          onSelected,
          ifNull: 'disabled',
        ),
      )
      ..add(
        FlagProperty(
          'clearButtonEnabled',
          value: clearButtonEnabled,
          defaultValue: true,
          ifFalse: 'clear button disabled',
        ),
      )
      ..add(
        FlagProperty(
          'enableKeyboardControls',
          value: enableKeyboardControls,
          defaultValue: true,
          ifFalse: 'keyboard controls disabled',
        ),
      )
      ..add(
        DoubleProperty(
          'maxPopupHeight',
          maxPopupHeight,
          defaultValue: kSmartAutoSuggestBoxPopupMaxHeight,
        ),
      );
  }

  /// The default item sorter.
  ///
  /// This sorter will filter the items based on their label.
  Set<SmartAutoSuggestItem<T>> defaultItemSorter(
    String text,
    Set<SmartAutoSuggestItem<T>> items,
  ) {
    text = text.trim();
    if (text.isEmpty) return items;

    return items.where((element) {
      return element.label.toLowerCase().contains(text.toLowerCase());
    }).toSet();
  }
}

class SmartAutoSuggestBoxState<T> extends State<SmartAutoSuggestBox<T>>
    with WidgetsBindingObserver {
  late FocusNode _focusNode = widget.focusNode ?? FocusNode();
  OverlayEntry? _entry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textBoxKey = GlobalKey(
    debugLabel: "SmartAutoSuggestBox's TextBox Key",
  );

  late TextEditingController _controller;
  late SmartAutoSuggestController<T>? _ownedSmartController;
  final FocusScopeNode _overlayNode = FocusScopeNode();
  final _focusStreamController = StreamController<int>.broadcast();

  /// Whether this state owns the DataSource (created internally for the
  /// deprecated `items` path) and must dispose it.
  bool _ownsDataSource = false;

  /// The effective data source. Either the user-provided one or an internal
  /// one for backward compatibility.
  late SmartAutoSuggestDataSource<T> _dataSource;

  SmartAutoSuggestSorter<T> get sorter =>
      widget.sorter ?? widget.defaultItemSorter;

  /// Returns the search text from the start of the input to the cursor position.
  String get _searchText {
    final text = _controller.text;
    final offset = _controller.selection.baseOffset;
    if (offset < 0 || offset > text.length) return text;
    return text.substring(0, offset);
  }

  /// The effective [SmartAutoSuggestController] for this widget.
  SmartAutoSuggestController<T>? get _smartController =>
      widget.smartController ?? _ownedSmartController;

  /// The size of the text box.
  ///
  /// Used to determine if the overlay needs to be updated when the text box size
  /// changes.
  Size _boxSize = Size.zero;

  /// Kept for backward compatibility with the deprecated `onNoResultsFound`.
  Timer? _debounceTimer;
  bool _autoScrollScheduled = false;

  /// Convenience accessors that delegate to DataSource.
  Set<SmartAutoSuggestItem<T>> get _localItems =>
      _dataSource.filteredItems.value;
  ValueNotifier<bool> get isLoading => _dataSource.isLoading;

  /// The currently selected item when [SmartAutoSuggestBox.selectedItemBuilder]
  /// is provided. When non-null, the custom widget is shown instead of the
  /// [TextField].
  SmartAutoSuggestItem<T>? get _selectedItem =>
      _smartController?.selectedItem.value;
  set _selectedItem(SmartAutoSuggestItem<T>? value) =>
      _smartController?.selectedItem.value = value;

  /// Clears the current selection and shows the [TextField] again.
  void clearSelection() {
    if (_selectedItem == null) return;
    _smartController?.clearSelection();
    widget.onChanged?.call('', FluentTextChangedReason.cleared);
    setState(() {});
  }

  void _updateLocalItems() {
    if (!mounted) return;
    _dataSource.filter(_searchText, sorter);
    setState(() {});
    if (isOverlayVisible) _autoSelectFirstItem();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Resolve controller: smartController > controller > create new
    if (widget.smartController != null) {
      _ownedSmartController = null;
      _controller = widget.smartController!.textController;
    } else if (widget.controller != null) {
      _ownedSmartController = null;
      _controller = widget.controller!;
    } else {
      _ownedSmartController = SmartAutoSuggestController<T>();
      _controller = _ownedSmartController!.textController;
    }

    // Resolve data source
    if (widget.dataSource != null) {
      _dataSource = widget.dataSource!;
      _ownsDataSource = false;
    } else {
      // Backward compatibility: wrap the deprecated `items` in a DataSource
      _dataSource = SmartAutoSuggestDataSource<T>(
        itemBuilder: (_, v) => throw StateError('unused'),
      );
      _dataSource.items.value = widget.items.value;
      _ownsDataSource = true;
    }
    _dataSource.activeSorter = sorter;

    // Listen to DataSource changes to rebuild overlay
    _dataSource.filteredItems.addListener(_onDataSourceChanged);
    _dataSource.isLoading.addListener(_onDataSourceChanged);

    _smartController?.selectedItem.addListener(_onSelectedItemChanged);

    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);

    _dataSource.filter(_searchText, sorter);

    // Update the overlay when the text box size has changed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final box = _textBoxKey.currentContext!.findRenderObject() as RenderBox;
      if (_boxSize != box.size) {
        dismissOverlay();
        _boxSize = box.size;
      }

      // Populate items from dataSource.initialList
      if (widget.dataSource != null) {
        _dataSource.initialize(context);
        _dataSource.filter(_searchText, sorter);
      }
    });
  }

  void _onDataSourceChanged() {
    if (!mounted) return;
    if (_entry?.mounted ?? false) {
      _entry?.markNeedsBuild();
    }
    setState(() {});
    if (isOverlayVisible) _autoSelectFirstItem();
  }

  void _onSelectedItemChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _debounceTimer?.cancel();
    _dataSource.filteredItems.removeListener(_onDataSourceChanged);
    _dataSource.isLoading.removeListener(_onDataSourceChanged);
    if (_ownsDataSource) _dataSource.dispose();
    _smartController?.selectedItem.removeListener(_onSelectedItemChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _controller.removeListener(_handleTextChanged);
    _focusStreamController.close();
    _unselectAll();

    // Dispose internally-created controller/focus node
    _ownedSmartController?.dispose();
    if (widget.smartController == null && widget.controller == null) {
      // already disposed via _ownedSmartController
    } else if (widget.smartController == null && widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) _focusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    if (_entry?.mounted ?? false) {
      _entry?.markNeedsBuild();
    }
  }

  @override
  void didUpdateWidget(covariant SmartAutoSuggestBox<T> oldWidget) {
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
    }

    // Handle smartController / controller changes
    if (widget.smartController != oldWidget.smartController ||
        widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleTextChanged);
      oldWidget.smartController?.selectedItem
          .removeListener(_onSelectedItemChanged);
      _ownedSmartController?.dispose();

      if (widget.smartController != null) {
        _ownedSmartController = null;
        _controller = widget.smartController!.textController;
      } else if (widget.controller != null) {
        _ownedSmartController = null;
        _controller = widget.controller!;
      } else {
        _ownedSmartController = SmartAutoSuggestController<T>();
        _controller = _ownedSmartController!.textController;
      }

      _controller.addListener(_handleTextChanged);
      _smartController?.selectedItem.addListener(_onSelectedItemChanged);
    }

    // Handle dataSource change (skip if same config, e.g. recreated inline)
    if (widget.dataSource != oldWidget.dataSource &&
        !(widget.dataSource != null &&
            oldWidget.dataSource != null &&
            _dataSource.hasSameConfig(widget.dataSource!))) {
      _dataSource.filteredItems.removeListener(_onDataSourceChanged);
      _dataSource.isLoading.removeListener(_onDataSourceChanged);
      if (_ownsDataSource) _dataSource.dispose();

      if (widget.dataSource != null) {
        _dataSource = widget.dataSource!;
        _ownsDataSource = false;
      } else {
        _dataSource = SmartAutoSuggestDataSource<T>(
          itemBuilder: (_, v) => throw StateError('unused'),
        );
        _dataSource.items.value = widget.items.value;
        _ownsDataSource = true;
      }
      _dataSource.activeSorter = sorter;
      _dataSource.filteredItems.addListener(_onDataSourceChanged);
      _dataSource.isLoading.addListener(_onDataSourceChanged);

      if (widget.dataSource?.initialList != null) {
        _dataSource.initialize(context);
      }
      _dataSource.filter(_searchText, sorter);
    } else if (widget.items != oldWidget.items && _ownsDataSource) {
      // Deprecated path: items changed externally
      _dataSource.items.value = widget.items.value;
      _updateLocalItems();
    }

    // Clear stale selection if selectedItemBuilder was removed
    if (widget.selectedItemBuilder == null &&
        oldWidget.selectedItemBuilder != null) {
      _selectedItem = null;
    }

    super.didUpdateWidget(oldWidget);
  }

  void _handleFocusChanged() {
    final hasFocus = _focusNode.hasFocus;
    if (!hasFocus) {
      dismissOverlay();
    } else if (_selectedItem == null) {
      showOverlay();
    }
    setState(() {});
  }

  void _handleTextChanged() {
    if (!mounted) return;
    if (_controller.text.length < 2) setState(() {});

    // Clear selected item when text is manually cleared
    if (_controller.text.isEmpty && _selectedItem != null) {
      _selectedItem = null;
    }

    _updateLocalItems();

    // If searchMode is always, trigger search on every text change
    if (_dataSource.searchMode == SmartAutoSuggestSearchMode.always &&
        _dataSource.onSearch != null) {
      _dataSource.scheduleSearch(context, _searchText.trim());
    }

    // Update the overlay after layout
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _updateLocalItems();
    });
  }

  /// Builds a unified search callback that handles both the new [dataSource]
  /// path and the deprecated [onNoResultsFound] path.
  Future Function(String text)? _buildSearchCallback() {
    // New data source path — delegate to DataSource
    if (_dataSource.onSearch != null) {
      return (text) async => _dataSource.search(context, text);
    }

    // Deprecated path - existing onNoResultsFound
    // ignore: deprecated_member_use_from_same_package
    if (widget.onNoResultsFound != null) {
      return (text) async {
        await Future.delayed(const Duration(milliseconds: 400));
        final currentText = _searchText.trim();
        if (currentText.isNotEmpty &&
            !_dataSource.lastSearchQuery.startsWith(currentText) &&
            text == currentText) {
          _dataSource.lastSearchQuery = currentText;
          isLoading.value = true;
          // ignore: deprecated_member_use_from_same_package
          final newItems = await widget.onNoResultsFound!(text).onError(
            (error, stackTrace) => [],
          );
          await Future.delayed(const Duration(milliseconds: 300));
          if (newItems.isNotEmpty) {
            _dataSource.addItems(newItems.toSet(), _searchText);
          }
          isLoading.value = false;
        }
      };
    }

    return null;
  }

  /// Whether the overlay is currently visible.
  bool get isOverlayVisible => _entry != null;

  SmartAutoSuggestBoxDirection _normalizeDirection(
    SmartAutoSuggestBoxDirection direction,
  ) {
    return switch (direction) {
      // ignore: deprecated_member_use_from_same_package
      SmartAutoSuggestBoxDirection.bottom =>
        SmartAutoSuggestBoxDirection.bottom,
      // ignore: deprecated_member_use_from_same_package
      SmartAutoSuggestBoxDirection.top => SmartAutoSuggestBoxDirection.top,
      _ => direction,
    };
  }

  ({
    Map<SmartAutoSuggestBoxDirection, double> extents,
    double verticalForHorizontal,
  })
  _calculateAvailableExtents({
    required Offset globalOffset,
    required Size boxSize,
    required Size screenSize,
    required EdgeInsets viewPadding,
    required EdgeInsets viewInsets,
    required bool isRtl,
  }) {
    final visibleTop = viewPadding.top;
    final visibleBottom =
        screenSize.height - math.max(viewPadding.bottom, viewInsets.bottom);
    final visibleLeft = viewPadding.left;
    final visibleRight = screenSize.width - viewPadding.right;

    double positive(double value) => value < 0 ? 0 : value;

    final spaceBelow = positive(
      visibleBottom - globalOffset.dy - boxSize.height,
    );
    final spaceAbove = positive(globalOffset.dy - visibleTop);
    final spaceStart = positive(
      isRtl
          ? visibleRight - globalOffset.dx - boxSize.width
          : globalOffset.dx - visibleLeft,
    );
    final spaceEnd = positive(
      isRtl
          ? globalOffset.dx - visibleLeft
          : visibleRight - globalOffset.dx - boxSize.width,
    );
    final spaceVertical = positive(visibleBottom - globalOffset.dy);

    return (
      extents: {
        SmartAutoSuggestBoxDirection.bottom: spaceBelow,
        SmartAutoSuggestBoxDirection.top: spaceAbove,
        SmartAutoSuggestBoxDirection.start: spaceStart,
        SmartAutoSuggestBoxDirection.end: spaceEnd,
      },
      verticalForHorizontal: spaceVertical,
    );
  }

  double _estimateDesiredPopupExtent() {
    final estimatedItems = _localItems.isEmpty ? 2 : _localItems.length;
    final estimatedPopupHeight = estimatedItems * widget.tileHeight + 12;
    return math.min(widget.maxPopupHeight, estimatedPopupHeight);
  }

  /// Resolves the preferred direction to the actual direction based on
  /// available screen space. Uses the preferred direction first when it can fit
  /// the estimated list size, otherwise falls back to the direction with the
  /// largest available space.
  SmartAutoSuggestBoxDirection _resolveDirection({
    required SmartAutoSuggestBoxDirection preferred,
    required Map<SmartAutoSuggestBoxDirection, double> extents,
    required double desiredPopupExtent,
    required Size boxSize,
  }) {
    final normalizedPreferred = _normalizeDirection(preferred);
    final preferredRequiredExtent = switch (normalizedPreferred) {
      SmartAutoSuggestBoxDirection.bottom => desiredPopupExtent,
      SmartAutoSuggestBoxDirection.top => desiredPopupExtent,
      SmartAutoSuggestBoxDirection.start => boxSize.width,
      SmartAutoSuggestBoxDirection.end => boxSize.width,
    };
    final preferredExtent = extents[normalizedPreferred] ?? 0.0;

    if (preferredExtent >= preferredRequiredExtent) {
      return normalizedPreferred;
    }

    var bestDirection = normalizedPreferred;
    var bestExtent = preferredExtent;
    for (final direction in SmartAutoSuggestBoxDirection.values) {
      final extent = extents[direction] ?? 0.0;
      if (extent > bestExtent) {
        bestExtent = extent;
        bestDirection = direction;
      }
    }
    return bestDirection;
  }

  double _maxExtent(Map<SmartAutoSuggestBoxDirection, double> extents) {
    var result = 0.0;
    for (final extent in extents.values) {
      if (extent > result) {
        result = extent;
      }
    }
    return result;
  }

  void _maybeAutoScrollForSpace({
    required double maxAvailableExtent,
    required double desiredPopupExtent,
  }) {
    if (_autoScrollScheduled || !isOverlayVisible || !_focusNode.hasFocus) {
      return;
    }

    final missingExtent = desiredPopupExtent - maxAvailableExtent;
    if (missingExtent < widget.tileHeight) {
      return;
    }

    final boxContext = _textBoxKey.currentContext;
    if (boxContext == null || Scrollable.maybeOf(boxContext) == null) {
      return;
    }

    _autoScrollScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _autoScrollScheduled = false;
      if (!mounted || !isOverlayVisible || !_focusNode.hasFocus) {
        return;
      }

      final textBoxContext = _textBoxKey.currentContext;
      if (textBoxContext == null ||
          Scrollable.maybeOf(textBoxContext) == null) {
        return;
      }

      try {
        await Scrollable.ensureVisible(
          textBoxContext,
          alignment: 0.05,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
        );
      } catch (_) {
        // ignore auto-scroll failures
      }

      if (_entry?.mounted ?? false) {
        _entry?.markNeedsBuild();
      }
    });
  }

  void _insertOverlay() {
    final overlayState = Overlay.of(
      context,
      rootOverlay: true,
      debugRequiredFor: widget,
    );

    _entry = OverlayEntry(
      builder: (context) {
        assert(debugCheckHasMediaQuery(context));

        final boxContext = _textBoxKey.currentContext;
        if (boxContext == null) return const SizedBox.shrink();
        final box = boxContext.findRenderObject() as RenderBox;

        final globalOffset = box.localToGlobal(
          Offset.zero,
          ancestor: overlayState.context.findRenderObject(),
        );

        final screenSize = MediaQuery.sizeOf(context);
        final viewPadding = MediaQuery.viewPaddingOf(context);
        final viewInsets = MediaQuery.viewInsetsOf(context);
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final available = _calculateAvailableExtents(
          globalOffset: globalOffset,
          boxSize: box.size,
          screenSize: screenSize,
          viewPadding: viewPadding,
          viewInsets: viewInsets,
          isRtl: isRtl,
        );
        final desiredPopupExtent = _estimateDesiredPopupExtent();

        final resolvedDirection = _resolveDirection(
          preferred: widget.direction,
          extents: available.extents,
          desiredPopupExtent: desiredPopupExtent,
          boxSize: box.size,
        );
        _maybeAutoScrollForSpace(
          maxAvailableExtent: _maxExtent(available.extents),
          desiredPopupExtent: desiredPopupExtent,
        );

        final bool isVertical =
            resolvedDirection == SmartAutoSuggestBoxDirection.bottom ||
            resolvedDirection == SmartAutoSuggestBoxDirection.top;

        // Calculate max height based on resolved direction
        double maxHeight;
        double overlayWidth;
        Alignment targetAnchor;
        Alignment followerAnchor;
        Offset offset;

        if (isVertical) {
          overlayWidth = box.size.width;
          if (resolvedDirection == SmartAutoSuggestBoxDirection.bottom) {
            final spaceBelow =
                available.extents[SmartAutoSuggestBoxDirection.bottom] ?? 0.0;
            maxHeight = spaceBelow.clamp(0.0, widget.maxPopupHeight).toDouble();
            targetAnchor = Alignment.bottomCenter;
            followerAnchor = Alignment.topCenter;
            offset = widget.offset ?? const Offset(0, 0.8);
          } else {
            final spaceAbove =
                available.extents[SmartAutoSuggestBoxDirection.top] ?? 0.0;
            maxHeight = spaceAbove.clamp(0.0, widget.maxPopupHeight).toDouble();
            targetAnchor = Alignment.topCenter;
            followerAnchor = Alignment.bottomCenter;
            offset = widget.offset ?? const Offset(0, -0.8);
          }
        } else {
          // Horizontal: start or end
          maxHeight = available.verticalForHorizontal
              .clamp(0.0, widget.maxPopupHeight)
              .toDouble();
          final minWidth = math.min(100.0, box.size.width);

          if (resolvedDirection == SmartAutoSuggestBoxDirection.start) {
            final spaceStart =
                available.extents[SmartAutoSuggestBoxDirection.start] ?? 0.0;
            overlayWidth = spaceStart
                .clamp(minWidth, box.size.width)
                .toDouble();
            targetAnchor = isRtl ? Alignment.centerRight : Alignment.centerLeft;
            followerAnchor = isRtl
                ? Alignment.centerLeft
                : Alignment.centerRight;
            offset = widget.offset ?? Offset(isRtl ? 0.8 : -0.8, 0);
          } else {
            final spaceEnd =
                available.extents[SmartAutoSuggestBoxDirection.end] ?? 0.0;
            overlayWidth = spaceEnd.clamp(minWidth, box.size.width).toDouble();
            targetAnchor = isRtl ? Alignment.centerLeft : Alignment.centerRight;
            followerAnchor = isRtl
                ? Alignment.centerRight
                : Alignment.centerLeft;
            offset = widget.offset ?? Offset(isRtl ? -0.8 : 0.8, 0);
          }
        }

        Widget child = PositionedDirectional(
          width: overlayWidth,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            offset: offset,
            child: SizedBox(
              width: overlayWidth,
              child: _SmartAutoSuggestBoxOverlay<T>(
                theme: widget.theme,
                waitingBuilder: widget.waitingBuilder,
                tileHeight: widget.tileHeight,
                direction: resolvedDirection,
                dataSource: _dataSource,
                maxHeight: maxHeight,
                node: _overlayNode,
                controller: _controller,
                itemBuilder: widget.itemBuilder,
                focusStream: _focusStreamController.stream,
                sorter: sorter,
                onSelected: (SmartAutoSuggestItem<T> item) {
                  item.onSelected?.call();
                  widget.onSelected?.call(item);
                  _smartController?.select(item);
                  widget.onChanged?.call(
                    item.label,
                    FluentTextChangedReason.suggestionChosen,
                  );
                  dismissOverlay();
                  _focusNode.unfocus();
                },
                noResultsFoundBuilder: widget.noResultsFoundBuilder,
                onNoResultsFound: _buildSearchCallback(),
              ),
            ),
          ),
        );

        return child;
      },
    );

    if (_textBoxKey.currentContext != null) {
      overlayState.insert(_entry!);
      if (mounted) setState(() {});
    }
  }

  void dismissOverlay() {
    _entry?.remove();
    _entry = null;
    _unselectAll();
    widget.onOverlayVisibilityChanged?.call(isOverlayVisible);
  }

  void showOverlay() {
    if (_entry == null && !(_entry?.mounted ?? false)) {
      _insertOverlay();
      widget.onOverlayVisibilityChanged?.call(isOverlayVisible);
      _autoSelectFirstItem();
    }
  }

  /// On desktop platforms, automatically focus the first item when
  /// the overlay opens so the user can navigate with arrow keys
  /// and confirm with Enter right away.
  void _autoSelectFirstItem() {
    if (!widget.enableKeyboardControls || !isDesktopPlatform) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final items = _localItems.toList();
      if (items.isEmpty) return;
      _unselectAll();
      items.first.selected = true;
      _focusStreamController.add(0);
    });
  }

  /// Selects the item at [index] and scrolls the overlay to it.
  void _selectItem(int index) {
    _unselectAll();
    (_localItems.elementAt(index)).selected = true;
    _focusStreamController.add(index);
  }

  void _unselectAll() {
    for (final item in _dataSource.items.value) {
      item.selected = false;
    }
  }

  void _onChanged(String text) {
    widget.onChanged?.call(text, FluentTextChangedReason.userInput);
    showOverlay();
  }

  void _onSubmitted(List<SmartAutoSuggestItem<T>> localItemsList) {
    final currentlySelectedIndex = localItemsList.indexWhere(
      (item) => item.selected,
    );
    if (currentlySelectedIndex.isNegative) return;

    final item = localItemsList[currentlySelectedIndex];
    widget.onSelected?.call(item);
    item.onSelected?.call();

    _smartController?.select(item);
    widget.onChanged?.call(
      _controller.text,
      FluentTextChangedReason.suggestionChosen,
    );
  }

  /// Whether a [TextFormBox] is used instead of a [TextBox]
  bool get isForm => widget.validator != null;

  double? _width;

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Focus(
        skipTraversal: true,
        onKeyEvent: (node, event) {
          if (!(event is KeyDownEvent || event is KeyRepeatEvent) ||
              !widget.enableKeyboardControls) {
            return KeyEventResult.ignored;
          }

          if (event.logicalKey == LogicalKeyboardKey.escape) {
            dismissOverlay();
            return KeyEventResult.handled;
          }
          final localItemsList = _localItems.toList();
          if (localItemsList.isEmpty) return KeyEventResult.ignored;

          final currentlySelectedIndex = localItemsList.indexWhere(
            (item) => item.selected,
          );

          final lastIndex = localItemsList.length - 1;

          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            if (currentlySelectedIndex == -1 ||
                currentlySelectedIndex == lastIndex) {
              _selectItem(0);
            } else {
              _selectItem(currentlySelectedIndex + 1);
            }
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            if (currentlySelectedIndex == -1 || currentlySelectedIndex == 0) {
              _selectItem(localItemsList.length - 1);
            } else {
              _selectItem(currentlySelectedIndex - 1);
            }
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            _onSubmitted(localItemsList);
            return KeyEventResult.handled;
          } else {
            return KeyEventResult.ignored;
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            _width ??= constraints.maxWidth;
            if (_width! != constraints.maxWidth) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_entry != null && _entry!.mounted) {
                  _entry!.remove();
                  _entry = null;
                  showOverlay();
                }
              });
              _width = constraints.maxWidth;
            }
            final decoration = (widget.decoration ?? const InputDecoration())
                .copyWith(
                  suffixIcon:
                      widget.decoration?.suffixIcon ??
                      const Icon(Icons.arrow_drop_down),
                );

            // When selectedItemBuilder is provided and an item is selected,
            // show the custom widget instead of the TextField.
            if (widget.selectedItemBuilder != null && _selectedItem != null) {
              return GestureDetector(
                onTap: () {
                  clearSelection();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _focusNode.requestFocus();
                  });
                },
                child: widget.selectedItemBuilder!(context, _selectedItem!),
              );
            }

            if (isForm) {
              return TextFormField(
                // onEditingComplete: () => _focusNode.nextFocus(),
                key: _textBoxKey,
                controller: _controller,
                focusNode: _focusNode,
                autofocus: widget.autofocus,

                clipBehavior: Clip.antiAliasWithSaveLayer,
                onChanged: _onChanged,
                onFieldSubmitted: (text) {
                  _onSubmitted(_localItems.toList());
                  dismissOverlay();
                },
                style: widget.style,
                decoration: decoration,
                cursorColor: widget.cursorColor,
                cursorHeight: widget.cursorHeight,
                cursorRadius: widget.cursorRadius,
                cursorWidth: widget.cursorWidth,
                showCursor: widget.showCursor,
                scrollPadding: widget.scrollPadding,
                selectionHeightStyle: widget.selectionHeightStyle,
                selectionWidthStyle: widget.selectionWidthStyle,
                validator: widget.validator,
                autovalidateMode: widget.autovalidateMode,
                textInputAction: widget.textInputAction,
                keyboardAppearance: widget.keyboardAppearance,
                enabled: widget.enabled,
                inputFormatters: widget.inputFormatters,
                keyboardType: widget.keyboardType,
                maxLength: widget.maxLength,
                onTapOutside: (event) => _focusNode.unfocus(),
              );
            }
            return TextField(
              key: _textBoxKey,
              controller: _controller,
              focusNode: _focusNode,
              autofocus: widget.autofocus,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              onChanged: _onChanged,
              onSubmitted: (text) {
                _onSubmitted(_localItems.toList());
                dismissOverlay();
              },
              style: widget.style,
              decoration: decoration,
              cursorColor: widget.cursorColor,
              cursorHeight: widget.cursorHeight,
              cursorRadius: widget.cursorRadius,
              cursorWidth: widget.cursorWidth,
              showCursor: widget.showCursor,
              scrollPadding: widget.scrollPadding,
              selectionHeightStyle: widget.selectionHeightStyle,
              selectionWidthStyle: widget.selectionWidthStyle,
              textInputAction: widget.textInputAction,
              keyboardAppearance: widget.keyboardAppearance,
              enabled: widget.enabled,
              inputFormatters: widget.inputFormatters,
              keyboardType: widget.keyboardType,
              maxLength: widget.maxLength,
              onTapOutside: (event) => _focusNode.unfocus(),
            );
          },
        ),
      ),
    );
  }
}

class _SmartAutoSuggestBoxOverlay<T> extends StatefulWidget {
  const _SmartAutoSuggestBoxOverlay({
    super.key,
    required this.dataSource,
    required this.itemBuilder,
    required this.controller,
    required this.onSelected,
    required this.node,
    required this.focusStream,
    required this.sorter,
    required this.maxHeight,
    required this.noResultsFoundBuilder,
    this.theme,
    this.onNoResultsFound,
    this.tileHeight = kComboBoxItemHeight,
    this.waitingBuilder,
    this.direction = SmartAutoSuggestBoxDirection.bottom,
    this.multiSelectController,
    this.maxSelections,
  });

  final SmartAutoSuggestTheme? theme;
  final SmartAutoSuggestDataSource<T> dataSource;
  final SmartAutoSuggestItemBuilder<T>? itemBuilder;
  final TextEditingController controller;
  final ValueChanged<SmartAutoSuggestItem<T>> onSelected;
  final FocusScopeNode node;
  final Stream<int> focusStream;
  final SmartAutoSuggestSorter<T> sorter;
  final double maxHeight;
  final WidgetOrNullBuilder? noResultsFoundBuilder;
  final Future Function(String text)? onNoResultsFound;
  final double tileHeight;
  final Widget Function(BuildContext context)? waitingBuilder;
  final SmartAutoSuggestBoxDirection direction;
  final SmartAutoSuggestMultiSelectController<T>? multiSelectController;
  final int? maxSelections;

  @override
  State<_SmartAutoSuggestBoxOverlay<T>> createState() =>
      _SmartAutoSuggestBoxOverlayState<T>();
}

class _SmartAutoSuggestBoxOverlayState<T>
    extends State<_SmartAutoSuggestBoxOverlay<T>> {
  late final StreamSubscription focusSubscription;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    focusSubscription = widget.focusStream.listen((index) {
      if (!mounted) return;

      final currentSelectedOffset = widget.tileHeight * index;

      scrollController.animateTo(
        currentSelectedOffset,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
      setState(() {});
    });
    // Listen to DataSource changes to rebuild overlay
    widget.dataSource.filteredItems.addListener(_onDataChanged);
    widget.dataSource.isLoading.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    focusSubscription.cancel();
    widget.dataSource.filteredItems.removeListener(_onDataChanged);
    widget.dataSource.isLoading.removeListener(_onDataChanged);
    scrollController.dispose();
    super.dispose();
  }

  EdgeInsetsGeometry _resolveMargin(
    SmartAutoSuggestBoxDirection direction,
    double margin,
  ) {
    switch (direction) {
      case SmartAutoSuggestBoxDirection.top:
        return EdgeInsetsDirectional.only(
          start: margin,
          end: margin,
          bottom: margin,
        );
      case SmartAutoSuggestBoxDirection.start:
        return EdgeInsetsDirectional.only(
          top: margin,
          bottom: margin,
          end: margin,
        );
      case SmartAutoSuggestBoxDirection.end:
        return EdgeInsetsDirectional.only(
          top: margin,
          bottom: margin,
          start: margin,
        );
      case SmartAutoSuggestBoxDirection.bottom:
        return EdgeInsetsDirectional.only(
          start: margin,
          end: margin,
          top: margin,
        );
    }
  }

  BorderRadiusGeometry _resolveBorderRadius(
    SmartAutoSuggestBoxDirection direction,
    BorderRadius radius,
  ) {
    final r = radius.topLeft;
    switch (direction) {
      case SmartAutoSuggestBoxDirection.bottom:
        return BorderRadiusDirectional.vertical(bottom: r);
      case SmartAutoSuggestBoxDirection.top:
        return BorderRadiusDirectional.vertical(top: r);
      case SmartAutoSuggestBoxDirection.start:
        return BorderRadiusDirectional.horizontal(end: r);
      case SmartAutoSuggestBoxDirection.end:
        return BorderRadiusDirectional.horizontal(start: r);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final sat = widget.theme ?? appTheme.extension<SmartAutoSuggestTheme>();

    final overlayColor = sat?.overlayColor ?? appTheme.colorScheme.surface;
    final overlayShadows =
        sat?.overlayShadows ??
        [
          BoxShadow(
            color: appTheme.colorScheme.shadow.withAlpha((255 * .1).toInt()),
            offset: const Offset(-1, 3),
            blurRadius: 2.0,
            spreadRadius: 3.0,
          ),
          BoxShadow(
            color: appTheme.colorScheme.shadow.withAlpha((255 * .15).toInt()),
            offset: const Offset(1, 3),
            blurRadius: 2.0,
            spreadRadius: 3.0,
          ),
        ];
    final overlayBorderRadius =
        sat?.overlayBorderRadius ?? BorderRadius.circular(4.0);
    final overlayMargin = sat?.overlayMargin ?? 8.0;
    final cardColor = sat?.overlayCardColor ?? appTheme.cardTheme.color;
    final dividerIndent = sat?.dividerIndent ?? 12.0;
    final loadingStyle =
        sat?.loadingSubtitleStyle ??
        TextStyle(fontSize: 14.0, color: appTheme.colorScheme.outline);
    final noResultsStyle =
        sat?.noResultsSubtitleStyle ??
        appTheme.textTheme.bodySmall?.copyWith(
          color: appTheme.colorScheme.outline,
        );
    final progressHeight = sat?.progressIndicatorHeight ?? 4.0;
    final progressColor = sat?.progressIndicatorColor;
    final disabledColor =
        sat?.disabledItemColor ?? appTheme.colorScheme.outline;
    final tilePadding =
        sat?.tilePadding ?? const EdgeInsets.only(left: 4, right: 4, top: 4);
    final tileColor = sat?.tileColor ?? appTheme.colorScheme.surface;
    final selectedTileColor =
        sat?.selectedTileColor ?? appTheme.colorScheme.primaryContainer;
    final selectedTileTextColor =
        sat?.selectedTileTextColor ?? appTheme.colorScheme.onPrimaryContainer;
    final tileSubtitleStyle =
        sat?.tileSubtitleStyle ??
        appTheme.textTheme.bodySmall?.copyWith(
          color: appTheme.colorScheme.outline,
        );

    return TextFieldTapRegion(
      child: FocusScope(
        node: widget.node,
        child: Container(
          margin: _resolveMargin(widget.direction, overlayMargin),
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: overlayColor,
            shape: RoundedRectangleBorder(
              borderRadius: _resolveBorderRadius(
                widget.direction,
                overlayBorderRadius,
              ),
            ),
            shadows: overlayShadows,
          ),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Container(
              color: cardColor,
              child: Builder(
                builder: (context) {
                  final tr = SmartAutoSuggestBoxLocalizations.of(context);
                  if (widget.dataSource.isLoading.value) {
                    return widget.waitingBuilder?.call(context) ??
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: progressHeight,
                              child: LinearProgressIndicator(
                                color: progressColor,
                              ),
                            ),
                            ListTile(
                              title: Text(tr.searchingInServer),
                              subtitle: Text(tr.searchingInServerHint),
                              subtitleTextStyle: loadingStyle,
                            ),
                          ],
                        );
                  }
                  final search = widget.controller.value;
                  final cursorOffset = search.selection.baseOffset;
                  final textToCursor =
                      (cursorOffset >= 0 && cursorOffset <= search.text.length)
                          ? search.text.substring(0, cursorOffset)
                          : search.text;
                  final searchValue = textToCursor.trim();
                  {
                    final sortedItems = widget.dataSource.filteredItems.value;

                          if (searchValue.isNotEmpty && sortedItems.isEmpty) {
                            widget.onNoResultsFound?.call(searchValue);
                          }
                          late Widget result;
                          if (sortedItems.isEmpty) {
                            var children = [
                              if (widget.noResultsFoundBuilder != null) ...[
                                Gap(8),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: widget.noResultsFoundBuilder?.call(
                                    context,
                                  ),
                                ),
                                Divider(
                                  endIndent: dividerIndent,
                                  indent: dividerIndent,
                                ),
                              ] else
                                SizedBox(height: 4),
                              ListTile(
                                title: Text(tr.noResultsFound),
                                subtitle: Text(tr.noResultsFoundHint),
                                subtitleTextStyle: noResultsStyle,
                              ),
                            ];
                            result = Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  widget.direction ==
                                          SmartAutoSuggestBoxDirection.top ||
                                      // ignore: deprecated_member_use_from_same_package
                                      widget.direction ==
                                          SmartAutoSuggestBoxDirection.top
                                  ? children.reversed.toList()
                                  : children,
                            );
                          } else {
                            result = Scrollbar(
                              controller: scrollController,
                              thumbVisibility: true,
                              child: ListView.builder(
                                itemExtent: widget.tileHeight,
                                controller: scrollController,
                                key: ValueKey<int>(sortedItems.length),
                                shrinkWrap: true,
                                padding: const EdgeInsetsDirectional.only(
                                  bottom: 4.0,
                                ),
                                itemCount: sortedItems.length,
                                itemBuilder: (context, index) {
                                  final item = sortedItems.elementAt(index);
                                  if (widget.itemBuilder != null) {
                                    return widget.itemBuilder!(context, item);
                                  }

                                  // Multi-select state
                                  final isMultiSelect =
                                      widget.multiSelectController != null;
                                  final isItemSelected = isMultiSelect &&
                                      widget.multiSelectController!
                                          .isSelected(item);
                                  final atMax = isMultiSelect &&
                                      widget.maxSelections != null &&
                                      widget.multiSelectController!
                                              .selectedItems.value.length >=
                                          widget.maxSelections!;
                                  final isDisabled = !item.enabled ||
                                      (atMax && !isItemSelected);

                                  if (item.builder != null) {
                                    return GestureDetector(
                                      onTap: isDisabled
                                          ? null
                                          : () => widget.onSelected(item),
                                      child: Focus(
                                        child: item.builder!(
                                          context,
                                          searchValue,
                                        ),
                                      ),
                                    );
                                  }
                                  return SmartAutoSuggestBoxOverlayTile(
                                    subtitle: null,
                                    title: DefaultTextStyle.merge(
                                      child: item.child ??
                                          SmartAutoSuggestHighlightText(
                                            text: item.label,
                                            query: searchValue,
                                          ),
                                      style: isDisabled
                                          ? TextStyle(color: disabledColor)
                                          : null,
                                    ),
                                    semanticLabel:
                                        item.semanticLabel ?? item.label,
                                    selected: isItemSelected ||
                                        item.selected ||
                                        widget.node.hasFocus,
                                    onSelected: isDisabled
                                        ? null
                                        : () => widget.onSelected(item),
                                    trailing: isItemSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 18,
                                            color: selectedTileTextColor,
                                          )
                                        : null,
                                    tileColor: tileColor,
                                    selectedTileColor: selectedTileColor,
                                    selectedTileTextColor:
                                        selectedTileTextColor,
                                    tilePadding: tilePadding,
                                    tileSubtitleStyle: tileSubtitleStyle,
                                  );
                                },
                              ),
                            );
                          }
                    return result;
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SmartAutoSuggestBoxOverlayTile extends StatefulWidget {
  const SmartAutoSuggestBoxOverlayTile({
    required this.title,
    required this.subtitle,
    this.selected = false,
    this.onSelected,
    this.semanticLabel,
    this.tileColor,
    this.selectedTileColor,
    this.selectedTileTextColor,
    this.tilePadding,
    this.tileSubtitleStyle,
    this.trailing,
  });

  final Color? tileColor;
  final Color? selectedTileColor;
  final Color? selectedTileTextColor;
  final EdgeInsetsGeometry? tilePadding;
  final TextStyle? tileSubtitleStyle;
  final Widget title;
  final Widget? subtitle;
  final VoidCallback? onSelected;
  final bool selected;
  final String? semanticLabel;
  final Widget? trailing;

  @override
  State<SmartAutoSuggestBoxOverlayTile> createState() =>
      _SmartAutoSuggestBoxOverlayTileState();
}

class _SmartAutoSuggestBoxOverlayTileState
    extends State<SmartAutoSuggestBoxOverlayTile>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 125),
    );
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding:
          widget.tilePadding ??
          const EdgeInsets.only(left: 4, right: 4, top: 4),
      child: ListTile(
        tileColor: widget.tileColor ?? theme.colorScheme.surface,
        selectedTileColor:
            widget.selectedTileColor ?? theme.colorScheme.primaryContainer,
        selectedColor:
            widget.selectedTileTextColor ??
            theme.colorScheme.onPrimaryContainer,
        title: FadeTransition(
          opacity: Tween<double>(
            begin: 0.75,
            end: 1.0,
          ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
          child: widget.title,
        ),
        subtitle: widget.subtitle == null
            ? null
            : FadeTransition(
                opacity: Tween<double>(begin: 0.75, end: 1.0).animate(
                  CurvedAnimation(parent: controller, curve: Curves.easeOut),
                ),
                child: widget.subtitle,
              ),
        selected: widget.selected,
        onTap: widget.onSelected,
        trailing: widget.trailing,
        subtitleTextStyle:
            widget.tileSubtitleStyle ??
            theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
      ),
    );
  }
}
