part of '../../smart_auto_suggest_view.dart';

/// A widget that shows a [TextField] and, directly below it in the normal
/// widget tree, an inline suggestion list.
///
/// Unlike [SmartAutoSuggestBox] - which shows suggestions in a floating
/// [Overlay] - [SmartAutoSuggestView] embeds both the text field and the
/// list inside the same layout, making it suitable for search screens,
/// filter panels, or any context where you want suggestions to occupy
/// real screen space.
///
/// ```dart
/// SmartAutoSuggestView<String>(
///   dataSource: SmartAutoSuggestDataSource(
///     itemBuilder: (context, value) => SmartAutoSuggestItem(
///       value: value,
///       label: value,
///     ),
///     initialList: (context) => ['apple', 'banana'],
///     onSearch: (context, current, text) async => await api.search(text),
///   ),
///   decoration: const InputDecoration(
///     labelText: 'Search',
///     border: OutlineInputBorder(),
///   ),
///   onSelected: (item) => print(item?.label),
/// )
/// ```
class SmartAutoSuggestView<T> extends StatefulWidget {
  /// Creates an inline auto-suggest view.
  const SmartAutoSuggestView({
    super.key,
    this.dataSource,
    @Deprecated('Use smartController instead') this.controller,
    this.smartController,
    this.onChanged,
    this.onSelected,
    this.itemBuilder,
    this.noResultsFoundBuilder,
    this.sorter,
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
    this.listMaxHeight = kSmartAutoSuggestBoxPopupMaxHeight,
    this.waitingBuilder,
    this.tileHeight = kComboBoxItemHeight,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.showListWhenEmpty = true,
    this.theme,
  }) : autovalidateMode = AutovalidateMode.disabled,
       validator = null;

  /// Creates an inline auto-suggest view with form validation support.
  const SmartAutoSuggestView.form({
    super.key,
    this.dataSource,
    @Deprecated('Use smartController instead') this.controller,
    this.smartController,
    this.onChanged,
    this.onSelected,
    this.itemBuilder,
    this.noResultsFoundBuilder,
    this.sorter,
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
    this.listMaxHeight = kSmartAutoSuggestBoxPopupMaxHeight,
    this.waitingBuilder,
    this.tileHeight = kComboBoxItemHeight,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.showListWhenEmpty = true,
    this.theme,
  });

  /// Optional theme override for this widget.
  ///
  /// If null, the widget will use [SmartAutoSuggestTheme] from the nearest
  /// [Theme], or fall back to system defaults.
  final SmartAutoSuggestTheme? theme;

  // ── Data ──────────────────────────────────────────────────────────────────

  /// The data source for providing items and async search.
  final SmartAutoSuggestDataSource<T>? dataSource;

  // ── Callbacks ─────────────────────────────────────────────────────────────

  /// Called when the text changes.
  final OnChangeSmartAutoSuggestBox? onChanged;

  /// Called when the user selects a suggestion.
  final ValueChanged<SmartAutoSuggestItem<T>?>? onSelected;

  // ── Builders ──────────────────────────────────────────────────────────────

  /// Custom item widget builder. Falls back to the default tile.
  final SmartAutoSuggestItemBuilder<T>? itemBuilder;

  /// Widget shown when no results match the current query.
  final WidgetOrNullBuilder? noResultsFoundBuilder;

  /// Custom loading UI shown while [SmartAutoSuggestDataSource.onSearch] runs.
  final Widget Function(BuildContext context)? waitingBuilder;

  // ── Sorting ───────────────────────────────────────────────────────────────

  /// Custom sorter/filter. Defaults to case-insensitive label contains-match.
  final SmartAutoSuggestSorter<T>? sorter;

  // ── Text field ────────────────────────────────────────────────────────────

  /// Controls the text being edited.
  ///
  /// Deprecated: Use [smartController] instead.
  @Deprecated('Use smartController instead')
  final TextEditingController? controller;

  /// A unified controller that provides access to both the text input and the
  /// currently selected item.
  ///
  /// When provided, [controller] is ignored.
  final SmartAutoSuggestController<T>? smartController;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// Controls the [InputDecoration] of the text field.
  final InputDecoration? decoration;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  final double? cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius cursorRadius;

  /// The color of the cursor.
  final Color? cursorColor;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// The appearance of the keyboard (iOS only).
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// Controls how tall the selection highlight boxes are computed to be.
  final ui.BoxHeightStyle selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  final ui.BoxWidthStyle selectionWidthStyle;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Whether keyboard navigation (arrow keys, Enter, Escape) is enabled.
  final bool enableKeyboardControls;

