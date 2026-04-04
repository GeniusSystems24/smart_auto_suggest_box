import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class SearchModeAlwaysUseCase extends StatelessWidget {
  const SearchModeAlwaysUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => fruits,
          onSearch: (context, current, searchText) async {
            // Triggered on every keystroke
            await Future.delayed(const Duration(milliseconds: 500));
            final q = (searchText ?? '').toLowerCase();
            return fruits.where((f) => f.contains(q)).toList();
          },
          searchMode: SmartAutoSuggestSearchMode.always,
          debounce: const Duration(milliseconds: 600),
        ),
        decoration: const InputDecoration(
          labelText: 'Search mode: always',
          border: OutlineInputBorder(),
        ),
        onSelected: (item) {},
      ),
    );
  }
}''';

class SearchModeAlwaysUseCase extends StatelessWidget {
  const SearchModeAlwaysUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Search Mode always',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => fruits,
                onSearch: (context, current, searchText) async {
                  await Future.delayed(const Duration(milliseconds: 500));
                  final q = (searchText ?? '').toLowerCase();
                  return fruits.where((f) => f.contains(q)).toList();
                },
                searchMode: SmartAutoSuggestSearchMode.always,
                debounce: const Duration(milliseconds: 600),
              ),
              decoration: const InputDecoration(
                labelText: 'Search mode: always',
                border: OutlineInputBorder(),
              ),
              onSelected: (item) {},
            ),
          ],
        ),
      ),
    );
  }
}
