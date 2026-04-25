import 'dart:async';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

part 'smart_auto_suggest_controller.dart';
part 'smart_auto_suggest_data_source.dart';
part 'smart_auto_suggest_engine.dart';
part 'smart_auto_suggest_highlight_text.dart';
part 'smart_auto_suggest_item.dart';
part 'smart_auto_suggest_multi_select_controller.dart';

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
    Widget Function(
      BuildContext context,
      SmartAutoSuggestItem<T> item,
      String? searchText,
      bool isFocused,
    );

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

/// Merges a user-provided [user] [BoxConstraints] override on top of
/// internally-computed [defaults].
///
/// A field on [user] is considered "unset" (and therefore falls through to
/// the corresponding [defaults] value) when it sits at the [BoxConstraints]
/// constructor's own default — `0.0` for minimums and
/// [double.infinity] for maximums. Any other value is treated as an
/// explicit override.
///
/// This makes the common Flutter idiom work intuitively:
///
/// ```dart
/// // Only minWidth is overridden; maxWidth/min/maxHeight inherit defaults.
/// final merged = mergeOverlayCardConstraints(
///   user: const BoxConstraints(minWidth: 400),
///   defaults: BoxConstraints(maxHeight: 380),
/// );
/// // → BoxConstraints(minWidth: 400, maxWidth: ∞, minHeight: 0, maxHeight: 380)
/// ```
BoxConstraints mergeOverlayCardConstraints({
  required BoxConstraints? user,
  required BoxConstraints defaults,
}) {
  if (user == null) return defaults;
  return BoxConstraints(
    minWidth: user.minWidth != 0.0 ? user.minWidth : defaults.minWidth,
    maxWidth: user.maxWidth != double.infinity
        ? user.maxWidth
        : defaults.maxWidth,
    minHeight: user.minHeight != 0.0 ? user.minHeight : defaults.minHeight,
    maxHeight: user.maxHeight != double.infinity
        ? user.maxHeight
        : defaults.maxHeight,
  );
}

/// Caps [constraints] so that neither axis can ever ask for more space
/// than the current viewport. Applied as the final step on top of
/// [mergeOverlayCardConstraints] so that user-supplied minimums or
/// maximums (e.g. `minWidth: 2000` on a tablet-in-portrait window) can't
/// push the overlay off-screen.
///
/// [screenSize] should come from `MediaQuery.sizeOf(context)` captured
/// inside the overlay builder — that rebuild path runs on window resizes
/// (desktop) and orientation changes (mobile), so the clamp adapts
/// automatically.
///
/// The clamp normalizes each side:
///  - `maxWidth`  is capped at `screenSize.width`  (`maxHeight` likewise).
///  - `minWidth`/`minHeight` are then clamped to the resulting maxima so
///    the returned constraints always satisfy `min ≤ max`.
BoxConstraints clampOverlayCardConstraintsToScreen(
  BoxConstraints constraints,
  Size screenSize,
) {
  final maxW = constraints.maxWidth
      .clamp(0.0, screenSize.width)
      .toDouble();
  final maxH = constraints.maxHeight
      .clamp(0.0, screenSize.height)
      .toDouble();
  return BoxConstraints(
    minWidth: constraints.minWidth.clamp(0.0, maxW).toDouble(),
    maxWidth: maxW,
    minHeight: constraints.minHeight.clamp(0.0, maxH).toDouble(),
    maxHeight: maxH,
  );
}

/// Whether the current platform is a desktop platform (Windows, macOS, Linux).
///
/// Used to enable keyboard-driven features such as auto-focusing the first
/// item in the overlay when it opens.
bool get isDesktopPlatform {
  switch (defaultTargetPlatform) {
    case TargetPlatform.windows:
    case TargetPlatform.macOS:
    case TargetPlatform.linux:
      return true;
    default:
      return false;
  }
}

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
