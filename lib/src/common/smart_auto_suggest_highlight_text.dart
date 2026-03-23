part of 'common.dart';

/// A widget that highlights the matching portion of [text] based on [query].
///
/// The matching part is rendered with [matchStyle] (defaults to bold with
/// the theme's primary color). The non-matching parts use [baseStyle]
/// (defaults to the current [DefaultTextStyle]).
///
/// The comparison is case-insensitive.
///
/// ```dart
/// SmartAutoSuggestHighlightText(
///   text: 'Apple',
///   query: 'app',
/// )
/// ```
class SmartAutoSuggestHighlightText extends StatelessWidget {
  /// Creates a highlighted text widget.
  const SmartAutoSuggestHighlightText({
    super.key,
    required this.text,
    required this.query,
    this.baseStyle,
    this.matchStyle,
    this.maxLines,
    this.overflow,
  });

  /// The full text to display.
  final String text;

  /// The search query. Matching portions of [text] will be highlighted.
  final String query;

  /// Style for non-matching text. Defaults to [DefaultTextStyle].
  final TextStyle? baseStyle;

  /// Style for the matching portion. Defaults to bold with the theme's
  /// primary color.
  final TextStyle? matchStyle;

  /// Maximum number of lines.
  final int? maxLines;

  /// Text overflow behavior.
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBase =
        baseStyle ?? DefaultTextStyle.of(context).style;
    final effectiveMatch = matchStyle ??
        effectiveBase.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        );

    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      return Text(
        text,
        style: effectiveBase,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final matchIndex = lowerText.indexOf(lowerQuery);

    if (matchIndex == -1) {
      return Text(
        text,
        style: effectiveBase,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    final before = text.substring(0, matchIndex);
    final match = text.substring(matchIndex, matchIndex + trimmedQuery.length);
    final after = text.substring(matchIndex + trimmedQuery.length);

    return Text.rich(
      TextSpan(
        children: [
          if (before.isNotEmpty) TextSpan(text: before, style: effectiveBase),
          TextSpan(text: match, style: effectiveMatch),
          if (after.isNotEmpty) TextSpan(text: after, style: effectiveBase),
        ],
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
