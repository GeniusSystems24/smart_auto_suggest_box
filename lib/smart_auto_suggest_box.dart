import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

import 'generated/l10n.dart';

const kPickerHeight = 32.0;
const kPickerDiameterRatio = 100.0;
const kComboBoxRadius = Radius.circular(4.0);
const double kOneLineTileHeight = 40.0;
const double kComboBoxItemHeight = kOneLineTileHeight + 10;

typedef WidgetOrNullBuilder = Widget? Function(BuildContext context);
typedef SmartAutoSuggestBoxSorter<T> =
    Set<SmartAutoSuggestBoxItem<T>> Function(
      String text,
      Set<SmartAutoSuggestBoxItem<T>> items,
    );

typedef OnChangeSmartAutoSuggestBox<T> =
    void Function(String text, FluentTextChangedReason reason);

typedef SmartAutoSuggestBoxItemBuilder<T> =
    Widget Function(BuildContext context, SmartAutoSuggestBoxItem<T> item);

enum FluentTextChangedReason {
  /// Whether the text in an [SmartAutoSuggestBox] was changed by user input
  userInput,

  /// Whether the text in an [SmartAutoSuggestBox] was changed because the user
  /// chose the suggestion
  suggestionChosen,

  /// Whether the text in an [SmartAutoSuggestBox] was cleared by the user
  cleared,
}

/// Controls when [SmartAutoSuggestBoxDataSource.onSearch] is invoked.
enum SmartAutoSuggestBoxSearchMode {
  /// Only calls [SmartAutoSuggestBoxDataSource.onSearch] when local filtering
  /// yields no results. This is the default behavior.
  onNoLocalResults,

  /// Calls [SmartAutoSuggestBoxDataSource.onSearch] on every text change
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
///   dataSource: SmartAutoSuggestBoxDataSource(
///     initialList: (context) => [
///       SmartAutoSuggestBoxItem(value: 'apple', label: 'Apple'),
///       SmartAutoSuggestBoxItem(value: 'banana', label: 'Banana'),
///     ],
///     onSearch: (context, currentItems, searchText) async {
///       final results = await api.search(searchText);
///       return results.map((r) =>
///         SmartAutoSuggestBoxItem(value: r.id, label: r.name),
///       ).toList();
///     },
///   ),
/// )
/// ```
class SmartAutoSuggestBoxDataSource<T> {
  /// Synchronous initial items provided when the widget first builds.
  ///
  /// Called once during [initState] with the widget's [BuildContext].
  final List<SmartAutoSuggestBoxItem<T>> Function(BuildContext context)?
      initialList;

  /// Async search callback invoked when new data is needed.
  ///
  /// Parameters:
  /// - [context]: The widget's build context
  /// - [currentItems]: The current list of items in the widget
  /// - [searchText]: The current search text (null when loading initial data)
  ///
  /// When invoked depends on [searchMode]:
  /// - [SmartAutoSuggestBoxSearchMode.onNoLocalResults]: Called only when
  ///   local filtering yields no results.
  /// - [SmartAutoSuggestBoxSearchMode.always]: Called on every text change
  ///   after the [debounce] duration.
  final Future<List<SmartAutoSuggestBoxItem<T>>> Function(
    BuildContext context,
    List<SmartAutoSuggestBoxItem<T>> currentItems,
    String? searchText,
  )? onSearch;

  /// Controls when [onSearch] is invoked.
  ///
  /// Defaults to [SmartAutoSuggestBoxSearchMode.onNoLocalResults].
  final SmartAutoSuggestBoxSearchMode searchMode;

  /// Debounce duration before calling [onSearch].
  ///
  /// Defaults to 400ms. Set to [Duration.zero] for no debounce.
  final Duration debounce;

