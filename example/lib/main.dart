import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/generated/l10n.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Auto Suggest Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        SmartAutoSuggestBoxLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales:
          SmartAutoSuggestBoxLocalizations.delegate.supportedLocales,
      home: const _DemoHome(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Home with bottom navigation between the two widget demos
// ─────────────────────────────────────────────────────────────────────────────

class _DemoHome extends StatefulWidget {
  const _DemoHome();

  @override
  State<_DemoHome> createState() => _DemoHomeState();
}

class _DemoHomeState extends State<_DemoHome> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          SmartAutoSuggestBoxDemo(),
          SmartAutoSuggestViewDemo(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            label: 'Box (floating)',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'View (inline)',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sample data
// ─────────────────────────────────────────────────────────────────────────────

List<SmartAutoSuggestItem<String>> get _fruits => [
      SmartAutoSuggestItem(value: 'apple', label: 'Apple'),
      SmartAutoSuggestItem(value: 'apricot', label: 'Apricot'),
      SmartAutoSuggestItem(value: 'avocado', label: 'Avocado'),
      SmartAutoSuggestItem(value: 'banana', label: 'Banana'),
      SmartAutoSuggestItem(value: 'cherry', label: 'Cherry'),
      SmartAutoSuggestItem(value: 'date', label: 'Date'),
      SmartAutoSuggestItem(value: 'elderberry', label: 'Elderberry'),
      SmartAutoSuggestItem(value: 'fig', label: 'Fig'),
      SmartAutoSuggestItem(value: 'grape', label: 'Grape'),
      SmartAutoSuggestItem(value: 'honeydew', label: 'Honeydew'),
      SmartAutoSuggestItem(value: 'kiwi', label: 'Kiwi'),
      SmartAutoSuggestItem(value: 'lemon', label: 'Lemon'),
      SmartAutoSuggestItem(value: 'mango', label: 'Mango'),
      SmartAutoSuggestItem(value: 'orange', label: 'Orange'),
    ];

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
          _sectionHeader(
            context,
            title: '1. DataSource with initialList',
            subtitle: 'Sync initial items via SmartAutoSuggestDataSource.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              initialList: (context) => _fruits,
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
          _sectionHeader(
            context,
            title: '2. DataSource with onSearch (async)',
            subtitle:
                'Calls onSearch when local filter yields no results. '
                'Simulates a 1 s server delay.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              initialList: (context) => [],
              onSearch: (context, current, searchText) async {
                await Future.delayed(const Duration(seconds: 1));
                return _fruits
                    .where((f) => f.label.toLowerCase().contains(
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
          _sectionHeader(
            context,
            title: '3. searchMode.always',
            subtitle:
                'onSearch fires on every keystroke (after debounce).',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              initialList: (context) => _fruits.take(3).toList(),
              onSearch: (context, current, searchText) async {
                await Future.delayed(const Duration(milliseconds: 600));
                return [
                  SmartAutoSuggestItem(
                    value: 'server_${searchText ?? ''}',
                    label: '🔍 Server: ${searchText ?? ''}',
                  ),
                ];
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
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SmartAutoSuggestView demo (inline list)
// ─────────────────────────────────────────────────────────────────────────────

class SmartAutoSuggestViewDemo extends StatefulWidget {
  const SmartAutoSuggestViewDemo({super.key});

  @override
  State<SmartAutoSuggestViewDemo> createState() =>
      _SmartAutoSuggestViewDemoState();
}

class _SmartAutoSuggestViewDemoState extends State<SmartAutoSuggestViewDemo> {
  String? _selected;
  bool _showListWhenEmpty = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartAutoSuggestView'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Options
                SwitchListTile(
                  title: const Text('showListWhenEmpty'),
                  subtitle: const Text(
                    'Show suggestions when text field is empty',
                  ),
                  value: _showListWhenEmpty,
                  onChanged: (v) => setState(() => _showListWhenEmpty = v),
                  contentPadding: EdgeInsets.zero,
                ),
                if (_selected != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Selected: $_selected',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // The SmartAutoSuggestView fills remaining space
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SmartAutoSuggestView<String>(
                dataSource: SmartAutoSuggestDataSource(
                  initialList: (context) => _fruits,
                  onSearch: (context, current, searchText) async {
                    // Simulate server returning extra items
                    await Future.delayed(const Duration(milliseconds: 700));
                    return [
                      SmartAutoSuggestItem(
                        value: 'server_${searchText ?? ''}',
                        label: '🔍 Server: ${searchText ?? ''}',
                      ),
                    ];
                  },
                  searchMode: SmartAutoSuggestSearchMode.onNoLocalResults,
                  debounce: const Duration(milliseconds: 400),
                ),
                showListWhenEmpty: _showListWhenEmpty,
                listMaxHeight: double.infinity, // fills the Expanded
                decoration: InputDecoration(
                  labelText: 'Search fruits',
                  hintText: 'Type to filter...',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _selected != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _selected = null),
                        )
                      : null,
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
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────────────────────────────────────

Widget _sectionHeader(
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
