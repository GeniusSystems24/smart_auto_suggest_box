import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_view.dart';

import 'data.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SmartAutoSuggestView demo (inline list)
// ─────────────────────────────────────────────────────────────────────────────

class SmartAutoSuggestViewDemo extends StatelessWidget {
  const SmartAutoSuggestViewDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartAutoSuggestView'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SmartAutoSuggestView<String>(
          dataSource: SmartAutoSuggestDataSource(
            itemBuilder: fruitItemBuilder,
            initialList: (context) => fruits,
            onSearch: (context, current, searchText) async {
              await Future.delayed(const Duration(milliseconds: 700));
              return ['server_${searchText ?? ''}'];
            },
            searchMode: SmartAutoSuggestSearchMode.onNoLocalResults,
            debounce: const Duration(milliseconds: 400),
          ),
          showListWhenEmpty: true,
          listMaxHeight: double.infinity,
          decoration: const InputDecoration(
            labelText: 'Search fruits',
            hintText: 'Type to filter...',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
          ),
          onSelected: (item) {},
        ),
      ),
    );
  }
}