  /// Creates a data source for [SmartAutoSuggestBox].
  const SmartAutoSuggestBoxDataSource({
    this.initialList,
    this.onSearch,
    this.searchMode = SmartAutoSuggestBoxSearchMode.onNoLocalResults,
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
class SmartAutoSuggestBoxItem<T> {
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
  SmartAutoSuggestBoxItem({
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

    return other is SmartAutoSuggestBoxItem && other.value == value;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }
}

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
    List<SmartAutoSuggestBoxItem<T>> items = const [],
    this.dataSource,
    this.controller,
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
    @Deprecated('Use dataSource with onSearch instead')
    this.onNoResultsFound,
    this.waitingBuilder,
    this.tileHeight = kComboBoxItemHeight,
    this.direction = SmartAutoSuggestBoxDirection.bottom,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
  }) : autovalidateMode = AutovalidateMode.disabled,
       validator = null,
       items = dataSource != null
           ? ValueNotifier(<SmartAutoSuggestBoxItem<T>>{})
           : ValueNotifier(items.toSet());

  /// Creates a fluent-styled auto suggest form box.
  SmartAutoSuggestBox.form({
    super.key,
    @Deprecated('Use dataSource with initialList instead')
    List<SmartAutoSuggestBoxItem<T>> items = const [],
    this.dataSource,
    this.controller,
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
    @Deprecated('Use dataSource with onSearch instead')
    this.onNoResultsFound,
    this.waitingBuilder,
    this.tileHeight = kComboBoxItemHeight,
    this.direction = SmartAutoSuggestBoxDirection.bottom,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.offset,
  }) : items = dataSource != null
           ? ValueNotifier(<SmartAutoSuggestBoxItem<T>>{})
           : ValueNotifier(items.toSet());

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
  final SmartAutoSuggestBoxDataSource<T>? dataSource;

  /// The list of items to display to the user to pick.
  ///
  /// Deprecated: Use [dataSource] with [SmartAutoSuggestBoxDataSource.initialList] instead.
  final ValueNotifier<Set<SmartAutoSuggestBoxItem<T>>> items;

  @Deprecated('Use dataSource with onSearch instead')
  final Future<List<SmartAutoSuggestBoxItem<T>>> Function(String text)?
      onNoResultsFound;

  /// The controller used to have control over what to show on the [TextBox].
  final TextEditingController? controller;

  /// Called when the text is updated
  final OnChangeSmartAutoSuggestBox? onChanged;

  /// Called when the user selected a value.
  final ValueChanged<SmartAutoSuggestBoxItem<T>?>? onSelected;

  /// Called when the overlay visibility changes
  final ValueChanged<bool>? onOverlayVisibilityChanged;

  /// A callback function that builds the items in the overlay.
  ///
  /// Use [noResultsFoundBuilder] to build the overlay when no item is provided
  final SmartAutoSuggestBoxItemBuilder? itemBuilder;

  final Widget Function(BuildContext context)? waitingBuilder;
  final double tileHeight;

  /// Widget to be displayed when none of the items fit the [sorter]
  final WidgetOrNullBuilder? noResultsFoundBuilder;

  /// Sort the [items] based on the current query text
  ///
  /// See also:
  ///
  ///  * [SmartAutoSuggestBox.defaultItemSorter], the default item sorter
  final SmartAutoSuggestBoxSorter<T>? sorter;

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
      ..add(IterableProperty<SmartAutoSuggestBoxItem<T>>('items', items.value))
      ..add(
        ObjectFlagProperty<ValueChanged<SmartAutoSuggestBoxItem<T>>?>(
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
  Set<SmartAutoSuggestBoxItem<T>> defaultItemSorter(
    String text,
    Set<SmartAutoSuggestBoxItem<T>> items,
  ) {
    text = text.trim();
    if (text.isEmpty) return items;

    return items.where((element) {
      return element.label.toLowerCase().contains(text.toLowerCase());
    }).toSet();
  }
}

class SmartAutoSuggestBoxState<T> extends State<SmartAutoSuggestBox<T>> {
  late FocusNode _focusNode = widget.focusNode ?? FocusNode();
  OverlayEntry? _entry;
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textBoxKey = GlobalKey(
    debugLabel: "SmartAutoSuggestBox's TextBox Key",
  );

  late TextEditingController _controller;
  final FocusScopeNode _overlayNode = FocusScopeNode();
  final _focusStreamController = StreamController<int>.broadcast();
  final _dynamicItemsController =
      StreamController<Set<SmartAutoSuggestBoxItem<T>>>.broadcast();

  SmartAutoSuggestBoxSorter<T> get sorter =>
      widget.sorter ?? widget.defaultItemSorter;

  /// The size of the text box.
  ///
  /// Used to determine if the overlay needs to be updated when the text box size
  /// changes.
  Size _boxSize = Size.zero;
  final ValueNotifier<bool> isLoading = ValueNotifier(false);
  String lastSearchLoaded = "";
  Timer? _debounceTimer;

  late Set<SmartAutoSuggestBoxItem<T>> _localItems;

  void _updateLocalItems() {
    if (!mounted) return;
    setState(() => _localItems = sorter(_controller.text, widget.items.value));
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    isLoading.value = false;

    _controller.addListener(_handleTextChanged);
    _focusNode.addListener(_handleFocusChanged);

    _localItems = sorter(_controller.text, widget.items.value);

    // Update the overlay when the text box size has changed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final box = _textBoxKey.currentContext!.findRenderObject() as RenderBox;
      if (_boxSize != box.size) {
        dismissOverlay();
        _boxSize = box.size;
      }

      // Populate items from dataSource.initialList
      if (widget.dataSource?.initialList != null) {
        final initial = widget.dataSource!.initialList!(context);
        widget.items.value = initial.toSet();
        _updateLocalItems();
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.removeListener(_handleFocusChanged);
    _controller.removeListener(_handleTextChanged);
    _focusStreamController.close();
    _dynamicItemsController.close();
    _unselectAll();

    // If the TextEditingController and FocusNode objects are created locally,
    // we must dispose them.
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();

    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SmartAutoSuggestBox<T> oldWidget) {
    {
      // if the focusNode or controller objects were changed, we must reflect the
      // changes here. This is mostly used for a good dev-experience with hot
      // reload, but can also be used to create fancy focus effects
      if (widget.focusNode != oldWidget.focusNode) {
        if (oldWidget.focusNode == null) _focusNode.dispose();
        _focusNode = widget.focusNode ?? FocusNode();
      }

      if (widget.controller != oldWidget.controller) {
        if (oldWidget.controller == null) _controller.dispose();
        _controller = widget.controller ?? TextEditingController();
      }
    }

    if (widget.items != oldWidget.items) {
      _dynamicItemsController.add(widget.items.value);
    }

    // Re-populate items if dataSource changed
    if (widget.dataSource != oldWidget.dataSource &&
        widget.dataSource?.initialList != null) {
      final initial = widget.dataSource!.initialList!(context);
      widget.items.value = initial.toSet();
      _updateLocalItems();
      _dynamicItemsController.add(widget.items.value);
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

    // If searchMode is always, trigger search on every text change
    if (widget.dataSource?.searchMode == SmartAutoSuggestBoxSearchMode.always &&
        widget.dataSource?.onSearch != null) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(widget.dataSource!.debounce, () {
        _buildSearchCallback()?.call(_controller.text.trim());
      });
    }

    // Update the overlay when the text box size has changed
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      _updateLocalItems();
    });
  }

  /// Builds a unified search callback that handles both the new [dataSource]
  /// path and the deprecated [onNoResultsFound] path.
  Future Function(String text)? _buildSearchCallback() {
    // New data source path
    if (widget.dataSource?.onSearch != null) {
      return (text) async {
        if (widget.dataSource!.debounce > Duration.zero &&
            widget.dataSource?.searchMode != SmartAutoSuggestBoxSearchMode.always) {
          await Future.delayed(widget.dataSource!.debounce);
        }
        final currentText = _controller.value.text.trim();
        if (currentText.isNotEmpty &&
            !lastSearchLoaded.startsWith(currentText) &&
            text == currentText) {
          lastSearchLoaded = currentText;
          isLoading.value = true;
          try {
            final newItems = await widget.dataSource!.onSearch!(
              context,
              widget.items.value.toList(),
              text,
            );
            if (newItems.isNotEmpty) {
              widget.items.value = {...widget.items.value, ...newItems};
              _localItems = sorter(_controller.text, widget.items.value);
            }
          } catch (_) {
            // Swallow errors like the existing .onError handler
          } finally {
            isLoading.value = false;
          }
        }
      };
    }

    // Deprecated path - existing onNoResultsFound
    // ignore: deprecated_member_use_from_same_package
    if (widget.onNoResultsFound != null) {
      return (text) async {
        await Future.delayed(const Duration(milliseconds: 400));
        final currentText = _controller.value.text.trim();
        if (currentText.isNotEmpty &&
            !lastSearchLoaded.startsWith(currentText) &&
            text == currentText) {
          lastSearchLoaded = currentText;
          isLoading.value = true;
          // ignore: deprecated_member_use_from_same_package
          final newItems = await widget.onNoResultsFound!(text)
              .onError((error, stackTrace) => []);
          await Future.delayed(const Duration(milliseconds: 300));
          if (newItems.isNotEmpty) {
            widget.items.value = {
              ...widget.items.value,
              ...newItems,
            };
            _localItems = sorter(_controller.text, widget.items.value);
          }
          isLoading.value = false;
        }
      };
    }

    return null;
  }

  /// Whether the overlay is currently visible.
  bool get isOverlayVisible => _entry != null;

  /// Resolves the preferred direction to the actual direction based on
  /// available screen space. Falls back to the opposite direction if the
  /// preferred direction doesn't have enough space.
  SmartAutoSuggestBoxDirection _resolveDirection({
    required Offset globalOffset,
    required Size boxSize,
    required Size screenSize,
    required EdgeInsets viewPadding,
  }) {
    final preferred = widget.direction;

    // Normalize deprecated values
    final normalized = switch (preferred) {
      // ignore: deprecated_member_use_from_same_package
      SmartAutoSuggestBoxDirection.bottom =>
        SmartAutoSuggestBoxDirection.bottom,
      // ignore: deprecated_member_use_from_same_package
      SmartAutoSuggestBoxDirection.top => SmartAutoSuggestBoxDirection.top,
      _ => preferred,
    };

    final spaceBelow =
        screenSize.height -
        viewPadding.bottom -
        globalOffset.dy -
        boxSize.height;
    final spaceAbove = globalOffset.dy - viewPadding.top;
    final spaceEnd = screenSize.width - globalOffset.dx - boxSize.width;
    final spaceStart = globalOffset.dx;

    const minSpace = 100.0;

    switch (normalized) {
      case SmartAutoSuggestBoxDirection.bottom:
        if (spaceBelow >= minSpace) return SmartAutoSuggestBoxDirection.bottom;
        if (spaceAbove > spaceBelow) return SmartAutoSuggestBoxDirection.top;
        return SmartAutoSuggestBoxDirection.bottom;

      case SmartAutoSuggestBoxDirection.top:
        if (spaceAbove >= minSpace) return SmartAutoSuggestBoxDirection.top;
        if (spaceBelow > spaceAbove) return SmartAutoSuggestBoxDirection.bottom;
        return SmartAutoSuggestBoxDirection.top;

      case SmartAutoSuggestBoxDirection.start:
        if (spaceStart >= minSpace) return SmartAutoSuggestBoxDirection.start;
        if (spaceEnd > spaceStart) return SmartAutoSuggestBoxDirection.end;
        return SmartAutoSuggestBoxDirection.start;

      case SmartAutoSuggestBoxDirection.end:
        if (spaceEnd >= minSpace) return SmartAutoSuggestBoxDirection.end;
        if (spaceStart > spaceEnd) return SmartAutoSuggestBoxDirection.start;
        return SmartAutoSuggestBoxDirection.end;
    }
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
        final isRtl = Directionality.of(context) == TextDirection.rtl;

        final resolvedDirection = _resolveDirection(
          globalOffset: globalOffset,
          boxSize: box.size,
          screenSize: screenSize,
          viewPadding: viewPadding,
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
                screenSize.height -
                viewPadding.bottom -
                globalOffset.dy -
                box.size.height;
            maxHeight = spaceBelow.clamp(0.0, widget.maxPopupHeight);
            targetAnchor = Alignment.bottomCenter;
            followerAnchor = Alignment.topCenter;
            offset = widget.offset ?? const Offset(0, 0.8);
          } else {
            final spaceAbove = globalOffset.dy - viewPadding.top;
            maxHeight = spaceAbove.clamp(0.0, widget.maxPopupHeight);
            targetAnchor = Alignment.topCenter;
            followerAnchor = Alignment.bottomCenter;
            offset = widget.offset ?? const Offset(0, -0.8);
          }
        } else {
          // Horizontal: start or end
          final spaceVertical =
              screenSize.height - viewPadding.bottom - globalOffset.dy;
          maxHeight = spaceVertical.clamp(0.0, widget.maxPopupHeight);

          if (resolvedDirection == SmartAutoSuggestBoxDirection.start) {
            final spaceStart = isRtl
                ? screenSize.width - globalOffset.dx - box.size.width
                : globalOffset.dx;
            overlayWidth = spaceStart.clamp(100.0, box.size.width);
            targetAnchor = isRtl ? Alignment.centerRight : Alignment.centerLeft;
            followerAnchor = isRtl
                ? Alignment.centerLeft
                : Alignment.centerRight;
            offset = widget.offset ?? Offset(isRtl ? 0.8 : -0.8, 0);
          } else {
            final spaceEnd = isRtl
                ? globalOffset.dx
                : screenSize.width - globalOffset.dx - box.size.width;
            overlayWidth = spaceEnd.clamp(100.0, box.size.width);
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
                waitingBuilder: widget.waitingBuilder,
                tileHeight: widget.tileHeight,
                direction: resolvedDirection,
                isLoading: isLoading,
                maxHeight: maxHeight,
                node: _overlayNode,
                controller: _controller,
                items: widget.items,
                itemBuilder: widget.itemBuilder,
                focusStream: _focusStreamController.stream,
                itemsStream: _dynamicItemsController.stream,
                sorter: sorter,
                onSelected: (SmartAutoSuggestBoxItem<T> item) {
                  item.onSelected?.call();
                  widget.onSelected?.call(item);
                  _controller
                    ..text = item.label
                    ..selection = TextSelection.collapsed(
                      offset: item.label.length,
                    );
                  widget.onChanged?.call(
                    item.label,
                    FluentTextChangedReason.suggestionChosen,
                  );
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
    }
  }

  void _unselectAll() {
    for (final item in _localItems) {
      item._selected = false;
      item.onFocusChange?.call(false);
    }
  }

  void _onChanged(String text) {
    widget.onChanged?.call(text, FluentTextChangedReason.userInput);
    showOverlay();
  }

  void _onSubmitted(List<SmartAutoSuggestBoxItem<T>> localItemsList) {
    final currentlySelectedIndex = localItemsList.indexWhere(
      (item) => item._selected,
    );
    if (currentlySelectedIndex.isNegative) return;

    final item = localItemsList[currentlySelectedIndex];
    widget.onSelected?.call(item);
    item.onSelected?.call();

    _controller.text = item.label;
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
    void select(int index) {
      _unselectAll();
      final item = (_localItems.elementAt(index)).._selected = true;
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
            (item) => item._selected,
          );

          final lastIndex = localItemsList.length - 1;

          if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            // if nothing is selected, select the first
            if (currentlySelectedIndex == -1 ||
                currentlySelectedIndex == lastIndex) {
              select(0);
            } else if (currentlySelectedIndex >= 0) {
              select(currentlySelectedIndex + 1);
            }
            return KeyEventResult.handled;
          } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            // if nothing is selected, select the last
            if (currentlySelectedIndex == -1 || currentlySelectedIndex == 0) {
              select(localItemsList.length - 1);
            } else {
              select(currentlySelectedIndex - 1);
            }
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
    required this.items,
    required this.itemBuilder,
    required this.controller,
    required this.onSelected,
    required this.node,
    required this.focusStream,
    required this.itemsStream,
    required this.sorter,
    required this.maxHeight,
    required this.noResultsFoundBuilder,
    required this.isLoading,
    this.onNoResultsFound,
    this.tileHeight = kComboBoxItemHeight,
    this.waitingBuilder,
    this.direction = SmartAutoSuggestBoxDirection.bottom,
  });

  final ValueNotifier<Set<SmartAutoSuggestBoxItem<T>>> items;
  final SmartAutoSuggestBoxItemBuilder<T>? itemBuilder;
  final TextEditingController controller;
  final ValueChanged<SmartAutoSuggestBoxItem<T>> onSelected;
  final FocusScopeNode node;
  final Stream<int> focusStream;
  final Stream<Set<SmartAutoSuggestBoxItem<T>>> itemsStream;
  final SmartAutoSuggestBoxSorter<T> sorter;
  final double maxHeight;
  final WidgetOrNullBuilder? noResultsFoundBuilder;
  final ValueNotifier<bool> isLoading;
  final Future Function(String text)? onNoResultsFound;
  final double tileHeight;
  final Widget Function(BuildContext context)? waitingBuilder;
  final SmartAutoSuggestBoxDirection direction;

  @override
  State<_SmartAutoSuggestBoxOverlay<T>> createState() =>
      _SmartAutoSuggestBoxOverlayState<T>();
}

class _SmartAutoSuggestBoxOverlayState<T>
    extends State<_SmartAutoSuggestBoxOverlay<T>> {
  late final StreamSubscription focusSubscription;
  late final StreamSubscription itemsSubscription;
  final ScrollController scrollController = ScrollController();

  late ValueNotifier<Set<SmartAutoSuggestBoxItem<T>>> items = widget.items;

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
    itemsSubscription = widget.itemsStream.listen((items) {
      this.items.value = items;
    });
  }

