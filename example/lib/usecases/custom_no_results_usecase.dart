import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../code_preview_scaffold.dart';
import '../data.dart';

const String _code = '''import 'package:flutter/material.dart';
import 'package:smart_auto_suggest_box/smart_auto_suggest_box.dart';
import '../data.dart';

class CustomNoResultsUseCase extends StatelessWidget {
  const CustomNoResultsUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SmartAutoSuggestBox<String>(
        dataSource: SmartAutoSuggestDataSource(
          itemBuilder: fruitItemBuilder,
          initialList: (c) => fruits,
        ),
        noResultsFoundBuilder: (context) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.search_off, size: 40),
                const SizedBox(height: 8),
                const Text('No matching results'),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Action clicked!')),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add new'),
                ),
              ],
            ),
          );
        },
        decoration: const InputDecoration(
          labelText: 'Type something to see custom no-results',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}''';

class CustomNoResultsUseCase extends StatelessWidget {
  const CustomNoResultsUseCase({super.key});

  @override
  Widget build(BuildContext context) {
    return CodePreviewScaffold(
      title: 'Custom No-Results View',
      code: _code,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SmartAutoSuggestBox<String>(
              dataSource: SmartAutoSuggestDataSource(
                itemBuilder: fruitItemBuilder,
                initialList: (c) => fruits,
              ),
              noResultsFoundBuilder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.search_off, size: 40),
                      const SizedBox(height: 8),
                      const Text('No matching results'),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Action clicked!')),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add new'),
                      ),
                    ],
                  ),
                );
              },
              decoration: const InputDecoration(
                labelText: 'Type something to see custom no-results',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