  /// Whether the text field is enabled.
  final bool enabled;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// Keyboard type. Defaults to [TextInputType.text].
  final TextInputType keyboardType;

  /// Maximum number of characters in the text field.
  final int? maxLength;

  // ── List ──────────────────────────────────────────────────────────────────

  /// Maximum height of the inline suggestion list. Defaults to 380px.
  final double listMaxHeight;

  /// Height of each suggestion tile. Defaults to [kComboBoxItemHeight] (50px).
  final double tileHeight;

  /// Whether to show the list when the text field is empty.
  ///
  /// When `true` (default) the list is always visible (showing all items).
  /// When `false` the list is hidden until the user starts typing.
  final bool showListWhenEmpty;

  // ── Form ──────────────────────────────────────────────────────────────────

  /// Validation callback (only used in [SmartAutoSuggestView.form]).
  final FormFieldValidator<String>? validator;

  /// Auto-validate mode (only used in [SmartAutoSuggestView.form]).
  final AutovalidateMode autovalidateMode;

  // ─────────────────────────────────────────────────────────────────────────

  @override
  State<SmartAutoSuggestView<T>> createState() =>
      SmartAutoSuggestViewState<T>();

  /// Default item sorter: case-insensitive label contains-match.
  Set<SmartAutoSuggestItem<T>> defaultItemSorter(
    String text,
    Set<SmartAutoSuggestItem<T>> items,
  ) {
    text = text.trim();
    if (text.isEmpty) return items;
    return items.where((e) {
      return e.label.toLowerCase().contains(text.toLowerCase());
    }).toSet();
  }
}

class SmartAutoSuggestViewState<T> extends State<SmartAutoSuggestView<T>> {
  late FocusNode _focusNode = widget.focusNode ?? FocusNode();
  final GlobalKey _textBoxKey = GlobalKey(
    debugLabel: "SmartAutoSuggestView's TextBox Key",
  );

  late TextEditingController _controller;
  late SmartAutoSuggestController<T>? _ownedSmartController;
  final FocusScopeNode _overlayNode = FocusScopeNode();
  final _focusStreamController = StreamController<int>.broadcast();

  SmartAutoSuggestSorter<T> get sorter =>
      widget.sorter ?? widget.defaultItemSorter;

  /// The effective [SmartAutoSuggestController] for this widget.
  SmartAutoSuggestController<T>? get _smartController =>
      widget.smartController ?? _ownedSmartController;

  /// Returns the search text from the start of the input to the cursor position.
  String get _searchText {
    final text = _controller.text;
    final offset = _controller.selection.baseOffset;
    if (offset < 0 || offset > text.length) return text;
    return text.substring(0, offset);
  }

  /// Whether this state owns the DataSource and must dispose it.
  bool _ownsDataSource = false;

  /// The effective data source.
  late SmartAutoSuggestDataSource<T> _dataSource;

  /// Convenience accessors that delegate to DataSource.
  Set<SmartAutoSuggestItem<T>> get _localItems =>
      _dataSource.filteredItems.value;
  ValueNotifier<bool> get isLoading => _dataSource.isLoading;

  void _updateLocalItems() {
    if (!mounted) return;
    _dataSource.filter(_searchText, sorter);
    setState(() {});
    _autoSelectFirstItem();
  }

  @override
  void initState() {
    super.initState();

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
      _dataSource = SmartAutoSuggestDataSource<T>(
        itemBuilder: (_, v) => throw StateError('unused'),
      );
      _ownsDataSource = true;
    }
    _dataSource.activeSorter = sorter;

