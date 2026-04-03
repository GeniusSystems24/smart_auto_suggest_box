import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

import 'data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SmartAutoSuggestBox demo (floating overlay)
// ─────────────────────────────────────────────────────────────────────────────

class SmartAutoSuggestBoxDemo extends StatelessWidget {
  const SmartAutoSuggestBoxDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartAutoSuggestBox'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── 1. DataSource with initialList ───────────────────────────────
          sectionHeader(
            context,
            title: '1. DataSource with initialList',
            subtitle: 'Sync initial items via SmartAutoSuggestDataSource.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 2. Async onSearch ────────────────────────────────────────────
          sectionHeader(
            context,
            title: '2. DataSource with onSearch (async)',
            subtitle:
                'Calls onSearch when local filter yields no results. '
                'Simulates a 1 s server delay.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
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
              searchMode: SmartAutoSuggestSearchMode.onNoLocalResults,
              debounce: const Duration(milliseconds: 500),
            ),
            decoration: const InputDecoration(
              labelText: 'Server search',
              hintText: 'Type to fetch from server...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cloud_download),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 3. searchMode.always ─────────────────────────────────────────
          sectionHeader(
            context,
            title: '3. searchMode.always',
            subtitle:
                'onSearch fires on every keystroke (after debounce).',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits.take(3).toList(),
              onSearch: (context, current, searchText) async {
                await Future.delayed(const Duration(milliseconds: 600));
                return ['server_${searchText ?? ''}'];
              },
              searchMode: SmartAutoSuggestSearchMode.always,
              debounce: const Duration(milliseconds: 500),
            ),
            decoration: const InputDecoration(
              labelText: 'Always search',
              hintText: 'Every keystroke triggers server search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sync),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 4. selectedItemBuilder ──────────────────────────────────────
          sectionHeader(
            context,
            title: '4. Selected Item Builder',
            subtitle:
                'Shows a custom Chip widget after selection. '
                'Tap the chip to go back to the text field.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: (context, value) => SmartAutoSuggestItem(
                value: value,
                label: value[0].toUpperCase() + value.substring(1),
                child: Text(
                  '${fruitEmojis[value] ?? ''} ${value[0].toUpperCase() + value.substring(1)}',
                ),
              ),
              initialList: (context) => fruits,
            ),
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Select a fruit...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            selectedItemBuilder: (context, item) {
              final emoji = fruitEmojis[item.value] ?? '';
              return Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(color: Theme.of(context).colorScheme.outline),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    child: Text(emoji, style: const TextStyle(fontSize: 18)),
                  ),
                  title: Text(item.label),
                  trailing: Icon(
                    Icons.edit,
                    size: 18,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              );
            },
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 5. SmartAutoSuggestController ────────────────────────────────
          sectionHeader(
            context,
            title: '5. SmartAutoSuggestController',
            subtitle:
                'Use a controller to observe the selected item and '
                'clear it programmatically.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Select a fruit...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 6. Dropdown Directions ──────────────────────────────────────
          sectionHeader(
            context,
            title: '6. Dropdown Directions',
            subtitle: 'Each box uses a different direction.',
          ),
          const SizedBox(height: 8),
          for (final dir in SmartAutoSuggestBoxDirection.values) ...[
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                'Direction: ${dir.name}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
            SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => fruits,
              ),
              direction: dir,
              decoration: InputDecoration(
                labelText: 'Search (${dir.name})',
                hintText: 'Type to search...',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              onSelected: (item) {},
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
