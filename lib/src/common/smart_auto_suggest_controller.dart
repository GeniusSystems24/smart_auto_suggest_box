part of 'common.dart';

/// A controller for [SmartAutoSuggestBox] and [SmartAutoSuggestView] that
/// provides access to the text input and the currently selected item.
///
/// ```dart
/// final controller = SmartAutoSuggestController<String>();
///
/// // Listen to selection changes
/// controller.selectedItem.addListener(() {
///   print('Selected: ${controller.selectedItem.value?.label}');
/// });
///
/// // Read current text
/// print(controller.textController.text);
///
/// // Clear selection programmatically
/// controller.clearSelection();
/// ```
class SmartAutoSuggestController<T> {
  /// Creates a controller with an optional initial [TextEditingController].
  ///
  /// If [textController] is not provided, a new one is created internally.
  SmartAutoSuggestController({TextEditingController? textController})
      : textController = textController ?? TextEditingController(),
        _ownsTextController = textController == null;

  /// The text editing controller for the input field.
  final TextEditingController textController;

  /// Whether this controller created the [textController] internally.
  final bool _ownsTextController;

  /// Notifier for the currently selected item.
  ///
  /// The value is `null` when no item is selected. Listen to this notifier
  /// to react to selection changes.
  final ValueNotifier<SmartAutoSuggestItem<T>?> selectedItem =
      ValueNotifier<SmartAutoSuggestItem<T>?>(null);

  /// Clears the current selection and the text field.
  void clearSelection() {
    selectedItem.value = null;
    textController.clear();
  }

  /// Sets the selected item and updates the text field to its label.
  void select(SmartAutoSuggestItem<T> item) {
    selectedItem.value = item;
    textController
      ..text = item.label
      ..selection = TextSelection.collapsed(offset: item.label.length);
  }

  /// Releases resources used by this controller.
  ///
  /// After calling dispose, the controller must not be used.
  void dispose() {
    if (_ownsTextController) {
      textController.dispose();
    }
    selectedItem.dispose();
  }
}
