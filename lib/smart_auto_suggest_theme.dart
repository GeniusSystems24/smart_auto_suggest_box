import 'package:flutter/material.dart';

/// A [ThemeExtension] for customizing the appearance of
/// [SmartAutoSuggestBox] and [SmartAutoSuggestView].
///
/// Provides granular control over colors, shadows, border radius,
/// padding, and text styles used by the suggestion widgets.
///
/// Usage with [ThemeData]:
/// ```dart
/// MaterialApp(
///   theme: ThemeData.light().copyWith(
///     extensions: [SmartAutoSuggestTheme.light()],
///   ),
///   darkTheme: ThemeData.dark().copyWith(
///     extensions: [SmartAutoSuggestTheme.dark()],
///   ),
/// )
/// ```
///
/// Or pass directly to a widget:
/// ```dart
/// SmartAutoSuggestBox<String>(
///   theme: SmartAutoSuggestTheme.light().copyWith(
///     overlayBorderRadius: BorderRadius.circular(12),
///   ),
///   // ...
/// )
/// ```
class SmartAutoSuggestTheme extends ThemeExtension<SmartAutoSuggestTheme> {
  /// Background color of the overlay / inline list.
  final Color? overlayColor;

  /// Color of the card inside the overlay.
  final Color? overlayCardColor;

  /// Box shadows applied to the overlay container.
  final List<BoxShadow>? overlayShadows;

  /// Border radius of the overlay container.
  final BorderRadius? overlayBorderRadius;

  /// Margin around the overlay container.
  final double? overlayMargin;

  /// Border shown between the text field and the inline list
  /// (used by [SmartAutoSuggestView]).
  final BorderSide? listBorderSide;

  // ── Tile ────────────────────────────────────────────────────────────────

  /// Background color of a suggestion tile.
  final Color? tileColor;

  /// Background color of a selected / focused suggestion tile.
  final Color? selectedTileColor;

  /// Foreground color (text/icon) of a selected / focused suggestion tile.
  final Color? selectedTileTextColor;

  /// Padding around each suggestion tile.
  final EdgeInsetsGeometry? tilePadding;

  /// Text style for the tile subtitle.
  final TextStyle? tileSubtitleStyle;

  // ── No-results & loading ────────────────────────────────────────────────

  /// Text style for "no results" subtitle.
  final TextStyle? noResultsSubtitleStyle;

  /// Text style for "searching in server" subtitle.
  final TextStyle? loadingSubtitleStyle;

  /// Height of the progress indicator shown during loading.
  final double? progressIndicatorHeight;

  /// Color of the progress indicator.
  final Color? progressIndicatorColor;

  // ── Divider ─────────────────────────────────────────────────────────────

  /// Indent for the divider between custom no-results widget and default text.
  final double? dividerIndent;

  // ── Disabled item ───────────────────────────────────────────────────────

  /// Text color for disabled items.
  final Color? disabledItemColor;

  /// Creates a [SmartAutoSuggestTheme].
  const SmartAutoSuggestTheme({
    this.overlayColor,
    this.overlayCardColor,
    this.overlayShadows,
    this.overlayBorderRadius,
    this.overlayMargin,
    this.listBorderSide,
    this.tileColor,
    this.selectedTileColor,
    this.selectedTileTextColor,
    this.tilePadding,
    this.tileSubtitleStyle,
    this.noResultsSubtitleStyle,
    this.loadingSubtitleStyle,
    this.progressIndicatorHeight,
    this.progressIndicatorColor,
    this.dividerIndent,
    this.disabledItemColor,
  });

  /// Light theme defaults.
  factory SmartAutoSuggestTheme.light() {
    const surface = Color(0xFFFFFBFE);
    const shadow = Colors.black;
    const outline = Color(0xFF79747E);
    const primaryContainer = Color(0xFFEADDFF);
    const onPrimaryContainer = Color(0xFF21005D);
    const outlineVariant = Color(0xFFCAC4D0);

    return SmartAutoSuggestTheme(
      overlayColor: surface,
      overlayCardColor: null, // falls back to CardTheme.color
      overlayShadows: [
        BoxShadow(
          color: shadow.withAlpha((255 * .1).toInt()),
          offset: const Offset(-1, 3),
          blurRadius: 2.0,
          spreadRadius: 3.0,
        ),
        BoxShadow(
          color: shadow.withAlpha((255 * .15).toInt()),
          offset: const Offset(1, 3),
          blurRadius: 2.0,
          spreadRadius: 3.0,
        ),
      ],
      overlayBorderRadius: BorderRadius.circular(4.0),
      overlayMargin: 8.0,
      listBorderSide: const BorderSide(color: outlineVariant, width: 1),
      tileColor: surface,
      selectedTileColor: primaryContainer,
      selectedTileTextColor: onPrimaryContainer,
      tilePadding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      tileSubtitleStyle: TextStyle(color: outline),
      noResultsSubtitleStyle: TextStyle(color: outline),
      loadingSubtitleStyle: TextStyle(fontSize: 14.0, color: outline),
      progressIndicatorHeight: 4.0,
      progressIndicatorColor: null, // use default theme
      dividerIndent: 12.0,
      disabledItemColor: outline,
    );
  }

