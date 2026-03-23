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
  /// Deprecated: Use [builder] instead, which wraps the widget in a
  /// [Focus] widget for keyboard navigation support.
  @Deprecated('Use builder instead')
  final Widget? child;

  /// Optional subtitle widget.
  final Widget? subtitle;

  /// Builder for a custom item widget.
  ///
  /// The returned widget is wrapped in a [Focus] widget so that keyboard
  /// navigation (arrow keys) highlights the item correctly.
  ///
  /// The [searchText] parameter contains the current search query, which
  /// can be used to highlight matching portions of the label.
  final Widget Function(BuildContext context, String searchText)? builder;

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
  bool get selected => _selected;
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
    @Deprecated('Use builder instead') this.child,
    this.builder,
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
