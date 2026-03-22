import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Auto Suggest Box Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SmartAutoSuggestBoxExample(),
    );
  }
}

class SmartAutoSuggestBoxExample extends StatefulWidget {
  const SmartAutoSuggestBoxExample({super.key});

  @override
  State<SmartAutoSuggestBoxExample> createState() =>
      _SmartAutoSuggestBoxExampleState();
}

class _SmartAutoSuggestBoxExampleState
    extends State<SmartAutoSuggestBoxExample> {
  SmartAutoSuggestBoxDirection _selectedDirection =
      SmartAutoSuggestBoxDirection.bottom;
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Auto Suggest Box'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // ── Direction selector ──
          const Text(
            'Dropdown Direction:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            selected: {_selectedDirection},
            onSelectionChanged: (value) {
              setState(() => _selectedDirection = value.first);
            },
          ),
          const SizedBox(height: 24),

          // ── 1. DataSource with initialList ──
          _buildSectionHeader(
            context,
            title: '1. DataSource with initialList',
            subtitle: 'Uses SmartAutoSuggestBoxDataSource to provide initial items.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestBoxDataSource(
              initialList: (context) => [
                SmartAutoSuggestBoxItem(value: 'apple', label: 'Apple'),
                SmartAutoSuggestBoxItem(value: 'banana', label: 'Banana'),
                SmartAutoSuggestBoxItem(value: 'cherry', label: 'Cherry'),
                SmartAutoSuggestBoxItem(value: 'date', label: 'Date'),
                SmartAutoSuggestBoxItem(value: 'elderberry', label: 'Elderberry'),
                SmartAutoSuggestBoxItem(value: 'fig', label: 'Fig'),
                SmartAutoSuggestBoxItem(value: 'grape', label: 'Grape'),
                SmartAutoSuggestBoxItem(value: 'honeydew', label: 'Honeydew'),
                SmartAutoSuggestBoxItem(value: 'kiwi', label: 'Kiwi'),
                SmartAutoSuggestBoxItem(value: 'lemon', label: 'Lemon'),
                SmartAutoSuggestBoxItem(value: 'mango', label: 'Mango'),
                SmartAutoSuggestBoxItem(value: 'orange', label: 'Orange'),
              ],
            ),
            direction: _selectedDirection,
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Type to search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onSelected: (item) {
              if (item != null) {
                setState(() => _selectedValue = item.label);
              }
            },
            onChanged: (text, reason) {
              if (reason == FluentTextChangedReason.cleared) {
                setState(() => _selectedValue = null);
              }
            },
          ),
          if (_selectedValue != null) ...[
            const SizedBox(height: 8),
            Text(
              'Selected: $_selectedValue',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
          const SizedBox(height: 32),

          // ── 2. DataSource with onSearch (async) ──
          _buildSectionHeader(
            context,
            title: '2. DataSource with onSearch',
            subtitle:
                'Simulates async server search. Type a fruit name to trigger.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestBoxDataSource(
              initialList: (context) => [],
              onSearch: (context, currentItems, searchText) async {
                // Simulate network delay
                await Future.delayed(const Duration(seconds: 1));
                final allFruits = [
                  'Apple', 'Apricot', 'Avocado', 'Banana', 'Blackberry',
                  'Blueberry', 'Cherry', 'Coconut', 'Cranberry', 'Date',
                  'Dragonfruit', 'Elderberry', 'Fig', 'Grape', 'Guava',
                  'Honeydew', 'Jackfruit', 'Kiwi', 'Lemon', 'Lime',
                  'Lychee', 'Mango', 'Melon', 'Nectarine', 'Orange',
                  'Papaya', 'Peach', 'Pear', 'Pineapple', 'Plum',
                  'Pomegranate', 'Raspberry', 'Strawberry', 'Watermelon',
                ];
                return allFruits
                    .where((f) => f.toLowerCase().contains(
                        (searchText ?? '').toLowerCase()))
                    .map((f) => SmartAutoSuggestBoxItem(
                          value: f.toLowerCase(),
                          label: f,
                        ))
                    .toList();
              },
              searchMode: SmartAutoSuggestBoxSearchMode.onNoLocalResults,
              debounce: const Duration(milliseconds: 500),
            ),
            direction: _selectedDirection,
            decoration: const InputDecoration(
              labelText: 'Server search',
              hintText: 'Type to search from server...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cloud_download),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 3. DataSource with searchMode.always ──
          _buildSectionHeader(
            context,
            title: '3. DataSource with searchMode.always',
            subtitle:
                'Calls onSearch on every keystroke (after debounce), '
                'regardless of local results.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestBoxDataSource(
              initialList: (context) => [
                SmartAutoSuggestBoxItem(value: 'apple', label: 'Apple'),
                SmartAutoSuggestBoxItem(value: 'banana', label: 'Banana'),
              ],
              onSearch: (context, currentItems, searchText) async {
                await Future.delayed(const Duration(milliseconds: 800));
                // Simulate returning additional items from server
                return [
                  SmartAutoSuggestBoxItem(
                    value: 'server_${searchText ?? ''}',
                    label: 'Server result: ${searchText ?? ''}',
                  ),
                ];
              },
              searchMode: SmartAutoSuggestBoxSearchMode.always,
              debounce: const Duration(milliseconds: 600),
            ),
            direction: _selectedDirection,
            decoration: const InputDecoration(
              labelText: 'Always search',
              hintText: 'Every keystroke triggers server search...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.sync),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 4. Deprecated items (backward compat) ──
          _buildSectionHeader(
            context,
            title: '4. Deprecated items parameter',
            subtitle: 'Still works for backward compatibility.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            // ignore: deprecated_member_use
            items: [
              SmartAutoSuggestBoxItem(value: 'red', label: 'Red'),
              SmartAutoSuggestBoxItem(value: 'green', label: 'Green'),
              SmartAutoSuggestBoxItem(value: 'blue', label: 'Blue'),
              SmartAutoSuggestBoxItem(value: 'yellow', label: 'Yellow'),
            ],
            direction: _selectedDirection,
            decoration: const InputDecoration(
              labelText: 'Colors (deprecated API)',
              hintText: 'Type to filter...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.palette),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
}