    _dataSource.filteredItems.addListener(_onDataSourceChanged);
    _dataSource.isLoading.addListener(_onDataSourceChanged);
    _dataSource.errorMessage.addListener(_onDataSourceChanged);

    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.dataSource != null) {
        _dataSource.initialize(context);
        _dataSource.filter(_searchText, sorter);
        _scheduleSearchForNoLocalResults();
      }
    });
  }

  void _onDataSourceChanged() {
    if (!mounted) return;
    setState(() {});
    _autoSelectFirstItem();
  }

  @override
  void dispose() {
    _dataSource.filteredItems.removeListener(_onDataSourceChanged);
    _dataSource.isLoading.removeListener(_onDataSourceChanged);
    _dataSource.errorMessage.removeListener(_onDataSourceChanged);
    if (_ownsDataSource) _dataSource.dispose();
    _focusNode.removeListener(_handleFocusChanged);
    _controller.removeListener(_handleTextChanged);
    _focusStreamController.close();
    _unselectAll();
    _ownedSmartController?.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SmartAutoSuggestView<T> oldWidget) {
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
    }
    // Handle smartController / controller changes
    if (widget.smartController != oldWidget.smartController ||
        widget.controller != oldWidget.controller) {
      _controller.removeListener(_handleTextChanged);
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
    }
    // Handle dataSource change (skip if same config, e.g. recreated inline)
    if (widget.dataSource != oldWidget.dataSource &&
        !(widget.dataSource != null &&
            oldWidget.dataSource != null &&
            _dataSource.hasSameConfig(widget.dataSource!))) {
      _dataSource.filteredItems.removeListener(_onDataSourceChanged);
      _dataSource.isLoading.removeListener(_onDataSourceChanged);
      _dataSource.errorMessage.removeListener(_onDataSourceChanged);
      if (_ownsDataSource) _dataSource.dispose();

      if (widget.dataSource != null) {
        _dataSource = widget.dataSource!;
        _ownsDataSource = false;
      } else {
        _dataSource = SmartAutoSuggestDataSource<T>(
          itemBuilder: (_, v) => throw StateError('unused'),
        );
        _ownsDataSource = true;
      }
      _dataSource.activeSorter = sorter;
      _dataSource.filteredItems.addListener(_onDataSourceChanged);
      _dataSource.isLoading.addListener(_onDataSourceChanged);
      _dataSource.errorMessage.addListener(_onDataSourceChanged);

      if (widget.dataSource?.initialList != null) {
        _dataSource.initialize(context);
      }
      _dataSource.filter(_searchText, sorter);
      _scheduleSearchForNoLocalResults();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _handleFocusChanged() => setState(() {});

  void _handleTextChanged() {
    if (!mounted) return;
    _updateLocalItems();
    _scheduleSearchForNoLocalResults();

    // searchMode.always: debounce-trigger search on every keystroke
    if (_dataSource.searchMode == SmartAutoSuggestSearchMode.always &&
        _dataSource.onSearch != null) {
      _dataSource.scheduleSearch(context, _searchText.trim());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateLocalItems();
    });
  }

  void _scheduleSearchForNoLocalResults() {
    if (_dataSource.searchMode != SmartAutoSuggestSearchMode.onNoLocalResults) {
      return;
    }

    final searchCallback = _buildSearchCallback();
    final searchText = _searchText.trim();
    if (searchCallback == null ||
        searchText.isEmpty ||
        _localItems.isNotEmpty ||
        isLoading.value) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final currentSearchText = _searchText.trim();
      if (currentSearchText != searchText ||
          _localItems.isNotEmpty ||
          isLoading.value) {
        return;
      }

      unawaited(searchCallback(searchText));
    });
  }

  /// On desktop platforms, automatically focus the first item so the user
  /// can navigate with arrow keys and confirm with Enter right away.
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

  /// Selects the item at [index] and scrolls the list to it.
  void _selectItem(int index) {
    _unselectAll();
    (_localItems.elementAt(index)).selected = true;
    _focusStreamController.add(index);
    setState(() {});
  }

  void _unselectAll() {
    for (final item in _dataSource.items.value) {
      item.selected = false;
    }
  }

  /// Search callback — delegates to DataSource.
  Future Function(String text)? _buildSearchCallback() {
    if (_dataSource.onSearch != null) {
      return (text) async => _dataSource.search(context, text);
    }
    return null;
  }

  bool get _isForm => widget.validator != null;

  void _onChanged(String text) {
    widget.onChanged?.call(text, FluentTextChangedReason.userInput);
  }

  void _onSubmitted(List<SmartAutoSuggestItem<T>> localItemsList) {
    final idx = localItemsList.indexWhere((item) => item.selected);
    if (idx.isNegative) return;
    final item = localItemsList[idx];
    widget.onSelected?.call(item);
    item.onSelected?.call();
    _smartController?.select(item);
    widget.onChanged?.call(
      _controller.text,
      FluentTextChangedReason.suggestionChosen,
    );
  }

  @override
  Widget build(BuildContext context) {
    final showList = widget.showListWhenEmpty || _controller.text.isNotEmpty;

    return Focus(
      skipTraversal: true,
      onKeyEvent: (node, event) {
        if (!(event is KeyDownEvent || event is KeyRepeatEvent) ||
            !widget.enableKeyboardControls) {
          return KeyEventResult.ignored;
        }
        final localList = _localItems.toList();
        if (localList.isEmpty) return KeyEventResult.ignored;

        final currentIdx = localList.indexWhere((item) => item.selected);
        final lastIdx = localList.length - 1;

        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          _selectItem(
            currentIdx == -1 || currentIdx == lastIdx ? 0 : currentIdx + 1,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          _selectItem(
            currentIdx == -1 || currentIdx == 0 ? lastIdx : currentIdx - 1,
          );
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.enter) {
          _onSubmitted(localList);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hasBoundedHeight = constraints.maxHeight.isFinite;
          final effectiveListMaxHeight = hasBoundedHeight
              ? math.min(widget.listMaxHeight, constraints.maxHeight)
              : widget.listMaxHeight;

          final listWidget = ConstrainedBox(
            constraints: BoxConstraints(maxHeight: effectiveListMaxHeight),
            child: _SmartAutoSuggestViewList<T>(
              dataSource: _dataSource,
              itemBuilder: widget.itemBuilder,
              controller: _controller,
              theme: widget.theme,
              onSelected: (SmartAutoSuggestItem<T> item) {
                item.onSelected?.call();
                widget.onSelected?.call(item);
                _smartController?.select(item);
                widget.onChanged?.call(
                  item.label,
                  FluentTextChangedReason.suggestionChosen,
                );
                _unselectAll();
                setState(() {});
              },
              node: _overlayNode,
              focusStream: _focusStreamController.stream,
              sorter: sorter,
              maxHeight: effectiveListMaxHeight,
              noResultsFoundBuilder: widget.noResultsFoundBuilder,
              onNoResultsFound: _buildSearchCallback(),
              tileHeight: widget.tileHeight,
              waitingBuilder: widget.waitingBuilder,
            ),
          );

          return Column(
            mainAxisSize: hasBoundedHeight
                ? MainAxisSize.max
                : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isForm)
                TextFormField(
                  key: _textBoxKey,
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  onChanged: _onChanged,
                  onFieldSubmitted: (_) => _onSubmitted(_localItems.toList()),
                  style: widget.style,
                  decoration: widget.decoration,
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
                )
              else
                TextField(
                  key: _textBoxKey,
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  onChanged: _onChanged,
                  onSubmitted: (_) => _onSubmitted(_localItems.toList()),
                  style: widget.style,
                  decoration: widget.decoration,
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
                ),
              if (showList)
                if (hasBoundedHeight)
                  Flexible(fit: FlexFit.loose, child: listWidget)
                else
                  listWidget,
            ],
          );
        },
      ),
    );
  }
}
// ─────────────────────────────────────────────────────────────────────────────
// Private inline list widget
// ─────────────────────────────────────────────────────────────────────────────

