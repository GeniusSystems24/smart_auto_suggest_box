import 'dart:async';

import 'package:flutter/material.dart';

part 'smart_auto_suggest_controller.dart';
part 'smart_auto_suggest_data_source.dart';
part 'smart_auto_suggest_item.dart';

const kPickerHeight = 32.0;
const kPickerDiameterRatio = 100.0;
const kComboBoxRadius = Radius.circular(4.0);
const double kOneLineTileHeight = 40.0;
const double kComboBoxItemHeight = kOneLineTileHeight + 10;

typedef WidgetOrNullBuilder = Widget? Function(BuildContext context);
typedef SmartAutoSuggestSorter<T> =
    Set<SmartAutoSuggestItem<T>> Function(
      String text,
      Set<SmartAutoSuggestItem<T>> items,
    );

typedef OnChangeSmartAutoSuggestBox<T> =
    void Function(String text, FluentTextChangedReason reason);

typedef SmartAutoSuggestItemBuilder<T> =
    Widget Function(BuildContext context, SmartAutoSuggestItem<T> item);

enum FluentTextChangedReason {
  /// Whether the text in an [SmartAutoSuggestBox] was changed by user input
  userInput,

  /// Whether the text in an [SmartAutoSuggestBox] was changed because the user
  /// chose the suggestion
  suggestionChosen,

  /// Whether the text in an [SmartAutoSuggestBox] was cleared by the user
  cleared,
}

/// Controls when [SmartAutoSuggestDataSource.onSearch] is invoked.
enum SmartAutoSuggestSearchMode {
  /// Only calls [SmartAutoSuggestDataSource.onSearch] when local filtering
  /// yields no results. This is the default behavior.
  onNoLocalResults,

  /// Calls [SmartAutoSuggestDataSource.onSearch] on every text change
  /// (after debounce), regardless of local results.
  always,
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

// ─── Backward-compatibility aliases (deprecated) ────────────────────────────

/// Deprecated. Use [SmartAutoSuggestItem] instead.
@Deprecated('Use SmartAutoSuggestItem instead')
typedef SmartAutoSuggestBoxItem<T> = SmartAutoSuggestItem<T>;

/// Deprecated. Use [SmartAutoSuggestDataSource] instead.
@Deprecated('Use SmartAutoSuggestDataSource instead')
typedef SmartAutoSuggestBoxDataSource<T> = SmartAutoSuggestDataSource<T>;

/// Deprecated. Use [SmartAutoSuggestSearchMode] instead.
@Deprecated('Use SmartAutoSuggestSearchMode instead')
typedef SmartAutoSuggestBoxSearchMode = SmartAutoSuggestSearchMode;

/// Deprecated. Use [SmartAutoSuggestSorter] instead.
@Deprecated('Use SmartAutoSuggestSorter instead')
typedef SmartAutoSuggestBoxSorter<T> = SmartAutoSuggestSorter<T>;

/// Deprecated. Use [SmartAutoSuggestItemBuilder] instead.
@Deprecated('Use SmartAutoSuggestItemBuilder instead')
typedef SmartAutoSuggestBoxItemBuilder<T> = SmartAutoSuggestItemBuilder<T>;

// ─────────────────────────────────────────────────────────────────────────────
