import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';

import 'data.dart';

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
                  itemBuilder: fruitItemBuilder,
                  initialList: (context) => fruits,
                  onSearch: (context, current, searchText) async {
                    // Simulate server returning extra items
                    await Future.delayed(const Duration(milliseconds: 700));
                    return ['server_${searchText ?? ''}'];
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
