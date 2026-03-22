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
          AdvancedExamplesDemo(),
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
          NavigationDestination(
            icon: Icon(Icons.auto_awesome),
            label: 'Examples',
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
          _sectionHeader(
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
          _sectionHeader(
            context,
            title: '2. Custom No-Results View',
            subtitle:
                'Shows a custom widget when no items match. '
                'Try typing something that doesn\'t exist.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              initialList: (context) => _fruits,
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
          _sectionHeader(
            context,
            title: '3. Custom Item Builder',
            subtitle:
                'Custom tile with leading icon, subtitle, and trailing badge.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              initialList: (context) => _fruitsWithEmoji,
            ),
            tileHeight: 72,
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Type to filter...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            itemBuilder: (context, item) {
              final emoji = _fruitEmojis[item.value] ?? '';
              final colors = [
                Colors.red,
                Colors.orange,
                Colors.green,
                Colors.purple,
                Colors.blue,
              ];
              final color =
                  colors[item.label.length % colors.length];
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
          _sectionHeader(
            context,
            title: '4. Custom Loading View',
            subtitle:
                'Custom shimmer-style placeholder while searching server. '
                'Type something to trigger.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              initialList: (context) => [],
              onSearch: (context, current, searchText) async {
                await Future.delayed(const Duration(seconds: 2));
                return _fruits
                    .where((f) => f.label
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
                      _shimmerRow(context),
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
                        initialList: (context) => _fruits,
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

Widget _shimmerRow(BuildContext context) {
  final color =
      Theme.of(context).colorScheme.onSurface.withValues(alpha: .08);
  return Row(
    children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 12, width: double.infinity, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
            const SizedBox(height: 6),
            Container(height: 10, width: 120, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
          ],
        ),
      ),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sample data with emojis for custom item builder
// ─────────────────────────────────────────────────────────────────────────────

const _fruitEmojis = <String, String>{
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

List<SmartAutoSuggestItem<String>> get _fruitsWithEmoji => _fruits
    .map((f) => SmartAutoSuggestItem(
          value: f.value,
          label: f.label,
          child: Text('${_fruitEmojis[f.value] ?? ''} ${f.label}'),
        ))
    .toList();

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
