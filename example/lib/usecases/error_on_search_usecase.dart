import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class ErrorOnSearchUseCase extends StatelessWidget {
  const ErrorOnSearchUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (context) => [],
          onSearch: (context, current, searchText) async {
            // Simulate network delay
            await Future.delayed(const Duration(seconds: 1));
            // Simulate a network or API error
            throw Exception('فشل في الاتصال بالخادم. يرجى المحاولة مرة أخرى.');
          },
          debounce: const Duration(milliseconds: 500),
        ),
        decoration: const InputDecoration(
          labelText: 'Search (forces an error)',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}''';

class ErrorOnSearchUseCase extends StatelessWidget {
  const ErrorOnSearchUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'onSearch Error',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (context) => [],
                onSearch: (context, current, searchText) async {
                  // Simulate network delay
                  await Future.delayed(const Duration(seconds: 1));
                  // Simulate a network or API error
                  throw Exception('فشل في الاتصال بالخادم. يرجى المحاولة مرة أخرى.');
                },
                debounce: const Duration(milliseconds: 500),
              ),
              decoration: const InputDecoration(
                labelText: 'Search (forces an error)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
