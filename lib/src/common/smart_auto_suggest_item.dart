part of 'common.dart';

/// An item used in [SmartAutoSuggestBox] and [SmartAutoSuggestView].
class SmartAutoSuggestItem<T> {
  /// A unique key to identify this item.
  ///
  /// When provided, equality and hashing use [key] instead of [value].
  /// This is useful when multiple items may share the same value but
  /// represent different entries.
  final String? key;

  /// The value attached to this item.
  final T value;

  /// The label that identifies this item.
  ///
  /// The data is filtered based on this label.
  final String label;

  /// The widget to be shown.
  ///
  /// Deprecated: Use [titleBuilder] instead.
  @Deprecated('Use titleBuilder instead')
  final Widget? child;

  /// Optional static subtitle widget.
  ///
  /// If [subtitleBuilder] is also provided, [subtitleBuilder] takes priority.
  final Widget? subtitle;

  /// Builder for the title part of this item's tile.
  ///
  /// Receives [searchText] (the current query, may be null) and [isFocused]
  /// (whether this item is keyboard-focused) so the returned widget can adapt
  /// its appearance accordingly (e.g. highlight matching text).
  ///
  /// When null the default [SmartAutoSuggestHighlightText] title is rendered.
  final Widget? Function(
    BuildContext context,
    String? searchText,
    bool isFocused,
  )? titleBuilder;

  /// Builder for the subtitle part of this item's tile.
  ///
  /// Receives [searchText] and [isFocused].
  /// When null, [subtitle] is used as a fallback. If both are null no subtitle
  /// is shown.
  final Widget? Function(
    BuildContext context,
    String? searchText,
    bool isFocused,
  )? subtitleBuilder;

  /// Builder for the trailing widget of this item's tile.
  ///
  /// Receives [searchText] and [isFocused].
  final Widget? Function(
    BuildContext context,
    String? searchText,
    bool isFocused,
  )? trailingBuilder;

  /// Builder for the leading widget of this item's tile.
  ///
  /// Receives [searchText] and [isFocused].
  final Widget? Function(
    BuildContext context,
    String? searchText,
    bool isFocused,
  )? leadingBuilder;

  /// Called when this item's focus is changed.
  final ValueChanged<bool>? onFocusChange;

  /// Called when this item is selected.
  final VoidCallback? onSelected;

  /// {@macro fluent_ui.controls.inputs.HoverButton.semanticLabel}
  ///
  /// If not provided, [label] is used.
  final String? semanticLabel;

  final bool enabled;

  bool _selected = false;

  /// Whether this item is currently keyboard-focused.
  ///
  /// Deprecated: highlight state is now owned by `SmartAutoSuggestEngine`
  /// via its `focusedIndex` notifier. The setter is kept as a
  /// backward-compatibility shim that still fires [onFocusChange], but
  /// rendering should not rely on it.
  bool get selected => _selected;

  @Deprecated(
    'Highlight state is now managed by SmartAutoSuggestEngine.focusedIndex. '
    'Setting this directly no longer drives rendering.',
  )
  set selected(bool value) {
    if (_selected != value) {
      _selected = value;
      onFocusChange?.call(value);
    }
  }

  /// Creates an auto suggest box item.
  SmartAutoSuggestItem({
    this.key,
    required this.value,
    required this.label,
    @Deprecated('Use titleBuilder instead') this.child,
    this.titleBuilder,
    this.subtitleBuilder,
    this.trailingBuilder,
    this.leadingBuilder,
    this.onFocusChange,
    this.onSelected,
    this.semanticLabel,
    this.enabled = true,
    this.subtitle,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SmartAutoSuggestItem) return false;
    if (key != null || other.key != null) {
      return key == other.key;
    }
    return other.value == value;
  }

  @override
  int get hashCode {
    if (key != null) return key.hashCode;
    return value.hashCode;
  }
}