  @override
  void dispose() {
    focusSubscription.cancel();
    itemsSubscription.cancel();
    scrollController.dispose();
    super.dispose();
  }

  EdgeInsetsGeometry _resolveMargin(SmartAutoSuggestBoxDirection direction) {
    switch (direction) {
      case SmartAutoSuggestBoxDirection.top:
        return const EdgeInsetsDirectional.only(start: 8, end: 8, bottom: 8);
      case SmartAutoSuggestBoxDirection.start:
        return const EdgeInsetsDirectional.only(top: 8, bottom: 8, end: 8);
      case SmartAutoSuggestBoxDirection.end:
        return const EdgeInsetsDirectional.only(top: 8, bottom: 8, start: 8);
      case SmartAutoSuggestBoxDirection.bottom:
        return const EdgeInsetsDirectional.only(start: 8, end: 8, top: 8);
    }
  }

  BorderRadiusGeometry _resolveBorderRadius(
    SmartAutoSuggestBoxDirection direction,
  ) {
    const r = Radius.circular(4.0);
    switch (direction) {
      case SmartAutoSuggestBoxDirection.bottom:
        return const BorderRadiusDirectional.vertical(bottom: r);
      case SmartAutoSuggestBoxDirection.top:
        return const BorderRadiusDirectional.vertical(top: r);
      case SmartAutoSuggestBoxDirection.start:
        return const BorderRadiusDirectional.horizontal(end: r);
      case SmartAutoSuggestBoxDirection.end:
        return const BorderRadiusDirectional.horizontal(start: r);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFieldTapRegion(
      onTapOutside: (event) {
        widget.node.unfocus();
      },
      child: FocusScope(
        node: widget.node,
        child: Container(
          margin: _resolveMargin(widget.direction),
          constraints: BoxConstraints(maxHeight: widget.maxHeight),
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: _resolveBorderRadius(widget.direction),
            ),
            shadows: [
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha((255 * .1).toInt()),
                offset: const Offset(-1, 3),
                blurRadius: 2.0,
                spreadRadius: 3.0,
              ),
              BoxShadow(
                color: theme.colorScheme.shadow.withAlpha((255 * .15).toInt()),
                offset: const Offset(1, 3),
                blurRadius: 2.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            // elevation: 0.0,
            child: Container(
              color: theme.cardTheme.color,
              child: ValueListenableBuilder(
                valueListenable: widget.isLoading,
                builder: (context, isLoadingValue, _) {
                  final tr = SmartAutoSuggestBoxLocalizations.of(context);
                  final theme = Theme.of(context);
                  if (isLoadingValue) {
                    return widget.waitingBuilder?.call(context) ??
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 4,
                              child: const LinearProgressIndicator(),
                            ),
                            ListTile(
                              title: Text(tr.searchingInServer),
                              subtitle: Text(tr.searchingInServerHint),
                              subtitleTextStyle: TextStyle(
                                fontSize: 14.0,
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        );
                  }
                  return ValueListenableBuilder<TextEditingValue>(
                    valueListenable: widget.controller,
                    builder: (context, search, _) {
                      final searchValue = search.text.trim();
                      return ValueListenableBuilder(
                        valueListenable: items,
                        builder: (context, itemsValue, child) {
                          final sortedItems = widget.sorter(
                            searchValue,
                            itemsValue,
                          );

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
                                Divider(endIndent: 12, indent: 12),
                              ] else
                                SizedBox(height: 4),
                              ListTile(
                                title: Text(tr.noResultsFound),
                                subtitle: Text(tr.noResultsFoundHint),
                                subtitleTextStyle: theme.textTheme.bodySmall
                                    ?.copyWith(
                                      color: theme.colorScheme.outline,
                                    ),
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
                            result = ListView.builder(
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
                                return widget.itemBuilder?.call(
                                      context,
                                      item,
                                    ) ??
                                    _SmartAutoSuggestBoxOverlayTile(
                                      subtitle: null,
                                      title: DefaultTextStyle.merge(
                                        child: item.child ?? Text(item.label),
                                        style: item.enabled
                                            ? null
                                            : TextStyle(
                                                color:
                                                    theme.colorScheme.outline,
                                              ),
                                      ),
                                      semanticLabel:
                                          item.semanticLabel ?? item.label,
                                      selected:
                                          item._selected ||
                                          widget.node.hasFocus,
                                      onSelected: item.enabled
                                          ? () => widget.onSelected(item)
                                          : null,
                                    );
                              },
                            );
                          }
                          return result;
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SmartAutoSuggestBoxOverlayTile extends StatefulWidget {
  const _SmartAutoSuggestBoxOverlayTile({
    required this.title,
    required this.subtitle,
    this.selected = false,
    this.onSelected,
    this.semanticLabel,
  });

  final Widget title;
  final Widget? subtitle;
  final VoidCallback? onSelected;
  final bool selected;
  final String? semanticLabel;

  @override
  State<_SmartAutoSuggestBoxOverlayTile> createState() =>
      __SmartAutoSuggestBoxOverlayTileState();
}

class __SmartAutoSuggestBoxOverlayTileState
    extends State<_SmartAutoSuggestBoxOverlayTile>
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
      padding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      child: ListTile(
        tileColor: theme.colorScheme.surface,
        selectedTileColor: theme.colorScheme.primaryContainer,
        selectedColor: theme.colorScheme.onPrimaryContainer,
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
        subtitleTextStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}
