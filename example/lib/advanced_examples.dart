import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';

import 'data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Advanced examples
// ─────────────────────────────────────────────────────────────────────────────

class AdvancedExamplesDemo extends StatefulWidget {
  const AdvancedExamplesDemo({super.key});

  @override
  State<AdvancedExamplesDemo> createState() => _AdvancedExamplesDemoState();
}

class _AdvancedExamplesDemoState extends State<AdvancedExamplesDemo> {
  String? _bottomSheetSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── 1. BottomSheet ──────────────────────────────────────────────
          sectionHeader(
            context,
            title: '1. SmartAutoSuggestView in BottomSheet',
            subtitle:
                'Open a modal bottom sheet with a searchable suggestion list.',
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => _openBottomSheet(context),
            icon: const Icon(Icons.arrow_upward),
            label: Text(
              _bottomSheetSelected != null
                  ? 'Selected: $_bottomSheetSelected'
                  : 'Open BottomSheet',
            ),
          ),
          const SizedBox(height: 32),

          // ── 2. Custom noResultsFoundBuilder ─────────────────────────────
          sectionHeader(
            context,
            title: '2. Custom No-Results View',
            subtitle:
                'Shows a custom widget when no items match. '
                'Try typing something that doesn\'t exist.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Try "xyz" to see custom no-results...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            noResultsFoundBuilder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.search_off, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  const Text(
                    'No matching fruits found',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try a different search term or add a new item.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Add new item tapped!')),
                      );
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add new item'),
                  ),
                ],
              );
            },
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 3. Custom itemBuilder ───────────────────────────────────────
          sectionHeader(
            context,
            title: '3. Custom Item Builder',
            subtitle:
                'Custom tile with leading icon, subtitle, and trailing badge.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: (context, value) => SmartAutoSuggestItem(
                value: value,
                label: value[0].toUpperCase() + value.substring(1),
                child: Text(
                    '${fruitEmojis[value] ?? ''} ${value[0].toUpperCase() + value.substring(1)}'),
              ),
              initialList: (context) => fruits,
            ),
            tileHeight: 72,
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Type to filter...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            itemBuilder: (context, item) {
              final emoji = fruitEmojis[item.value] ?? '';
              final colors = [
                Colors.red,
                Colors.orange,
                Colors.green,
                Colors.purple,
                Colors.blue,
              ];
              final color = colors[item.label.length % colors.length];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: .15),
                  child: Text(emoji, style: const TextStyle(fontSize: 20)),
                ),
                title: Text(item.label),
                subtitle: Text(
                  'Value: ${item.value}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${item.label.length} chars',
                    style: TextStyle(fontSize: 11, color: color),
                  ),
                ),
                onTap: () {},
              );
            },
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 4. Custom waitingBuilder ─────────────────────────────────────
          sectionHeader(
            context,
            title: '4. Custom Loading View',
            subtitle:
                'Custom shimmer-style placeholder while searching server. '
                'Type something to trigger.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => [],
              onSearch: (context, current, searchText) async {
                await Future.delayed(const Duration(seconds: 2));
                return fruits
                    .where((f) => f
                        .toLowerCase()
                        .contains((searchText ?? '').toLowerCase()))
                    .toList();
              },
              debounce: const Duration(milliseconds: 300),
            ),
            decoration: const InputDecoration(
              labelText: 'Server search (slow)',
              hintText: 'Type to see custom loading...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cloud_download),
            ),
            waitingBuilder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Searching...',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Shimmer placeholder rows
                    for (var i = 0; i < 3; i++) ...[
                      shimmerRow(context),
                      if (i < 2) const SizedBox(height: 8),
                    ],
                  ],
                ),
              );
            },
            onSelected: (item) {},
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant
                          .withValues(alpha: .4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Select a fruit',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // SmartAutoSuggestView fills remaining space
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SmartAutoSuggestView<String>(
                      dataSource: SmartAutoSuggestDataSource(
                        itemBuilder: fruitItemBuilder,
                        initialList: (context) => fruits,
                      ),
                      showListWhenEmpty: true,
                      listMaxHeight: double.infinity,
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        hintText: 'Type to filter...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.search),
                      ),
                      onSelected: (item) {
                        if (item != null) {
                          setState(() => _bottomSheetSelected = item.label);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
