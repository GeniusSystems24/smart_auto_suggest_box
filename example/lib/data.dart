import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sample data
// ─────────────────────────────────────────────────────────────────────────────

List<String> get fruits => [
  'apple',
  'apricot',
  'avocado',
  'banana',
  'cherry',
  'date',
  'elderberry',
  'fig',
  'grape',
  'honeydew',
  'kiwi',
  'lemon',
  'mango',
  'orange',
];

/// Shared item builder used across demos.
SmartAutoSuggestItem<String> fruitItemBuilder(
  BuildContext context,
  String value,
) {
  return SmartAutoSuggestItem(
    key: value,
    value: value,
    label: value[0].toUpperCase() + value.substring(1),
  );
}

const fruitEmojis = <String, String>{
  'apple': '🍎',
  'apricot': '🍑',
  'avocado': '🥑',
  'banana': '🍌',
  'cherry': '🍒',
  'date': '🌴',
  'elderberry': '🫐',
  'fig': '🟤',
  'grape': '🍇',
  'honeydew': '🍈',
  'kiwi': '🥝',
  'lemon': '🍋',
  'mango': '🥭',
  'orange': '🍊',
};

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Widget sectionHeader(
  BuildContext context, {
  required String title,
  required String subtitle,
}) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget shimmerRow(BuildContext context) {
  final color = Theme.of(context).colorScheme.onSurface.withValues(alpha: .08);
  return Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              height: 10,
              width: 120,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
