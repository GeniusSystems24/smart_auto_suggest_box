part of '../../smart_auto_suggest_box.dart';

/// A multi-select auto-suggest box that allows selecting multiple items
/// from a floating suggestion overlay.
///
/// Selected items are displayed as chips below the text field.
/// When the number of selected items exceeds [maxVisibleChips],
/// a button is shown to open a [BottomSheet] with all selections.
///
/// See also:
///  * [SmartAutoSuggestBox], the single-select variant
///  * [SmartAutoSuggestMultiSelectController], the controller for this widget
class SmartAutoSuggestMultiSelectBox<T> extends StatefulWidget {
  SmartAutoSuggestMultiSelectBox({
    super.key,
    required this.dataSource,
    this.smartController,
    this.onSelectionChanged,
    this.onChanged,
    this.maxVisibleChips = 3,
    this.maxSelections,
    this.chipBuilder,
    this.itemBuilder,
    this.noResultsFoundBuilder,
    this.sorter,
    this.trailingIcon,
    this.clearButtonEnabled = true,
    this.style,
    this.decoration,
    this.theme,
    this.focusNode,
    this.autofocus = false,
    this.enableKeyboardControls = true,
    this.enabled = true,
    this.inputFormatters,
    this.tileHeight = kComboBoxItemHeight,
    this.maxPopupHeight = kSmartAutoSuggestBoxPopupMaxHeight,
    this.direction = SmartAutoSuggestBoxDirection.bottom,
    this.waitingBuilder,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
  });

  /// The data source for providing items and search functionality.
  final SmartAutoSuggestDataSource<T> dataSource;

  /// A unified controller that provides access to both the text input and
  /// the set of currently selected items.
  final SmartAutoSuggestMultiSelectController<T>? smartController;

  /// Called when the set of selected items changes.
  final ValueChanged<Set<SmartAutoSuggestItem<T>>>? onSelectionChanged;

  /// Called when the text is updated.
  final OnChangeSmartAutoSuggestBox? onChanged;

  /// Maximum number of chips visible below the text field before showing
  /// a "show all" button. Defaults to 3.
  final int maxVisibleChips;

  /// Maximum number of items that can be selected. When reached, remaining
  /// unselected items are disabled in the overlay. Defaults to null (unlimited).
  final int? maxSelections;

  /// Builder for custom chip widgets in the selection area.
  ///
  /// Receives the item and an `onRemove` callback to deselect the item.
  final Widget Function(
    BuildContext context,
    SmartAutoSuggestItem<T> item,
    VoidCallback onRemove,
  )? chipBuilder;

  /// Custom builder for overlay items.
  final SmartAutoSuggestItemBuilder<T>? itemBuilder;

  /// Widget shown when no items match.
  final WidgetOrNullBuilder? noResultsFoundBuilder;

  /// Sort / filter items based on current query text.
  final SmartAutoSuggestSorter<T>? sorter;

  /// Widget displayed at the end of the text box.
  final Widget? trailingIcon;

  /// Whether the close button is enabled.
  final bool clearButtonEnabled;

  /// The style to use for the text being edited.
  final TextStyle? style;

  /// Controls the [InputDecoration] of the text input.
  final InputDecoration? decoration;

  /// Optional theme override.
  final SmartAutoSuggestTheme? theme;

  /// Focus node for the text field.
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// Whether items can be selected using keyboard.
  final bool enableKeyboardControls;

  /// Whether the text box is enabled.
  final bool enabled;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// Height of each tile in the overlay.
  final double tileHeight;

  /// Max height of the suggestion popup.
  final double maxPopupHeight;

  /// Direction in which the suggestions overlay will be shown.
  final SmartAutoSuggestBoxDirection direction;

  /// Builder for a custom loading indicator.
  final Widget Function(BuildContext context)? waitingBuilder;

  /// Keyboard type for the text box.
  final TextInputType keyboardType;

  /// Max length of the text box.
  final int? maxLength;

  /// Offset for the overlay positioning.
  final Offset? offset;

  @override
  State<SmartAutoSuggestMultiSelectBox<T>> createState() =>
      _SmartAutoSuggestMultiSelectBoxState<T>();

