part of 'common.dart';

/// A controller for [SmartAutoSuggestMultiSelectBox] that manages the text
/// input and the set of currently selected items.
///
/// If no external [TextEditingController] is provided, one is created
/// internally and disposed automatically.
class SmartAutoSuggestMultiSelectController<T> {
  /// Creates a multi-select controller with an optional [textController].
  SmartAutoSuggestMultiSelectController({TextEditingController? textController})
      : textController = textController ?? TextEditingController(),
        _ownsTextController = textController == null;

  /// The text editing controller for the input field.
  final TextEditingController textController;

  /// Whether this controller created the [textController] internally.
  final bool _ownsTextController;

  /// Notifier for the currently selected items.
  final ValueNotifier<Set<SmartAutoSuggestItem<T>>> selectedItems =
      ValueNotifier<Set<SmartAutoSuggestItem<T>>>({});

  /// Whether [item] is currently selected.
  bool isSelected(SmartAutoSuggestItem<T> item) =>
      selectedItems.value.contains(item);

  /// Adds [item] to the selection.
  void select(SmartAutoSuggestItem<T> item) {
    selectedItems.value = {...selectedItems.value, item};
  }

  /// Removes [item] from the selection.
  void deselect(SmartAutoSuggestItem<T> item) {
    final updated = {...selectedItems.value}..remove(item);
    selectedItems.value = updated;
  }

  /// Toggles [item] selection state.
  void toggleSelection(SmartAutoSuggestItem<T> item) {
    if (isSelected(item)) {
      deselect(item);
    } else {
      select(item);
    }
  }

  /// Clears all selected items and the text field.
  void clearAll() {
    selectedItems.value = {};
    textController.clear();
  }

  /// Releases resources used by this controller.
  void dispose() {
    if (_ownsTextController) textController.dispose();
    selectedItems.dispose();
  }
}