class _SmartAutoSuggestViewList<T> extends StatefulWidget {
  const _SmartAutoSuggestViewList({
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
    this.onNoResultsFound,
    this.tileHeight = kComboBoxItemHeight,
    this.waitingBuilder,
    this.theme,
  });

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
  final SmartAutoSuggestTheme? theme;

  @override
  State<_SmartAutoSuggestViewList<T>> createState() =>
      _SmartAutoSuggestViewListState<T>();
}

class _SmartAutoSuggestViewListState<T>
    extends State<_SmartAutoSuggestViewList<T>> {
  late final StreamSubscription _focusSub;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusSub = widget.focusStream.listen((index) {
      if (!mounted) return;
      _scrollToFocusedItem(index);
      setState(() {});
    });
    widget.dataSource.filteredItems.addListener(_onDataChanged);
    widget.dataSource.isLoading.addListener(_onDataChanged);
    widget.dataSource.errorMessage.addListener(_onDataChanged);
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _focusSub.cancel();
    widget.dataSource.filteredItems.removeListener(_onDataChanged);
    widget.dataSource.isLoading.removeListener(_onDataChanged);
    widget.dataSource.errorMessage.removeListener(_onDataChanged);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFocusedItem(int index) {
    final currentSelectedOffset = widget.tileHeight * index;

    void animate() {
      if (!mounted || !_scrollController.hasClients) return;

      final position = _scrollController.position;
      final targetOffset = currentSelectedOffset.clamp(
        position.minScrollExtent,
        position.maxScrollExtent,
      );

      _scrollController.animateTo(
        targetOffset.toDouble(),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    }

    if (_scrollController.hasClients) {
      animate();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final sat = widget.theme ?? appTheme.extension<SmartAutoSuggestTheme>();

    final surfaceColor = sat?.overlayColor ?? appTheme.colorScheme.surface;
    final listBorder =
        sat?.listBorderSide ??
        BorderSide(color: appTheme.colorScheme.outlineVariant, width: 1);
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
    final dividerIndent = sat?.dividerIndent ?? 12.0;
    final disabledColor =
        sat?.disabledItemColor ?? appTheme.colorScheme.outline;
    final tileColor = sat?.tileColor ?? appTheme.colorScheme.surface;
    final selectedTileColor =
        sat?.selectedTileColor ?? appTheme.colorScheme.primaryContainer;
    final selectedTileTextColor =
        sat?.selectedTileTextColor ?? appTheme.colorScheme.onPrimaryContainer;
    final tilePadding =
        sat?.tilePadding ?? const EdgeInsets.only(left: 4, right: 4, top: 4);
    final tileSubtitleStyle =
        sat?.tileSubtitleStyle ??
        appTheme.textTheme.bodySmall?.copyWith(
          color: appTheme.colorScheme.outline,
        );

    final tr = SmartAutoSuggestBoxLocalizations.of(context);

    if (widget.dataSource.isLoading.value) {
      return FocusScope(
        node: widget.node,
        child: Container(
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(top: listBorder),
          ),
          child:
              widget.waitingBuilder?.call(context) ??
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: progressHeight,
                    child: LinearProgressIndicator(color: progressColor),
                  ),
                  ListTile(
                    title: Text(tr.searchingInServer),
                    subtitle: Text(tr.searchingInServerHint),
                    subtitleTextStyle: loadingStyle,
                  ),
                ],
              ),
        ),
      );
    }

    final errorMsg = widget.dataSource.errorMessage.value;
    if (errorMsg != null) {
      final errorStyle =
          sat?.errorSubtitleStyle ??
          TextStyle(fontSize: 14.0, color: appTheme.colorScheme.outline);
      final errorIconColor = sat?.errorIconColor ?? appTheme.colorScheme.error;
      return FocusScope(
        node: widget.node,
        child: Container(
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: surfaceColor,
            border: Border(top: listBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.error_outline, color: errorIconColor),
                title: Text(tr.searchError),
                subtitle: Text(errorMsg),
                subtitleTextStyle: errorStyle,
              ),
            ],
          ),
        ),
      );
    }

    final search = widget.controller.value;
    final cursorOffset = search.selection.baseOffset;
    final textToCursor =
        (cursorOffset >= 0 && cursorOffset <= search.text.length)
        ? search.text.substring(0, cursorOffset)
        : search.text;
    final searchText = textToCursor.trim();
    final sortedItems = widget.dataSource.filteredItems.value;

    Widget content;
    if (sortedItems.isEmpty) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.noResultsFoundBuilder != null) ...[
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: widget.noResultsFoundBuilder?.call(context),
            ),
            Divider(endIndent: dividerIndent, indent: dividerIndent),
          ] else
            const SizedBox(height: 4),
          ListTile(
            title: Text(tr.noResultsFound),
            subtitle: Text(tr.noResultsFoundHint),
            subtitleTextStyle: noResultsStyle,
          ),
        ],
      );
    } else {
      content = Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: ListView.builder(
          itemExtent: widget.tileHeight,
          controller: _scrollController,
          key: ValueKey<int>(sortedItems.length),
          shrinkWrap: true,
          padding: const EdgeInsetsDirectional.only(bottom: 4.0),
          itemCount: sortedItems.length,
          itemBuilder: (context, index) {
            final item = sortedItems.elementAt(index);
            if (widget.itemBuilder != null) {
              return widget.itemBuilder!(context, item);
            }
            if (item.builder != null) {
              return GestureDetector(
                onTap: item.enabled ? () => widget.onSelected(item) : null,
                child: Focus(child: item.builder!(context, searchText)),
              );
            }
            return SmartAutoSuggestBoxOverlayTile(
              subtitle: null,
              title: DefaultTextStyle.merge(
                child:
                    item.child ??
                    SmartAutoSuggestHighlightText(
                      text: item.label,
                      query: searchText,
                    ),
                style: item.enabled ? null : TextStyle(color: disabledColor),
              ),
              semanticLabel: item.semanticLabel ?? item.label,
              selected: item.selected,
              onSelected: item.enabled ? () => widget.onSelected(item) : null,
              tileColor: tileColor,
              selectedTileColor: selectedTileColor,
              selectedTileTextColor: selectedTileTextColor,
              tilePadding: tilePadding,
              tileSubtitleStyle: tileSubtitleStyle,
            );
          },
        ),
      );
    }

    return FocusScope(
      node: widget.node,
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(top: listBorder),
        ),
        child: content,
      ),
    );
  }
}
