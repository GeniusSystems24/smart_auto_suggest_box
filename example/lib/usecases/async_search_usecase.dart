import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class AsyncSearchUseCase extends StatelessWidget {
  const AsyncSearchUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => [], // start empty
          onSearch: (context, currentItems, searchText) async {
            // Simulate network delay
            await Future.delayed(const Duration(seconds: 1));
            final q = (searchText ?? '').toLowerCase();
            return fruits.where((f) => f.contains(q)).toList();
          },
          debounce: const Duration(milliseconds: 500),
        ),
        decoration: const InputDecoration(
          labelText: 'Async Server Search',
          border: OutlineInputBorder(),
        ),
        onSelected: (item) {},
      ),
    );
  }
}''';

class AsyncSearchUseCase extends StatelessWidget {
  const AsyncSearchUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Async Server Search',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => [],
                onSearch: (context, currentItems, searchText) async {
                  await Future.delayed(const Duration(seconds: 1));
                  final q = (searchText ?? '').toLowerCase();
                  return fruits.where((f) => f.contains(q)).toList();
                },
                debounce: const Duration(milliseconds: 500),
              ),
              decoration: const InputDecoration(
                labelText: 'Async Server Search',
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
