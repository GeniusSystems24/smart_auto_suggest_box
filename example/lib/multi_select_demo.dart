import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

import 'data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SmartAutoSuggestMultiSelectBox demo
// ─────────────────────────────────────────────────────────────────────────────

class MultiSelectDemo extends StatelessWidget {
  const MultiSelectDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MultiSelectBox'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── 1. Basic Multi-Select ─────────────────────────────────────
          sectionHeader(
            context,
            title: '1. Basic Multi-Select',
            subtitle:
                'Select multiple fruits. Selected items appear as chips '
                'below the field. Max 3 chips visible by default.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestMultiSelectBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            decoration: const InputDecoration(
              labelText: 'Select fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSelectionChanged: (selected) {},
          ),
          const SizedBox(height: 32),

          // ── 2. Max Selections ─────────────────────────────────────────
          sectionHeader(
            context,
            title: '2. Max Selections (5)',
            subtitle:
                'Limited to 5 selections. Remaining items are disabled '
                'once the limit is reached. Tap a selected item in the '
                'overlay to deselect it.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestMultiSelectBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            maxSelections: 5,
            decoration: const InputDecoration(
              labelText: 'Pick up to 5 fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.checklist),
            ),
            onSelectionChanged: (selected) {},
          ),
          const SizedBox(height: 32),

          // ── 3. Custom maxVisibleChips ──────────────────────────────────
          sectionHeader(
            context,
            title: '3. Custom maxVisibleChips (2)',
            subtitle:
                'Only 2 chips are visible. Select more to see the '
                '"Show all" button that opens a BottomSheet.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestMultiSelectBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            maxVisibleChips: 2,
            decoration: const InputDecoration(
              labelText: 'Select fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.filter_list),
            ),
            onSelectionChanged: (selected) {},
          ),
          const SizedBox(height: 32),

          // ── 4. Custom Chip Builder ────────────────────────────────────
          sectionHeader(
            context,
            title: '4. Custom Chip Builder',
            subtitle:
                'Custom chip with emoji, colored background, and a '
                'delete icon.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestMultiSelectBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            chipBuilder: (context, item, onRemove) {
              final emoji = fruitEmojis[item.value] ?? '';
              final colors = [
                Colors.red,
                Colors.orange,
                Colors.green,
                Colors.purple,
                Colors.blue,
              ];
              final color = colors[item.label.length % colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: color.withValues(alpha: .3),
                    ),
                  ),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity.compact,
                    leading: Text(emoji, style: const TextStyle(fontSize: 20)),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.close, size: 18, color: color),
                      onPressed: onRemove,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
                ),
              );
            },
            decoration: const InputDecoration(
              labelText: 'Select fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.style),
            ),
            onSelectionChanged: (selected) {},
          ),
          const SizedBox(height: 32),

          // ── 5. Controller ─────────────────────────────────────────────
          sectionHeader(
            context,
            title: '5. MultiSelectController',
            subtitle:
                'Use a controller to observe selections and clear '
                'them programmatically.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestMultiSelectBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            decoration: const InputDecoration(
              labelText: 'Select fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSelectionChanged: (selected) {},
          ),
          const SizedBox(height: 32),

          // ── 6. Async Search ───────────────────────────────────────────
          sectionHeader(
            context,
            title: '6. Async Search',
            subtitle:
                'Multi-select with server-side search. Simulates a '
                '1 second delay.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestMultiSelectBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => [],
              onSearch: (context, current, searchText) async {
                await Future.delayed(const Duration(seconds: 1));
                return fruits
                    .where((f) => f
                        .toLowerCase()
                        .contains((searchText ?? '').toLowerCase()))
                    .toList();
              },
              debounce: const Duration(milliseconds: 500),
            ),
            decoration: const InputDecoration(
              labelText: 'Server search',
              hintText: 'Type to fetch from server...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cloud_download),
            ),
            onSelectionChanged: (selected) {},
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
