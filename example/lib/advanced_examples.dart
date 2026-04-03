import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';

import 'data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Advanced examples
// ─────────────────────────────────────────────────────────────────────────────

class AdvancedExamplesDemo extends StatelessWidget {
  const AdvancedExamplesDemo({super.key});

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
            label: const Text('Open BottomSheet'),
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
          const SizedBox(height: 32),

          // ── 5. Highlight Text + Custom builder ──────────────────────────
          sectionHeader(
            context,
            title: '5. Highlight + Item Builder',
            subtitle:
                'Matching text is highlighted in bold. Items use the '
                'builder callback with Focus wrapping.',
          ),
          const SizedBox(height: 8),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: (context, value) => SmartAutoSuggestItem(
                key: value,
                value: value,
                label: value[0].toUpperCase() + value.substring(1),
                builder: (context, searchText) {
                  final label = value[0].toUpperCase() + value.substring(1);
                  final emoji = fruitEmojis[value] ?? '';
                  return ListTile(
                    leading: Text(emoji, style: const TextStyle(fontSize: 20)),
                    title: SmartAutoSuggestHighlightText(
                      text: label,
                      query: searchText,
                    ),
                    subtitle: Text(
                      'key: $value',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  );
                },
              ),
              initialList: (context) => fruits,
            ),
            tileHeight: 64,
            decoration: const InputDecoration(
              labelText: 'Search fruits',
              hintText: 'Type to see highlighting...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.highlight),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 6. Builder Variants ────────────────────────────────────────
          sectionHeader(
            context,
            title: '6. Builder Variants',
            subtitle:
                'Different builder patterns: simple with highlight, '
                'rich card layout, and builder with onFocusChange.',
          ),
          const SizedBox(height: 8),

          // 6a – Rich card builder
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              '6a. Rich card builder',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: (context, value) => SmartAutoSuggestItem(
                key: value,
                value: value,
                label: value[0].toUpperCase() + value.substring(1),
                builder: (context, searchText) {
                  final label = value[0].toUpperCase() + value.substring(1);
                  final emoji = fruitEmojis[value] ?? '';
                  final colors = [
                    Colors.red,
                    Colors.orange,
                    Colors.green,
                    Colors.purple,
                    Colors.blue,
                  ];
                  final color = colors[label.length % colors.length];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: color.withValues(alpha: .15),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SmartAutoSuggestHighlightText(
                                text: label,
                                query: searchText,
                                matchStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                              Text(
                                '${label.length} characters',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: .1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            value.substring(0, 2).toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              initialList: (context) => fruits,
            ),
            tileHeight: 56,
            decoration: const InputDecoration(
              labelText: 'Rich card builder',
              hintText: 'Type to see rich cards...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.style),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 16),

          // 6b – Builder with onFocusChange
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              '6b. Builder with onFocusChange',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          SmartAutoSuggestBox<String>(
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: (context, value) {
                final label = value[0].toUpperCase() + value.substring(1);
                return SmartAutoSuggestItem(
                  key: value,
                  value: value,
                  label: label,
                  onFocusChange: (focused) {
                    // e.g. log, preload image, etc.
                  },
                  builder: (context, searchText) {
                    final emoji = fruitEmojis[value] ?? '';
                    return ListTile(
                      dense: true,
                      leading: Text(
                        emoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: SmartAutoSuggestHighlightText(
                        text: label,
                        query: searchText,
                      ),
                      subtitle: Text(
                        'Focused items trigger onFocusChange',
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    );
                  },
                );
              },
              initialList: (context) => fruits,
            ),
            tileHeight: 64,
            decoration: const InputDecoration(
              labelText: 'Focus-aware builder',
              hintText: 'Arrow keys trigger onFocusChange...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.keyboard),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 32),

          // ── 7. Full Theme Customization ────────────────────────────────
          sectionHeader(
            context,
            title: '7. Full Theme Customization',
            subtitle:
                'Per-widget theme overrides showing every customizable '
                'property of SmartAutoSuggestTheme.',
          ),
          const SizedBox(height: 8),

          // 7a – Rounded overlay with tinted tiles
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              '7a. Rounded overlay + tinted tiles',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          SmartAutoSuggestBox<String>(
            theme: SmartAutoSuggestTheme(
              overlayColor: Colors.indigo.shade50,
              overlayCardColor: Colors.white,
              overlayShadows: [
                BoxShadow(
                  color: Colors.indigo.withValues(alpha: .2),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              overlayBorderRadius: BorderRadius.circular(16),
              overlayMargin: 12,
              tileColor: Colors.indigo.shade50,
              selectedTileColor: Colors.indigo.shade100,
              selectedTileTextColor: Colors.indigo.shade900,
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              tileSubtitleStyle: TextStyle(
                color: Colors.indigo.shade300,
                fontSize: 12,
              ),
              progressIndicatorHeight: 3,
              progressIndicatorColor: Colors.indigo,
              dividerIndent: 16,
              disabledItemColor: Colors.indigo.shade200,
            ),
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            decoration: InputDecoration(
              labelText: 'Indigo theme',
              hintText: 'Rounded overlay with indigo tint...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              prefixIcon: const Icon(Icons.palette),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 16),

          // 7b – Flat / no-shadow theme
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              '7b. Flat / bordered overlay (no shadows)',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          SmartAutoSuggestBox<String>(
            theme: SmartAutoSuggestTheme(
              overlayColor: Colors.white,
              overlayCardColor: Colors.white,
              overlayShadows: const [], // no shadows
              overlayBorderRadius: BorderRadius.circular(8),
              overlayMargin: 4,
              tileColor: Colors.white,
              selectedTileColor: Colors.teal.shade50,
              selectedTileTextColor: Colors.teal.shade900,
              tilePadding: const EdgeInsets.all(8),
              tileSubtitleStyle: TextStyle(color: Colors.grey.shade500),
              noResultsSubtitleStyle: TextStyle(color: Colors.grey.shade400),
              loadingSubtitleStyle: TextStyle(
                fontSize: 13,
                color: Colors.teal.shade300,
              ),
              progressIndicatorHeight: 2,
              progressIndicatorColor: Colors.teal,
              dividerIndent: 0,
              disabledItemColor: Colors.grey.shade300,
            ),
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: fruitItemBuilder,
              initialList: (context) => fruits,
            ),
            decoration: InputDecoration(
              labelText: 'Flat teal theme',
              hintText: 'No shadows, bordered overlay...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixIcon: const Icon(Icons.square_outlined),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 16),

          // 7c – Dark-style on light background
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              '7c. Dark overlay on light screen',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          SmartAutoSuggestBox<String>(
            theme: SmartAutoSuggestTheme(
              overlayColor: const Color(0xFF1E1E2E),
              overlayCardColor: const Color(0xFF1E1E2E),
              overlayShadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
              overlayBorderRadius: BorderRadius.circular(12),
              overlayMargin: 8,
              tileColor: const Color(0xFF1E1E2E),
              selectedTileColor: const Color(0xFF313244),
              selectedTileTextColor: const Color(0xFFCDD6F4),
              tilePadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              tileSubtitleStyle: const TextStyle(
                color: Color(0xFF6C7086),
              ),
              noResultsSubtitleStyle: const TextStyle(
                color: Color(0xFF6C7086),
              ),
              loadingSubtitleStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFFA6ADC8),
              ),
              progressIndicatorHeight: 3,
              progressIndicatorColor: const Color(0xFFCBA6F7),
              dividerIndent: 12,
              disabledItemColor: const Color(0xFF585B70),
            ),
            dataSource: SmartAutoSuggestDataSource(
              itemBuilder: (context, value) => SmartAutoSuggestItem(
                key: value,
                value: value,
                label: value[0].toUpperCase() + value.substring(1),
                builder: (context, searchText) {
                  final label = value[0].toUpperCase() + value.substring(1);
                  return ListTile(
                    dense: true,
                    leading: Text(
                      fruitEmojis[value] ?? '',
                      style: const TextStyle(fontSize: 20),
                    ),
                    title: SmartAutoSuggestHighlightText(
                      text: label,
                      query: searchText,
                      baseStyle: const TextStyle(
                        color: Color(0xFFCDD6F4),
                      ),
                      matchStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCBA6F7),
                      ),
                    ),
                  );
                },
              ),
              initialList: (context) => fruits,
            ),
            tileHeight: 48,
            decoration: InputDecoration(
              labelText: 'Dark overlay theme',
              hintText: 'Catppuccin-style dark overlay...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.dark_mode),
            ),
            onSelected: (item) {},
          ),
          const SizedBox(height: 16),

          // 7d – Theme via ThemeData (global)
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              '7d. Global theme via ThemeData',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerLow,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This widget uses the global SmartAutoSuggestTheme '
                    'registered in MaterialApp.theme.extensions.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SmartAutoSuggestBox<String>(
                    // No theme parameter -> uses ThemeData extension
                    dataSource: SmartAutoSuggestDataSource(
                      itemBuilder: fruitItemBuilder,
                      initialList: (context) => fruits,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Global theme',
                      hintText: 'Uses ThemeData extension...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.public),
                    ),
                    onSelected: (item) {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 7e – InlineView with listBorderSide
          const Padding(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            child: Text(
              '7e. SmartAutoSuggestView with custom listBorderSide',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          SizedBox(
            height: 300,
            child: SmartAutoSuggestView<String>(
              theme: SmartAutoSuggestTheme(
                listBorderSide: BorderSide(
                  color: Colors.orange.shade300,
                  width: 2,
                ),
                tileColor: Colors.orange.shade50,
                selectedTileColor: Colors.orange.shade100,
                selectedTileTextColor: Colors.orange.shade900,
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                noResultsSubtitleStyle: TextStyle(
                  color: Colors.orange.shade300,
                ),
                loadingSubtitleStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.orange.shade400,
                ),
                progressIndicatorColor: Colors.orange,
              ),
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => fruits,
              ),
              showListWhenEmpty: true,
              listMaxHeight: double.infinity,
              decoration: InputDecoration(
                labelText: 'Orange inline theme',
                hintText: 'Custom border between field and list...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.orange.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.orange.shade600,
                    width: 2,
                  ),
                ),
                prefixIcon: const Icon(Icons.list_alt),
              ),
              onSelected: (item) {},
            ),
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