  /// Dark theme defaults.
  factory SmartAutoSuggestTheme.dark() {
    const surface = Color(0xFF1C1B1F);
    const shadow = Colors.black;
    const outline = Color(0xFF938F99);
    const primaryContainer = Color(0xFF4F378B);
    const onPrimaryContainer = Color(0xFFEADDFF);
    const outlineVariant = Color(0xFF49454F);

    return SmartAutoSuggestTheme(
      overlayColor: surface,
      overlayCardColor: null,
      overlayShadows: [
        BoxShadow(
          color: shadow.withAlpha((255 * .15).toInt()),
          offset: const Offset(-1, 3),
          blurRadius: 2.0,
          spreadRadius: 3.0,
        ),
        BoxShadow(
          color: shadow.withAlpha((255 * .2).toInt()),
          offset: const Offset(1, 3),
          blurRadius: 2.0,
          spreadRadius: 3.0,
        ),
      ],
      overlayBorderRadius: BorderRadius.circular(4.0),
      overlayMargin: 8.0,
      listBorderSide: const BorderSide(color: outlineVariant, width: 1),
      tileColor: surface,
      selectedTileColor: primaryContainer,
      selectedTileTextColor: onPrimaryContainer,
      tilePadding: const EdgeInsets.only(left: 4, right: 4, top: 4),
      tileSubtitleStyle: TextStyle(color: outline),
      noResultsSubtitleStyle: TextStyle(color: outline),
      loadingSubtitleStyle: TextStyle(fontSize: 14.0, color: outline),
      progressIndicatorHeight: 4.0,
      progressIndicatorColor: null,
      dividerIndent: 12.0,
      disabledItemColor: outline,
    );
  }

  @override
  SmartAutoSuggestTheme copyWith({
    Color? overlayColor,
    Color? overlayCardColor,
    List<BoxShadow>? overlayShadows,
    BorderRadius? overlayBorderRadius,
    double? overlayMargin,
    BorderSide? listBorderSide,
    Color? tileColor,
    Color? selectedTileColor,
    Color? selectedTileTextColor,
    EdgeInsetsGeometry? tilePadding,
    TextStyle? tileSubtitleStyle,
    TextStyle? noResultsSubtitleStyle,
    TextStyle? loadingSubtitleStyle,
    double? progressIndicatorHeight,
    Color? progressIndicatorColor,
    double? dividerIndent,
    Color? disabledItemColor,
  }) {
    return SmartAutoSuggestTheme(
      overlayColor: overlayColor ?? this.overlayColor,
      overlayCardColor: overlayCardColor ?? this.overlayCardColor,
      overlayShadows: overlayShadows ?? this.overlayShadows,
      overlayBorderRadius: overlayBorderRadius ?? this.overlayBorderRadius,
      overlayMargin: overlayMargin ?? this.overlayMargin,
      listBorderSide: listBorderSide ?? this.listBorderSide,
      tileColor: tileColor ?? this.tileColor,
      selectedTileColor: selectedTileColor ?? this.selectedTileColor,
      selectedTileTextColor:
          selectedTileTextColor ?? this.selectedTileTextColor,
      tilePadding: tilePadding ?? this.tilePadding,
      tileSubtitleStyle: tileSubtitleStyle ?? this.tileSubtitleStyle,
      noResultsSubtitleStyle:
          noResultsSubtitleStyle ?? this.noResultsSubtitleStyle,
      loadingSubtitleStyle: loadingSubtitleStyle ?? this.loadingSubtitleStyle,
      progressIndicatorHeight:
          progressIndicatorHeight ?? this.progressIndicatorHeight,
      progressIndicatorColor:
          progressIndicatorColor ?? this.progressIndicatorColor,
      dividerIndent: dividerIndent ?? this.dividerIndent,
      disabledItemColor: disabledItemColor ?? this.disabledItemColor,
    );
  }

  @override
  SmartAutoSuggestTheme lerp(
    covariant ThemeExtension<SmartAutoSuggestTheme>? other,
    double t,
  ) {
    if (other is! SmartAutoSuggestTheme) return this;
    return SmartAutoSuggestTheme(
      overlayColor: Color.lerp(overlayColor, other.overlayColor, t),
      overlayCardColor: Color.lerp(overlayCardColor, other.overlayCardColor, t),
      overlayShadows:
          t < 0.5 ? overlayShadows : other.overlayShadows,
      overlayBorderRadius:
          BorderRadius.lerp(overlayBorderRadius, other.overlayBorderRadius, t),
      overlayMargin: _lerpDouble(overlayMargin, other.overlayMargin, t),
      listBorderSide: BorderSide.lerp(
        listBorderSide ?? BorderSide.none,
        other.listBorderSide ?? BorderSide.none,
        t,
      ),
      tileColor: Color.lerp(tileColor, other.tileColor, t),
      selectedTileColor:
          Color.lerp(selectedTileColor, other.selectedTileColor, t),
      selectedTileTextColor:
          Color.lerp(selectedTileTextColor, other.selectedTileTextColor, t),
      tilePadding: EdgeInsetsGeometry.lerp(tilePadding, other.tilePadding, t),
      tileSubtitleStyle:
          TextStyle.lerp(tileSubtitleStyle, other.tileSubtitleStyle, t),
      noResultsSubtitleStyle:
          TextStyle.lerp(noResultsSubtitleStyle, other.noResultsSubtitleStyle, t),
      loadingSubtitleStyle:
          TextStyle.lerp(loadingSubtitleStyle, other.loadingSubtitleStyle, t),
      progressIndicatorHeight: _lerpDouble(
        progressIndicatorHeight,
        other.progressIndicatorHeight,
        t,
      ),
      progressIndicatorColor:
          Color.lerp(progressIndicatorColor, other.progressIndicatorColor, t),
      dividerIndent: _lerpDouble(dividerIndent, other.dividerIndent, t),
      disabledItemColor:
          Color.lerp(disabledItemColor, other.disabledItemColor, t),
    );
  }

  static double? _lerpDouble(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