  /// The default item sorter.
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

class _SmartAutoSuggestMultiSelectBoxState<T>
    extends State<SmartAutoSuggestMultiSelectBox<T>>
    with WidgetsBindingObserver {
  late FocusNode _focusNode = widget.focusNode ?? FocusNode();
  OverlayEntry? _entry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textBoxKey = GlobalKey(
    debugLabel: "SmartAutoSuggestMultiSelectBox's TextBox Key",
  );

  late TextEditingController _controller;
  late SmartAutoSuggestMultiSelectController<T>? _ownedController;
  final FocusScopeNode _overlayNode = FocusScopeNode();
  final _focusStreamController = StreamController<int>.broadcast();

  SmartAutoSuggestSorter<T> get sorter =>
      widget.sorter ?? widget.defaultItemSorter;

  /// Returns the search text from the start of the input to the cursor.
  String get _searchText {
    final text = _controller.text;
    final offset = _controller.selection.baseOffset;
    if (offset < 0 || offset > text.length) return text;
    return text.substring(0, offset);
  }

  SmartAutoSuggestMultiSelectController<T> get _multiController =>
      widget.smartController ?? _ownedController!;

  Set<SmartAutoSuggestItem<T>> get _selectedItems =>
      _multiController.selectedItems.value;

  /// The data source manages items, filtered items, and loading state.
  SmartAutoSuggestDataSource<T> get _dataSource => widget.dataSource;

  Size _boxSize = Size.zero;
  bool _autoScrollScheduled = false;

  /// Convenience accessors that delegate to DataSource.
  Set<SmartAutoSuggestItem<T>> get _localItems =>
      _dataSource.filteredItems.value;
  ValueNotifier<bool> get isLoading => _dataSource.isLoading;

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

    if (widget.smartController != null) {
      _ownedController = null;
      _controller = widget.smartController!.textController;
    } else {
      _ownedController = SmartAutoSuggestMultiSelectController<T>();
      _controller = _ownedController!.textController;
    }

    _dataSource.activeSorter = sorter;
    _dataSource.filteredItems.addListener(_onDataSourceChanged);
    _dataSource.isLoading.addListener(_onDataSourceChanged);

    _multiController.selectedItems.addListener(_onSelectionChanged);
    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final box = _textBoxKey.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && _boxSize != box.size) {
        _boxSize = box.size;
      }

