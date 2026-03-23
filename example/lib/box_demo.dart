import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

import 'data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SmartAutoSuggestBox demo (floating overlay)
// ─────────────────────────────────────────────────────────────────────────────

class SmartAutoSuggestBoxDemo extends StatefulWidget {
  const SmartAutoSuggestBoxDemo({super.key});

  @override
  State<SmartAutoSuggestBoxDemo> createState() =>
      _SmartAutoSuggestBoxDemoState();
}

class _SmartAutoSuggestBoxDemoState extends State<SmartAutoSuggestBoxDemo> {
  SmartAutoSuggestBoxDirection _direction =
      SmartAutoSuggestBoxDirection.bottom;
  String? _selected;

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
          // Direction selector
          const Text(
            'Dropdown Direction:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SegmentedButton<SmartAutoSuggestBoxDirection>(
            segments: const [
              ButtonSegment(
                value: SmartAutoSuggestBoxDirection.bottom,
                label: Text('Bottom'),
                icon: Icon(Icons.arrow_downward),
              ),
              ButtonSegment(
                value: SmartAutoSuggestBoxDirection.top,
                label: Text('Top'),
                icon: Icon(Icons.arrow_upward),
              ),
              ButtonSegment(
                value: SmartAutoSuggestBoxDirection.start,
                label: Text('Start'),
                icon: Icon(Icons.arrow_back),
              ),
              ButtonSegment(
                value: SmartAutoSuggestBoxDirection.end,
                label: Text('End'),
                icon: Icon(Icons.arrow_forward),
              ),
            ],
            selected: {_direction},
            onSelectionChanged: (v) => setState(() => _direction = v.first),
          ),
          const SizedBox(height: 24),

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
            direction: _direction,
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSelected: (item) {
              if (item != null) setState(() => _selected = item.label);
            },
            onChanged: (text, reason) {
              if (reason == FluentTextChangedReason.cleared) {
                setState(() => _selected = null);
              }
            },
          ),
          if (_selected != null) ...[
            const SizedBox(height: 8),
            Text(
              'Selected: $_selected',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
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
                    .where((f) => f.toLowerCase().contains(
                        (searchText ?? '').toLowerCase()))
                    .toList();
              },
              searchMode: SmartAutoSuggestSearchMode.onNoLocalResults,
              debounce: const Duration(milliseconds: 500),
            ),
            direction: _direction,
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
            direction: _direction,
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
            direction: _direction,
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Select a fruit...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            selectedItemBuilder: (context, item) {
              final emoji = fruitEmojis[item.value] ?? '';
              return InputDecorator(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
                child: Row(
                  children: [
                    Chip(
                      avatar: Text(emoji, style: const TextStyle(fontSize: 18)),
                      label: Text(item.label),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {},
                    ),
                    const Spacer(),
                    Icon(
                      Icons.edit,
                      size: 18,
                      color: Theme.of(context).colorScheme.outline,
                    ),
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
}
