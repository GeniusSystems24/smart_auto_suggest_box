part of 'common.dart';

/// An item used in [SmartAutoSuggestBox]
class SmartAutoSuggestItem<T> {
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
  bool get selected => _selected;
  set selected(bool value) {
    if (_selected != value) {
      _selected = value;
      onFocusChange?.call(value);
    }
  }

  /// Creates an auto suggest box item
  SmartAutoSuggestItem({
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

    return other is SmartAutoSuggestItem && other.value == value;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }
}