      _dataSource.initialize(context);
      _dataSource.filter(_searchText, sorter);
    });
  }

  void _onDataSourceChanged() {
    if (!mounted) return;
    if (_entry?.mounted ?? false) {
      _entry?.markNeedsBuild();
    }
    setState(() {});
  }

  void _onSelectionChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _dataSource.filteredItems.removeListener(_onDataSourceChanged);
    _dataSource.isLoading.removeListener(_onDataSourceChanged);
    _multiController.selectedItems.removeListener(_onSelectionChanged);
    _focusNode.removeListener(_handleFocusChanged);
    _controller.removeListener(_handleTextChanged);
    _focusStreamController.close();
    _unselectAll();
    _ownedController?.dispose();
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
  void didUpdateWidget(covariant SmartAutoSuggestMultiSelectBox<T> oldWidget) {
    if (widget.focusNode != oldWidget.focusNode) {
      if (oldWidget.focusNode == null) _focusNode.dispose();
      _focusNode = widget.focusNode ?? FocusNode();
    }

    if (widget.smartController != oldWidget.smartController) {
      _controller.removeListener(_handleTextChanged);
      oldWidget.smartController?.selectedItems
          .removeListener(_onSelectionChanged);
      _ownedController?.dispose();

      if (widget.smartController != null) {
        _ownedController = null;
        _controller = widget.smartController!.textController;
      } else {
        _ownedController = SmartAutoSuggestMultiSelectController<T>();
        _controller = _ownedController!.textController;
      }

      _controller.addListener(_handleTextChanged);
      _multiController.selectedItems.addListener(_onSelectionChanged);
    }

    if (widget.dataSource != oldWidget.dataSource &&
        !_dataSource.hasSameConfig(widget.dataSource)) {
      oldWidget.dataSource.filteredItems.removeListener(_onDataSourceChanged);
      oldWidget.dataSource.isLoading.removeListener(_onDataSourceChanged);
      _dataSource.activeSorter = sorter;
      _dataSource.filteredItems.addListener(_onDataSourceChanged);
      _dataSource.isLoading.addListener(_onDataSourceChanged);
      if (_dataSource.initialList != null) {
        _dataSource.initialize(context);
      }
      _dataSource.filter(_searchText, sorter);
    }

    super.didUpdateWidget(oldWidget);
  }

  void _handleFocusChanged() {
    final hasFocus = _focusNode.hasFocus;
    if (!hasFocus) {
      dismissOverlay();
    } else {
      showOverlay();
    }
    setState(() {});
  }

  void _handleTextChanged() {
    if (!mounted) return;
    if (_controller.text.length < 2) setState(() {});
    _updateLocalItems();

    if (_dataSource.searchMode == SmartAutoSuggestSearchMode.always &&
        _dataSource.onSearch != null) {
      _dataSource.scheduleSearch(context, _searchText.trim());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _updateLocalItems();
    });
  }

  Future Function(String text)? _buildSearchCallback() {
    if (_dataSource.onSearch != null) {
      return (text) async => _dataSource.search(context, text);
    }
    return null;
  }

  bool get isOverlayVisible => _entry != null;

  SmartAutoSuggestBoxDirection _normalizeDirection(
    SmartAutoSuggestBoxDirection direction,
  ) {
    return switch (direction) {
      SmartAutoSuggestBoxDirection.bottom =>
        SmartAutoSuggestBoxDirection.bottom,
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

        final bool isVertical =
            resolvedDirection == SmartAutoSuggestBoxDirection.bottom ||
            resolvedDirection == SmartAutoSuggestBoxDirection.top;

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
                onSelected: _onItemTapped,
                noResultsFoundBuilder: widget.noResultsFoundBuilder,
                onNoResultsFound: _buildSearchCallback(),
                multiSelectController: _multiController,
                maxSelections: widget.maxSelections,
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
  }

  void showOverlay() {
    if (_entry == null && !(_entry?.mounted ?? false)) {
      _insertOverlay();
      _autoSelectFirstItem();
    }
  }

  /// On desktop platforms, automatically focus the first item when
  /// the overlay opens so the user can navigate with arrow keys
  /// and confirm with Enter right away.
  void _autoSelectFirstItem() {
    if (!widget.enableKeyboardControls) return;
    switch (defaultTargetPlatform) {
      case TargetPlatform.windows:
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final items = _localItems.toList();
          if (items.isEmpty) return;
          _unselectAll();
          items.first.selected = true;
          items.first.onFocusChange?.call(true);
          _focusStreamController.add(0);
        });
      default:
        break;
    }
  }

  void _unselectAll() {
    for (final item in _localItems) {
      item.selected = false;
      item.onFocusChange?.call(false);
    }
  }

  void _onChanged(String text) {
    widget.onChanged?.call(text, FluentTextChangedReason.userInput);
    showOverlay();
  }

  void _onItemTapped(SmartAutoSuggestItem<T> item) {
    _multiController.toggleSelection(item);
    widget.onSelectionChanged?.call(_selectedItems);

    // Clear search text after selection so full list shows
    _controller.clear();

    // Rebuild overlay to reflect new selection state
    if (_entry?.mounted ?? false) {
      _entry?.markNeedsBuild();
    }
    setState(() {});
  }

  void _deselect(SmartAutoSuggestItem<T> item) {
    _multiController.deselect(item);
    widget.onSelectionChanged?.call(_selectedItems);
    if (_entry?.mounted ?? false) {
      _entry?.markNeedsBuild();
    }
    setState(() {});
  }

  void _onSubmitted(List<SmartAutoSuggestItem<T>> localItemsList) {
    final currentlySelectedIndex = localItemsList.indexWhere(
      (item) => item.selected,
    );
    if (currentlySelectedIndex.isNegative) return;
    final item = localItemsList[currentlySelectedIndex];
    _onItemTapped(item);
  }

  double? _width;

  @override
  Widget build(BuildContext context) {
    void select(int index) {
      _unselectAll();
      final item = (_localItems.elementAt(index))..selected = true;
      item.onFocusChange?.call(true);
      _focusStreamController.add(index);
    }

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
              select(0);
            } else if (currentlySelectedIndex >= 0) {
              select(currentlySelectedIndex + 1);
            }
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            if (currentlySelectedIndex == -1 || currentlySelectedIndex == 0) {
              select(localItemsList.length - 1);
            } else {
              select(currentlySelectedIndex - 1);
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

            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Text Field
                TextField(
                  key: _textBoxKey,
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: widget.autofocus,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  onChanged: _onChanged,
                  onSubmitted: (text) {
                    _onSubmitted(_localItems.toList());
                  },
                  style: widget.style,
                  decoration: decoration,
                  enabled: widget.enabled,
                  inputFormatters: widget.inputFormatters,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  onTapOutside: (event) => _focusNode.unfocus(),
                ),

                // 2. Chips area
                if (_selectedItems.isNotEmpty)
                  _buildChipsArea(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChipsArea(BuildContext context) {
    final items = _selectedItems.toList();
    final visibleCount = math.min(widget.maxVisibleChips, items.length);
    final hasOverflow = items.length > widget.maxVisibleChips;
    final appTheme = Theme.of(context);
    final sat = widget.theme ?? appTheme.extension<SmartAutoSuggestTheme>();
    final borderColor = sat?.disabledItemColor ?? appTheme.colorScheme.outline;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: borderColor, width: 1),
          right: BorderSide(color: borderColor, width: 1),
          bottom: BorderSide(color: borderColor, width: 1),
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(4),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < visibleCount; i++)
            _buildChipTile(context, items[i]),
          if (hasOverflow)
            InkWell(
              onTap: () => _showAllSelectedBottomSheet(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.expand_more,
                      size: 18,
                      color: appTheme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Show all (${items.length})',
                      style: TextStyle(
                        color: appTheme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChipTile(BuildContext context, SmartAutoSuggestItem<T> item) {
    if (widget.chipBuilder != null) {
      return widget.chipBuilder!(context, item, () => _deselect(item));
    }
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(item.label),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        onPressed: () => _deselect(item),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      ),
    );
  }

  void _showAllSelectedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return ValueListenableBuilder<Set<SmartAutoSuggestItem<T>>>(
          valueListenable: _multiController.selectedItems,
          builder: (context, items, _) {
            final itemList = items.toList();
            if (itemList.isEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(sheetContext)) {
                  Navigator.pop(sheetContext);
                }
              });
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: .4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Title row
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Selected (${itemList.length})',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // List of selected items
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.5,
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      final item = itemList[index];
                      return ListTile(
                        title: Text(item.label),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => _deselect(item),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
